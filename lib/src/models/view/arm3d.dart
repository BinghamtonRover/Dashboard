import "dart:math";
import "dart:ui";

/// A point or vector in the arm's 3D world, in meters.
///
/// Z points up, and the swivel turns the arm about the Z-axis.
class ArmVector {
  /// Creates a vector from its components.
  const ArmVector(this.x, this.y, this.z);

  /// The distance along the X-axis.
  final double x;

  /// The distance along the Y-axis.
  final double y;

  /// The distance along the Z-axis.
  final double z;

  /// The origin.
  static const zero = ArmVector(0, 0, 0);

  /// The world's up direction.
  static const up = ArmVector(0, 0, 1);

  /// Adds two vectors.
  ArmVector operator +(ArmVector other) =>
      ArmVector(x + other.x, y + other.y, z + other.z);

  /// Subtracts two vectors.
  ArmVector operator -(ArmVector other) =>
      ArmVector(x - other.x, y - other.y, z - other.z);

  /// Scales a vector.
  ArmVector operator *(double scale) =>
      ArmVector(x * scale, y * scale, z * scale);

  /// The dot product of two vectors.
  double dot(ArmVector other) => x * other.x + y * other.y + z * other.z;

  /// The cross product of two vectors.
  ArmVector cross(ArmVector other) => ArmVector(
    y * other.z - z * other.y,
    z * other.x - x * other.z,
    x * other.y - y * other.x,
  );

  /// The length of this vector, in meters.
  double get length => sqrt(x * x + y * y + z * z);

  /// This vector with a length of one, or [zero] if it has no direction.
  ArmVector get normalized {
    final length = this.length;
    return length < 1e-9 ? zero : this * (1 / length);
  }

  @override
  String toString() => "ArmVector($x, $y, $z)";
}

/// Where each joint sits in 3D, in meters.
///
/// The shoulder is the upper motor's pivot and pivot is the lower motor's base
/// pin. The motor mount runs from pivot to elbow, where the lower bar starts;
/// bracket and rear are the two top pins, and output is the front pin where
/// the forearm is mounted parallel to the coupler. The wrist and fingers carry
/// the gripper out from there.
typedef ArmPose3d = ({
  ArmVector base,
  ArmVector shoulder,
  ArmVector pivot,
  ArmVector elbow,
  ArmVector bracket,
  ArmVector rear,
  ArmVector output,
  ArmVector wrist,
  ArmVector fingers,
});

/// Where a 3D point lands on the widget.
typedef ArmProjection = ({
  Offset screen,
  double depth,
  double pixelsPerMeter,
});

/// A perspective camera that orbits around the arm.
class ArmCamera {
  /// Creates a camera at the default angle and distance.
  ArmCamera({double? yaw, double? pitch, double? distance})
    : yaw = yaw ?? defaultYaw,
      pitch = pitch ?? defaultPitch,
      distance = distance ?? defaultDistance;

  /// The angle the camera orbits at, in radians.
  double yaw;

  /// How high above the arm the camera looks from, in radians.
  double pitch;

  /// How far the camera is from what it looks at, in meters.
  double distance;

  /// The default angle around the arm, in radians.
  static const defaultYaw = -0.85;

  /// The default height above the arm, in radians.
  static const defaultPitch = 0.35;

  /// The default distance from the arm, in meters.
  static const defaultDistance = 2.5;

  /// The point the camera looks at.
  static const target = ArmVector(0, 0, 0.55);

  /// The closest the camera may zoom in, in meters.
  static const minDistance = 1.0;

  /// The furthest the camera may zoom out, in meters.
  static const maxDistance = 8.0;

  /// How much of the widget one meter covers at one meter of depth.
  double _focal(Size size) => min(size.width, size.height) * 1.15;

  /// Where the camera sits.
  ArmVector get eye =>
      target +
      ArmVector(
            cos(yaw) * cos(pitch),
            sin(yaw) * cos(pitch),
            sin(pitch),
          ) *
          distance;

  /// The direction the camera looks in.
  ArmVector get _forward => (target - eye).normalized;

  /// The camera's horizontal axis, pointing right on screen.
  ArmVector get _right => _forward.cross(ArmVector.up).normalized;

  /// The camera's vertical axis, pointing up on screen.
  ArmVector get _up => _right.cross(_forward);

  /// Projects [point] onto [size], or returns null if it is behind the camera.
  ArmProjection? project(ArmVector point, Size size) {
    final relative = point - eye;
    final depth = relative.dot(_forward);
    if (depth < 0.08) return null;
    final focal = _focal(size);
    return (
      screen: Offset(
        size.width / 2 + relative.dot(_right) * focal / depth,
        size.height / 2 - relative.dot(_up) * focal / depth,
      ),
      depth: depth,
      pixelsPerMeter: focal / depth,
    );
  }

  /// The ray through a point on the widget, in world space.
  ({ArmVector origin, ArmVector direction}) ray(Offset local, Size size) {
    final focal = _focal(size);
    final direction =
        (_forward * focal +
                _right * (local.dx - size.width / 2) +
                _up * -(local.dy - size.height / 2))
            .normalized;
    return (origin: eye, direction: direction);
  }

  /// Orbits the camera by a mouse drag.
  void orbit(Offset delta) {
    yaw -= delta.dx * 0.008;
    pitch = (pitch + delta.dy * 0.006).clamp(0.05, 1.4);
  }

  /// Zooms the camera by a scroll amount.
  void zoom(double delta) {
    distance = (distance * exp(delta * 0.0015)).clamp(
      minDistance,
      maxDistance,
    );
  }

  /// Returns the camera to its default angle and distance.
  void reset() {
    yaw = defaultYaw;
    pitch = defaultPitch;
    distance = defaultDistance;
  }
}
