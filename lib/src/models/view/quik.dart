import "dart:math";
import "dart:ui";

/// A vector of joint angles, in radians.
typedef Joints = List<double>;

/// A planar implementation of the QuIK inverse kinematics algorithm.
///
/// QuIK ("Quick Inverse Kinematics") replaces the linear Newton step with a
/// quadratic estimate of the robot's kinematics, using the second derivative of
/// the fingertip position as well as the first. That converges from further
/// away, and lands more reliably, than a plain damped Newton step. The method
/// is described in S. Lloyd, R. Irani, and M. Ahmadi, "Fast and Robust Inverse
/// Kinematics of Serial Robots using Halley's Method" (IEEE Transactions on
/// Robotics, 2022).
///
/// The solver works for any number of joints that position a 2D fingertip.
/// When the chain has more joints than the fingertip has coordinates, the
/// damped inverse gives the smallest joint step that moves the fingertip, so
/// every joint can take part in the reach.
class QuikSolver {
  /// Creates a solver for a chain with [joints] joint angles.
  ///
  /// [fingers] returns the fingertip position for a vector of angles, or null
  /// when the linkage cannot close at those angles. [reach] is the length of
  /// the arm, used to limit how far a single iteration may step.
  QuikSolver({required this.joints, required this.fingers, required this.reach})
    : assert(joints > 0, "A chain needs at least one joint.");

  /// How many joint angles the chain has.
  final int joints;

  /// The forward kinematics of the arm.
  final Offset? Function(Joints angles) fingers;

  /// The furthest the fingertip can reach, in meters.
  final double reach;

  /// The largest error to solve for in one step, in meters.
  ///
  /// QuIK recommends limiting the step to about a third of the robot's size so
  /// a distant target is approached in a few stable pieces.
  double get maxStep => reach * 0.33;

  /// The fingertip error at which the solution is close enough, in meters.
  static const tolerance = 1e-4;

  /// The smallest joint step worth taking, in radians.
  static const minStep = 1e-9;

  /// The damping added to the inverted Jacobian, for stability at singularities.
  static const damping = 1e-6;

  /// The number of iterations to try before giving up.
  static const maxIterations = 30;

  /// Solves for the angles that put the fingertip at [target].
  ///
  /// Starts from [guess] and returns null if the linkage cannot close or the
  /// solver does not converge, so the caller can try another seed.
  Joints? solve(Offset target, Joints guess) {
    assert(guess.length == joints, "There must be one guess per joint.");
    final angles = List<double>.of(guess);

    for (var iteration = 0; iteration < maxIterations; iteration++) {
      final position = fingers(angles);
      if (position == null) return null;

      final positionError = (target - position).distance;
      if (positionError <= tolerance) return angles;

      var error = target - position;
      if (error.distance > maxStep) {
        error = error / error.distance * maxStep;
      }

      final jacobian = _jacobian(angles);
      if (jacobian == null) return null;

      // QuIK: take half a Newton step, then bend the Jacobian with the
      // Hessian in that direction before solving for the full step.
      final halfStep = _solve(jacobian, error * 0.5);
      final curved = _curvedJacobian(angles, halfStep);
      if (curved == null) return null;

      // The quadratic step can overshoot where the linkage folds back on
      // itself. Shorten it until it improves the pose, and fall back to the
      // plain Newton direction if it never does.
      final quikStep = _solve(curved, error);
      var step = _shorten(target, angles, quikStep, positionError);
      step ??= _shorten(target, angles, _solve(jacobian, error), positionError);
      if (step == null) return null;

      for (var joint = 0; joint < joints; joint++) {
        angles[joint] += step[joint];
      }

      final stepSize = sqrt(
        step.fold<double>(0, (sum, angle) => sum + angle * angle),
      );
      if (stepSize < minStep) {
        final end = fingers(angles);
        if (end == null || (target - end).distance > tolerance) return null;
        return angles;
      }
    }

    final position = fingers(angles);
    if (position == null || (target - position).distance > tolerance) {
      return null;
    }
    return angles;
  }

