/// The state of a 3D mouse
class Mouse3dState {
  /// Value of the x-axis
  final double x;

  /// Value of the y-axis
  final double y;

  /// Value of the z-axis
  final double z;

  /// Value of the pitch
  final double pitch;

  /// Value of the yaw
  final double yaw;

  /// Value of the roll
  final double roll;

  /// Default constructor for [Mouse3dState], initializing the values of all axis
  Mouse3dState({
    required this.x,
    required this.y,
    required this.z,
    required this.pitch,
    required this.yaw,
    required this.roll,
  });
}
