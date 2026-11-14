import "dart:async";
import "dart:math";

import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

import "arm3d.dart";

/// The input angles of the arm, in radians.
///
/// The swivel turns the whole arm about the vertical axis. The shoulder motor
/// drives the upper bar, measured from the positive X-axis of the arm's plane.
/// The lower motor sits on a link that pivots at the base, so its angle is
/// measured relative to that moving mount rather than from the base. The wrist
/// pitch turns the gripper relative to the forearm. The forearm roll, wrist
/// roll, and gripper do not change where the arm points, so they are not part
/// of these angles.
typedef ArmAngles = ({
  double swivel,
  double shoulder,
  double elbow,
  double pitch,
});

/// The pose of the arm in the vertical plane the swivel faces, in meters.
///
/// X points away from the base and Y points up, both measured from the upper
/// motor's pivot. `pivot` is the lower motor's fixed base pin, `elbow` is the
/// lower bar's pivot at the end of the motor mount, and `bracket` and `rear`
/// are the two top pins of the four-bar. `output` is the front top pin, where
/// the forearm is mounted parallel to the coupler.
typedef ArmPlanarPose = ({
  Offset shoulder,
  Offset pivot,
  Offset elbow,
  Offset bracket,
  Offset rear,
  Offset output,
  Offset wrist,
  Offset fingers,
  double forearmAngle,
});

/// The angles that reach a target, with the forearm mount and motor mount they
/// put the arm at. Two motor-mount assemblies can share the same bar angles,
/// and the mount tells them apart.
typedef ArmSolution = ({ArmAngles angles, Offset output, Offset mount});

/// A pose that reaches a point under the mouse.
typedef ArmPlan = ({
  ArmAngles angles,
  Offset output,
  Offset mount,
  ArmVector point,
});

/// The view model for the arm page.
///
/// The first two joints are the two bars of the four-bar linkage: their top
/// pins carry one rigid coupler bar, and the next arm bar is mounted on the
/// coupler's front pin, parallel to it. The lower motor is carried on a link
/// that is pinned to the base, so that link takes up the difference when the
/// two bars move independently; the lower motor's angle is measured relative
/// to that moving link.
///
/// Clicking the 3D view solves the shoulder angle, the lower motor angle, and
/// the wrist pitch for that fingertip position. When a point is beyond straight
/// up, the base turns half a turn and the arm reaches it from the other side
/// instead of leaning backwards.
class ArmModel with ChangeNotifier {
  /// The latest telemetry from the arm.
  ArmData get arm => models.rover.metrics.arm.data;

  /// The length of each link, as configured on the settings page.
  ArmLengths get lengths => models.settings.arm.lengths;

  /// The timer that refreshes this page.
  Timer? timer;

  /// The state that the user wants to set the laser to.
  bool desiredLaserState = false;

  /// The joint angles that put the fingertip at the mouse, if they exist.
  ArmAngles? ikAngles;

  /// The motor mount that goes with [ikAngles], if there is a preview.
  Offset? ikMount;

  /// The last pose the page sent to the arm.
  ArmAngles? commanded;

  /// The camera looking at the arm from any angle.
  final ArmCamera camera = ArmCamera();

  /// The 3D point under the mouse on the arm's plane, if it is over the view.
  ArmVector? hoverTarget;

  /// The swivel the user is setting, until the arm reports it.
  double? pendingSwivel;

  /// The height of the shoulder pivots above the floor, in meters.
  static const baseHeight = 0.1;

  /// The lowest the fingertip may go, in meters above the shoulder pivots.
  static const floorClearance = -0.03;

  /// How far the forearm may lean back past straight up, as a cosine.
  ///
  /// The arm cannot rotate past straight up in its own plane, so anything that
  /// would need it to lean further back is reached by turning the base.
  static const _backwardLean = 0.02;

  /// The pose used when the arm reports angles that cannot close the loop.
  static const _restAngles = (
    swivel: 0.0,
    shoulder: pi / 3,
    elbow: pi / 3,
    pitch: 0.0,
  );

