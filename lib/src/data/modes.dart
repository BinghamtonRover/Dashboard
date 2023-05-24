/// A mode for operating the rover. 
/// 
/// The operator can switch between modes which will: 
/// - change the controller inputs to match the current mode
/// - change the on-screen UI to provide information useful in this context
/// - highlight the relevant metrics
enum OperatingMode { 
	/// Science mode. 
	/// 
	/// Focus cameras on the science chamber and allow the user to collect samples and data.
	science("Science"), 

	/// Arm mode.
	/// 
	/// Focus on helping the user manipulate the arm.
	arm("Arm"), 

	/// Autonomy mode. 
	/// 
	/// Focus on helping the user understand the rover's decisions.
	autonomy("Autonomy"), 

	/// MARS mode.
	/// 
	/// Allows the user to control the MARS subsystem manually.
	mars("MARS"),

	/// No controls. Allows the user to "disable" a gamepad.
	none("None"),

	/// Camera mode.
	/// 
	/// The on-board cameras are on spinnable mounts. This mode controls those mounts.
	cameras("Cameras"),

	/// Drive mode. 
	/// 
	/// Focus on helping the user simply drive the rover.
	drive("Drive");

	/// The name of this mode.
	/// 
	/// Use this instead of [EnumName.name] so we can use a longer name.
	final String name;

	/// Describes an operating mode.
	const OperatingMode(this.name);
}