  /// The longest part of [step] that brings the fingertip closer to [target].
  ///
  /// Returns null when no fraction of the step improves the current error.
  Joints? _shorten(
    Offset target,
    Joints angles,
    Joints step,
    double currentError,
  ) {
    for (var scale = 1.0; scale > 1e-3; scale /= 2) {
      final moved = List<double>.of(angles);
      for (var joint = 0; joint < joints; joint++) {
        moved[joint] += step[joint] * scale;
      }

      final position = fingers(moved);
      if (position == null) continue;
      if ((target - position).distance < currentError) {
        return [
          for (var joint = 0; joint < joints; joint++) step[joint] * scale,
        ];
      }
    }
    return null;
  }

  /// The Jacobian of the fingertip position at [angles].
  _Jacobian? _jacobian(Joints angles) {
    const h = 1e-4;
    final x = <double>[];
    final y = <double>[];
    for (var joint = 0; joint < joints; joint++) {
      final plus = List<double>.of(angles)..[joint] += h;
      final minus = List<double>.of(angles)..[joint] -= h;
      final forward = fingers(plus);
      final backward = fingers(minus);
      if (forward == null || backward == null) return null;
      final difference = (forward - backward) / (2 * h);
      x.add(difference.dx);
      y.add(difference.dy);
    }
    return (x: x, y: y);
  }

  /// The Jacobian plus its derivative in the direction of [step].
  ///
  /// This is QuIK's `H * dQ` term: each column of the Jacobian is
  /// differentiated with respect to every joint, then scaled by the half step.
  _Jacobian? _curvedJacobian(Joints angles, Joints step) {
    const h = 1e-4;
    final base = _jacobian(angles);
    if (base == null) return null;
    final x = List<double>.of(base.x);
    final y = List<double>.of(base.y);

    for (var joint = 0; joint < joints; joint++) {
      if (step[joint] == 0) continue;
      final plus = List<double>.of(angles)..[joint] += h;
      final minus = List<double>.of(angles)..[joint] -= h;
      final forward = _jacobian(plus);
      final backward = _jacobian(minus);
      if (forward == null || backward == null) return null;

      for (var column = 0; column < joints; column++) {
        final dx = (forward.x[column] - backward.x[column]) / (2 * h);
        final dy = (forward.y[column] - backward.y[column]) / (2 * h);
        x[column] += dx * step[joint];
        y[column] += dy * step[joint];
      }
    }
    return (x: x, y: y);
  }

  /// Solves `matrix * step = error` with QuIK's damped inverse.
  ///
  /// QuIK forms `J * J^T + lambda^2 * I` and solves that instead of squaring
  /// the (possibly singular) Jacobian, which keeps the step finite near
  /// singularities and gives the smallest step for a redundant chain.
  Joints _solve(_Jacobian jacobian, Offset error) {
    var p = damping;
    var q = 0.0;
    var r = damping;
    for (var joint = 0; joint < joints; joint++) {
      p += jacobian.x[joint] * jacobian.x[joint];
      q += jacobian.x[joint] * jacobian.y[joint];
      r += jacobian.y[joint] * jacobian.y[joint];
    }
    final determinant = p * r - q * q;

    // The damping keeps the determinant positive, but guard against a bad
    // finite difference anyway.
    if (determinant.abs() < 1e-18) return List<double>.filled(joints, 0);

    final yx = (r * error.dx - q * error.dy) / determinant;
    final yy = (p * error.dy - q * error.dx) / determinant;
    return [
      for (var joint = 0; joint < joints; joint++)
        jacobian.x[joint] * yx + jacobian.y[joint] * yy,
    ];
  }
}

/// A 2-row Jacobian: the derivative of each fingertip coordinate per joint.
typedef _Jacobian = ({List<double> x, List<double> y});