  /// Starts with the arm's current laser state and refreshes 100 times a second.
  ArmModel() {
    desiredLaserState = arm.laserState.toBool();
    timer = Timer.periodic(const Duration(milliseconds: 10), _update);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _update([_]) {
    if (desiredLaserState != arm.laserState.toBool()) {
      final command = ArmCommand(
        laserState: desiredLaserState ? BoolState.ON : BoolState.OFF,
      );
      models.messages.sendMessage(command);
    }
    final pending = pendingSwivel;
    final reported = _telemetryAngles;
    if (pending != null &&
        reported != null &&
        _wrap(reported.swivel - pending).abs() < 0.03) {
      pendingSwivel = null;
    }
    notifyListeners();
  }

  /// Sets the laser on or off.
  void setLaser({required bool laser}) {
    desiredLaserState = laser;
    final command = ArmCommand(
      laserState: desiredLaserState ? BoolState.ON : BoolState.OFF,
    );
    models.messages.sendMessage(command);
  }

  /// The CubeMars feedback the arm is reporting.
  ArmTelemetry get telemetry => models.rover.metrics.arm.telemetry;

  /// The pose the CubeMars motors report, if they are all reporting.
  ///
  /// Each motor reports the angle of its own shaft, so divide by the joint's
  /// gear ratio to get the joint's angle.
  ArmAngles? get _telemetryAngles {
    final telemetry = this.telemetry;
    const required = [
      ArmMotor.swivel,
      ArmMotor.shoulder,
      ArmMotor.elbow,
      ArmMotor.wristPitch,
    ];
    if (required.any((motor) => telemetry[motor] == null)) return null;

    final settings = models.settings.arm;
    double joint(ArmMotor motor, double gearRatio) =>
        telemetry[motor]!.radians(gearRatio);
    return (
      swivel: joint(ArmMotor.swivel, settings.swivelGearRatio),
      shoulder: joint(ArmMotor.shoulder, settings.shoulderGearRatio),
      elbow: joint(ArmMotor.elbow, settings.elbowGearRatio),
      pitch: joint(ArmMotor.wristPitch, settings.liftGearRatio),
    );
  }

  /// The pose the page draws.
  ///
  /// While the arm is reporting, that is its telemetry. Before anything reports
  /// - or when only some joints do - the page shows the last pose it commanded,
  /// so a click visibly moves the arm.
  ArmAngles get angles {
    final reported = _telemetryAngles;
    if (reported != null) return reported;

    final commanded = this.commanded;
    final reporting =
        arm.hasBase() || arm.hasShoulder() || arm.hasJointAngles();
    if (commanded != null && !reporting) return commanded;

    // Before anything reports, show the non-singular rest pose instead of the
    // zeroed-out arm data, which sits exactly on the linkage's toggle.
    if (!reporting) return _restAngles;

    // Older builds report joint angles directly; the CubeMars firmware reports
    // each motor instead, which [_telemetryAngles] handles above.
    if (arm.hasJointAngles()) {
      final joints = arm.jointAngles;
      double angle(double single, double? multi) => multi ?? single;
      return (
        swivel: angle(
          joints.swivelSingle,
          joints.hasSwivelMulti() ? joints.swivelMulti : null,
        ),
        shoulder: angle(
          joints.shoulderSingle,
          joints.hasShoulderMulti() ? joints.shoulderMulti : null,
        ),
        elbow: angle(
          joints.elbowSingle,
          joints.hasElbowMulti() ? joints.elbowMulti : null,
        ),
        pitch: angle(
          joints.wristPitchSingle,
          joints.hasWristPitchMulti() ? joints.wristPitchMulti : null,
        ),
      );
    }

    return (
      swivel: arm.base.currentAngle,
      shoulder: arm.shoulder.currentAngle,
      elbow: arm.elbow.currentAngle,
      pitch: arm.hasWrist() ? arm.wrist.pitchAngle : arm.lift.currentAngle,
    );
  }

  /// A unit vector at [angle], in radians from the positive X-axis.
  static Offset _direction(double angle) => Offset(cos(angle), sin(angle));

  /// Rotates [vector] counterclockwise by [angle].
  static Offset _rotate(Offset vector, double angle) => Offset(
    vector.dx * cos(angle) - vector.dy * sin(angle),
    vector.dx * sin(angle) + vector.dy * cos(angle),
  );

  /// The points where links of [firstLength] and [secondLength] meet.
  ///
  /// Two points satisfy both lengths. Returns an empty list when the circles do
  /// not meet, which means those links cannot span the pivots.
  static List<Offset> _jointOptions(
    Offset first,
    double firstLength,
    Offset second,
    double secondLength,
  ) {
    final delta = second - first;
    final span = delta.distance;
    const tolerance = 1e-9;
    if (span < tolerance) return const [];
    if (span > firstLength + secondLength + tolerance) return const [];
    if (span < (firstLength - secondLength).abs() - tolerance) return const [];

    final along =
        (firstLength * firstLength -
            secondLength * secondLength +
            span * span) /
        (2 * span);
    final height = sqrt(max(0.0, firstLength * firstLength - along * along));
    final middle = first + delta * (along / span);
    final normal = Offset(-delta.dy, delta.dx) / span;
    return [middle + normal * height, middle - normal * height];
  }

  /// The point where links of [firstLength] and [secondLength] meet.
  ///
  /// Two points satisfy both lengths. [near] keeps the arm on the assembly it
  /// is already in; without it the lower point is used, which is how the motor
  /// mount hangs below its base pin.
  static Offset? _joint(
    Offset first,
    double firstLength,
    Offset second,
    double secondLength, {
    Offset? near,
  }) {
    final options = _jointOptions(first, firstLength, second, secondLength);
    if (options.isEmpty) return null;
    if (options.length == 1) return options.first;
    final left = options.first;
    final right = options.last;
    if (near != null) {
      return (left - near).distance <= (right - near).distance ? left : right;
    }
    return left.dy <= right.dy ? left : right;
  }

  /// Solves the linkage for the given bar angles.
  ///
  /// The shoulder angle places the upper bar's top. The lower motor's angle
  /// (`angles.elbow`) is measured relative to its mount; the mount itself is
  /// free to rotate about its fixed base pin, and its angle is the one that
  /// makes the rigid coupler reach the upper bar's top. Returns null if no
  /// mount angle closes the loop, or if the two bars would cross. [nearMount]
  /// keeps the arm on its current assembly when the mount has two possible
  /// positions.
  static ArmPlanarPose? planarPose(
    ArmAngles angles,
    ArmLengths lengths, {
    Offset? nearMount,
  }) {
    const shoulder = Offset.zero;
    final pivot = Offset(-lengths.base, 0);
    final bracket = shoulder + _direction(angles.shoulder) * lengths.bar;

    // From the mount's base pin, the motor mount and lower bar add up to a
    // vector whose length is fixed by the motor angle; the mount only rotates
    // that sum. Intersect the possible rear pins with the coupler circle.
    final sum = Offset(
      lengths.mount + lengths.bar * cos(angles.elbow),
      lengths.bar * sin(angles.elbow),
    );
    final radius = sum.distance;
    if (radius < 1e-9) return null;
    final phase = atan2(sum.dy, sum.dx);
    final nearRear = nearMount == null
        ? null
        : _rotate(sum, atan2(nearMount.dy, nearMount.dx));
    final rearVector = _joint(
      Offset.zero,
      radius,
      bracket - pivot,
      lengths.bracket,
      near: nearRear,
    );
    if (rearVector == null) return null;

    final mountAngle = atan2(rearVector.dy, rearVector.dx) - phase;
    final elbow = pivot + _direction(mountAngle) * lengths.mount;
    final rear = pivot + rearVector;

    // The two long bars are drawn in one plane, so they may not cross.
    if (_segmentsIntersect(shoulder, bracket, elbow, rear)) return null;

    // The forearm is mounted on the front pin, parallel to the coupler.
    final forearmAngle = atan2(
      bracket.dy - rear.dy,
      bracket.dx - rear.dx,
    );
    final wrist = bracket + _direction(forearmAngle) * lengths.forearm;
    final fingers =
        wrist + _direction(forearmAngle + angles.pitch) * lengths.gripper;
    return (
      shoulder: shoulder,
      pivot: pivot,
      elbow: elbow,
      bracket: bracket,
      rear: rear,
      output: bracket,
      wrist: wrist,
      fingers: fingers,
      forearmAngle: forearmAngle,
    );
  }

  /// Where each joint sits in 3D for the given [angles].
  ///
  /// The swivel turns the whole arm about the Z-axis, and every joint turns in
  /// the vertical plane the swivel faces.
  static ArmPose3d? getPose3d(
    ArmAngles angles,
    ArmLengths lengths, {
    Offset? nearMount,
  }) {
    final planar = planarPose(angles, lengths, nearMount: nearMount);
    return planar == null ? null : _toPose3d(planar, angles.swivel);
  }

  /// Turns a planar pose into 3D at the given swivel.
  static ArmPose3d _toPose3d(ArmPlanarPose planar, double swivel) {
    final heading = ArmVector(cos(swivel), sin(swivel), 0);
    ArmVector at(Offset point) =>
        heading * point.dx + ArmVector.up * (point.dy + baseHeight);
    return (
      base: ArmVector.zero,
      shoulder: at(planar.shoulder),
      pivot: at(planar.pivot),
      elbow: at(planar.elbow),
      bracket: at(planar.bracket),
      rear: at(planar.rear),
      output: at(planar.output),
      wrist: at(planar.wrist),
      fingers: at(planar.fingers),
    );
  }

  /// The last pose that closed the loop, so the page always has one to draw.
  ArmPose3d? _lastPose;

  /// The motor mount of that pose, which keeps the arm on one assembly.
  Offset? _lastMount;

  /// Which side of the upper-bar toggle the arm is on: 1, -1, or null if the
  /// arm has not settled on an assembly yet.
  int? _upperSide;

  /// Which side of the motor-mount toggle the arm is on.
  int? _mountSide;

  /// Where each joint of the arm currently sits in 3D.
  ArmPose3d get pose3d {
    final planar = planarPose(angles, lengths, nearMount: _lastMount);
    if (planar != null) {
      _lastMount = planar.elbow - planar.pivot;
      _rememberSides(planar);
      return _lastPose = _toPose3d(planar, angles.swivel);
    }
    final rest = getPose3d(_restAngles, lengths, nearMount: _lastMount);
    if (rest != null) return _lastPose = rest;
    return _lastPose ?? _collapsedPose;
  }

  /// A pose with every joint at the shoulder, used if no pose can be closed.
  static const _collapsedPose = (
    base: ArmVector.zero,
    shoulder: ArmVector(0, 0, baseHeight),
    pivot: ArmVector(0, 0, baseHeight),
    elbow: ArmVector(0, 0, baseHeight),
    bracket: ArmVector(0, 0, baseHeight),
    rear: ArmVector(0, 0, baseHeight),
    output: ArmVector(0, 0, baseHeight),
    wrist: ArmVector(0, 0, baseHeight),
    fingers: ArmVector(0, 0, baseHeight),
  );

  /// The ghost of the pose that would reach the mouse, if there is one.
  ArmPose3d? get previewPose {
    final preview = ikAngles;
    if (preview == null) return null;
    return getPose3d(preview, lengths, nearMount: ikMount);
  }

  /// The 3D point under [local] on the vertical plane the arm faces.
  ///
  /// The four-bar and the wrist pitch can only reach points in the plane the
  /// swivel faces, so a click is projected onto that plane. Turning the base
  /// half a turn keeps the same plane, which is what lets the arm reach points
  /// beyond straight up.
  ArmVector? targetOnArmPlane(Offset local, Size size) {
    final swivel = angles.swivel;
    final normal = ArmVector(-sin(swivel), cos(swivel), 0);
    final ray = camera.ray(local, size);
    final denominator = ray.direction.dot(normal);
    if (denominator.abs() < 1e-9) return null;
    final distance = -ray.origin.dot(normal) / denominator;
    if (distance <= 0) return null;
    return ray.origin + ray.direction * distance;
  }

  /// Converts a point on the arm's plane to meters from the shoulder.
  Offset _toPlanar(ArmVector point) {
    final swivel = angles.swivel;
    return Offset(
      point.x * cos(swivel) + point.y * sin(swivel),
      point.z - baseHeight,
    );
  }

  /// The point under [local] in the arm's side view, in meters.
  Offset? planarTarget(Offset local, Size size) {
    final point = targetOnArmPlane(local, size);
    return point == null ? null : _toPlanar(point);
  }

  /// Orbits the 3D view.
  void orbit(Offset delta) {
    camera.orbit(delta);
    notifyListeners();
  }

  /// Zooms the 3D view.
  void zoom(double delta) {
    camera.zoom(delta);
    notifyListeners();
  }

  /// Puts the camera back at its default angle and distance.
  void resetCamera() {
    camera.reset();
    notifyListeners();
  }

  /// The side of the line [line] that [point] lies on: 1, -1, or 0 on the line.
  static int _side(Offset line, Offset point) {
    final cross = line.dx * point.dy - line.dy * point.dx;
    const epsilon = 1e-9;
    if (cross > epsilon) return 1;
    if (cross < -epsilon) return -1;
    return 0;
  }

  /// Remembers which assembly a pose is on, so the IK does not flip through a
  /// toggle and make a joint jump past its stop.
  void _rememberSides(ArmPlanarPose pose) {
    final upper = _side(pose.wrist, pose.bracket);
    final mount = _side(
      pose.rear - pose.pivot,
      pose.elbow - pose.pivot,
    );
    if (upper != 0) _upperSide = upper;
    if (mount != 0) _mountSide = mount;
  }

  /// Whether two line segments touch or cross anywhere.
  ///
  /// Touching counts: two links that end up collinear and overlapping look like
  /// a single stretched link, which is exactly the pose to keep out of the
  /// workspace.
  static bool _segmentsIntersect(
    Offset firstStart,
    Offset firstEnd,
    Offset secondStart,
    Offset secondEnd,
  ) {
    const epsilon = 1e-9;
    double side(Offset start, Offset end, Offset point) =>
        (end.dx - start.dx) * (point.dy - start.dy) -
        (end.dy - start.dy) * (point.dx - start.dx);
    double dot(Offset first, Offset second) =>
        first.dx * second.dx + first.dy * second.dy;
    bool within(Offset start, Offset end, Offset point) {
      final span = end - start;
      final offset = point - start;
      final length = span.distance;
      if (length < epsilon) return offset.distance < 1e-6;
      final along = dot(offset, span) / (length * length);
      if (along < -epsilon || along > 1 + epsilon) return false;
      return (point - (start + span * along)).distance < 1e-6;
    }

    final firstSide = side(firstStart, firstEnd, secondStart);
    final secondSide = side(firstStart, firstEnd, secondEnd);
    final thirdSide = side(secondStart, secondEnd, firstStart);
    final fourthSide = side(secondStart, secondEnd, firstEnd);
    if (((firstSide > epsilon && secondSide < -epsilon) ||
            (firstSide < -epsilon && secondSide > epsilon)) &&
        ((thirdSide > epsilon && fourthSide < -epsilon) ||
            (thirdSide < -epsilon && fourthSide > epsilon))) {
      return true;
    }
    return (firstSide.abs() <= epsilon &&
            within(firstStart, firstEnd, secondStart)) ||
        (secondSide.abs() <= epsilon &&
            within(firstStart, firstEnd, secondEnd)) ||
        (thirdSide.abs() <= epsilon &&
            within(secondStart, secondEnd, firstStart)) ||
        (fourthSide.abs() <= epsilon &&
            within(secondStart, secondEnd, firstEnd));
  }

  /// Solves the bar and wrist angles that put the fingertip at [target].
  ///
  /// [target] is in the arm's plane: X points away from the base and Y is the
  /// height above the shoulder pivots. [swivel] is the base angle the solution
  /// is for; it defaults to the arm's current swivel.
  ///
  /// The gripper aims straight out through the target, which puts the wrist one
  /// gripper length back from it. The upper bar and forearm then place the
  /// front top pin, the coupler places the rear top pin, and the lower bar and
  /// pivoting motor mount close the loop. Every combination is checked against
  /// the real forward kinematics, and the one nearest the arm's current pose is
  /// kept.
  ArmSolution? solveIK(Offset target, {double? swivel}) {
    final lengths = this.lengths;
    final baseSwivel = swivel ?? angles.swivel;
    final current = angles;
    final reach = lengths.bar + lengths.forearm + lengths.gripper;
    if (target.distance > reach + 0.02) return null;
    if (target.dy < floorClearance) return null;

    // The arm cannot lean past the base; the caller turns the base instead.
    if (target.dx < -0.02) return null;

    final radial = target.distance < 1e-6
        ? current.shoulder + current.elbow + current.pitch
        : atan2(target.dy, target.dx);
    final pivot = Offset(-lengths.base, 0);

    // Keep the arm on the assembly it is already on. The two fixes are the
    // straight upper-bar toggle and the motor-mount toggle; crossing either
    // would make a joint snap to the other side of its stop.
    final currentPose = planarPose(current, lengths, nearMount: _lastMount);
    final flipped = _wrap(baseSwivel - current.swivel).abs() > pi / 2;
    var currentUpper = currentPose == null
        ? _upperSide
        : _side(currentPose.wrist, currentPose.bracket);
    var currentMount = currentPose == null
        ? _mountSide
        : _side(
            currentPose.rear - currentPose.pivot,
            currentPose.elbow - currentPose.pivot,
          );
    if (currentUpper == 0) currentUpper = _upperSide;
    if (currentMount == 0) currentMount = _mountSide;
    if (flipped) {
      if (currentUpper != null) currentUpper = -currentUpper;
      if (currentMount != null) currentMount = -currentMount;
    }

    // The wrist can sit anywhere one gripper length from the target. Prefer
    // pointing the gripper straight out, but try every approach so the two
    // bars can use their full workspace.
    const approachSteps = 360;
    ArmSolution? best;
    var bestScore = double.infinity;
    for (var index = 0; index < approachSteps; index++) {
      final approach = -pi + 2 * pi * index / approachSteps;
      final wristTarget = target - _direction(approach) * lengths.gripper;

      // The upper bar and forearm place the front top pin.
      final frontOptions = _jointOptions(
        Offset.zero,
        lengths.bar,
        wristTarget,
        lengths.forearm,
      );
      for (final bracket in frontOptions) {
        final forearmAngle = atan2(
          wristTarget.dy - bracket.dy,
          wristTarget.dx - bracket.dx,
        );

        // Leaning the forearm past straight up needs the base turned instead.
        if (cos(forearmAngle) < -_backwardLean) continue;

        // The coupler runs back from the front pin to the rear pin.
        final rear =
            bracket - _direction(forearmAngle) * lengths.bracket;

        // Reject the other assembly: there is a stop between the two.
        if (currentUpper != null &&
            _side(wristTarget, bracket) != currentUpper) {
          continue;
        }

        // The lower bar and its pivoting motor mount close the loop.
        final pivots = _jointOptions(
          pivot,
          lengths.mount,
          rear,
          lengths.bar,
        );
        for (final elbow in pivots) {
          if (currentMount != null &&
              _side(rear - pivot, elbow - pivot) != currentMount) {
            continue;
          }
          final shoulder = atan2(bracket.dy, bracket.dx);
          final mount = elbow - pivot;
          final mountAngle = atan2(mount.dy, mount.dx);
          final lowerBar = atan2(
            rear.dy - elbow.dy,
            rear.dx - elbow.dx,
          );
          // The lower motor turns relative to its moving mount.
          final motorElbow = _wrap(lowerBar - mountAngle);
          final candidate = (
            swivel: baseSwivel,
            shoulder: _wrap(shoulder),
            elbow: motorElbow,
            pitch: _wrap(approach - forearmAngle),
          );

          // Only keep poses the real linkage can close and that reach the
          // point.
          final pose = planarPose(
            candidate,
            lengths,
            nearMount: mount,
          );
          if (pose == null) continue;
          if ((pose.fingers - target).distance > 1e-4) continue;

          final score =
              _wrap(candidate.shoulder - current.shoulder).abs() +
              _wrap(candidate.elbow - current.elbow).abs() +
              _wrap(candidate.pitch - current.pitch).abs() +
              0.05 * _wrap(approach - radial).abs();
          if (score < bestScore) {
            bestScore = score;
            best = (
              angles: candidate,
              output: pose.output,
              mount: mount,
            );
          }
        }
      }
    }
    return best;
  }

  /// Wraps [angle] into the range [-pi, pi].
  static double _wrap(double angle) => (angle + pi) % (2 * pi) - pi;

  /// Plans the poses that reach [point] on the arm's plane.
  ///
  /// The arm first tries the swivel it is already at. If the point needs the
  /// forearm to lean past straight up, it turns the base half a turn and
  /// reaches the point from the other side.
  ArmPlan? planFor(ArmVector point) {
    final swivel = angles.swivel;
    final radial = point.x * cos(swivel) + point.y * sin(swivel);
    final height = point.z - baseHeight;

    final forward = solveIK(Offset(radial, height), swivel: swivel);
    if (forward != null) {
      return (
        angles: forward.angles,
        output: forward.output,
        mount: forward.mount,
        point: point,
      );
    }

    final flipped = _wrap(swivel + pi);
    final solved = solveIK(Offset(-radial, height), swivel: flipped);
    return solved == null
        ? null
        : (
            angles: solved.angles,
            output: solved.output,
            mount: solved.mount,
            point: point,
          );
  }

  /// Plans a pose that reaches the point under [local].
  ArmPlan? plan(Offset local, Size size) {
    final point = targetOnArmPlane(local, size);
    return point == null ? null : planFor(point);
  }

  /// The target the preview was last solved for, in meters.
  Offset? _hoverTarget;

  /// Updates the target preview as the mouse moves over the 3D view.
  void onHover(Offset local, Size size) {
    final point = targetOnArmPlane(local, size);
    if (point == null) {
      cancelIK();
      return;
    }
    hoverTarget = point;
    final target = _toPlanar(point);
    if (_hoverTarget != null && (target - _hoverTarget!).distance < 0.005) {
      notifyListeners();
      return;
    }
    _hoverTarget = target;
    final planned = planFor(point);
    ikAngles = planned?.angles;
    ikMount = planned?.mount;
    if (planned != null) {
      final pose = planarPose(planned.angles, lengths, nearMount: planned.mount);
      if (pose != null) _rememberSides(pose);
    }
    notifyListeners();
  }

  /// Clears the target preview when the mouse leaves the 3D view.
  void cancelIK() {
    _hoverTarget = null;
    hoverTarget = null;
    ikAngles = null;
    ikMount = null;
    notifyListeners();
  }

  /// Moves the arm so its fingertip reaches the point under the mouse.
  ///
  /// The shoulder, the lower motor (relative to its moving mount), the wrist
  /// pitch, and - if the point is beyond straight up - the swivel are
  /// commanded. The motor mount itself is passive, so it is not commanded; the
  /// forearm roll, wrist roll, and gripper are not part of reaching a point
  /// either.
  void sendIK(Offset local, Size size) {
    final planned = plan(local, size);
    if (planned == null) return;
    final solved = planned.angles;
    final turns = _wrap(solved.swivel - angles.swivel).abs() > 1e-6;
    commanded = solved;
    _lastMount = planned.mount;
    final pose = planarPose(solved, lengths, nearMount: planned.mount);
    if (pose != null) _rememberSides(pose);
    if (turns) pendingSwivel = solved.swivel;
    models.messages.sendMessage(
      ArmCommand(
        usingIk: BoolState.NO,
        swivel: turns ? MotorCommand(angle: solved.swivel) : null,
        shoulder: MotorCommand(angle: solved.shoulder),
        elbow: MotorCommand(angle: solved.elbow),
        wrist: WristCommand(pitch: MotorCommand(angle: solved.pitch)),
      ),
    );
    notifyListeners();
  }

  /// Turns the arm's base to [angle], in radians.
  void setSwivel(double angle) {
    final swivel = angle.clamp(-pi, pi);
    pendingSwivel = swivel;
    final pose = angles;
    commanded = (
      swivel: swivel,
      shoulder: pose.shoulder,
      elbow: pose.elbow,
      pitch: pose.pitch,
    );
    models.messages.sendMessage(
      ArmCommand(
        usingIk: BoolState.NO,
        swivel: MotorCommand(angle: swivel),
      ),
    );
    notifyListeners();
  }
}
