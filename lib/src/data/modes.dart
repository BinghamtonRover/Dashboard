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
	science, 

	/// Arm mode.
	/// 
	/// Focus on helping the user manipulate the arm.
	arm, 

	/// Autonomy mode. 
	/// 
	/// Focus on helping the user understand the rover's decisions.
	autonomy, 

	/// Drive mode. 
	/// 
	/// Focus on helping the user simply drive the rover.
	drive
}
