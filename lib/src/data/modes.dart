/// A mode for operating the rover.
///
/// The operator can switch between modes which will:
/// - change the controller inputs to match the current mode
/// - change the on-screen UI to provide information useful in this context
/// - highlight the relevant metrics
enum OperatingMode {
	/// No controls. Allows the user to "disable" a gamepad.
	none("None"),

  /// Modern drive controls.
  ///
  /// Focus on driving intuitively with simple controls
  modernDrive("Drive"),

	/// Skid-steer drive controls.
	///
	/// Focus on helping the user drive the rover with as much manual control.
	drive("Tank drive"),

	/// Science mode.
	///
	/// Focus cameras on the science chamber and allow the user to collect samples and data.
	science("Science"),

	/// Arm mode.
	///
	/// Focus on helping the user manipulate the arm.
	arm("Arm"),

  /// Base Station mode.
  /// 
  /// Focus on manually manipulating the base station antenna
  baseStation("Base Station"),

	/// Camera mode.
	///
	/// The on-board cameras are on servo mounts. This mode controls those mounts.
	cameras("Cameras");

	/// The name of this mode.
	///
	/// Use this instead of [EnumName.name] so we can use a longer name.
	final String name;

	/// Describes an operating mode.
	const OperatingMode(this.name);
}
