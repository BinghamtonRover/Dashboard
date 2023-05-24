import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/services.dart";

import "arm.dart";
import "autonomy.dart";
import "drive.dart";
import "mars.dart";
import "none.dart";
import "science.dart";

export "arm.dart";
export "autonomy.dart";
export "drive.dart";
export "mars.dart";
export "none.dart";
export "science.dart";

/// How often to check the gamepad for new button presses.
const gamepadDelay = Duration(milliseconds: 100);

/// A class that controls one subsystem based on the gamepad state.
/// 
/// To use this class, subclass it and implement [parseInputs]. Be sure to add your class to the
/// [RoverControls.forMode] constructor so it can be used within the UI.
abstract class RoverControls {
	/// Classes with a factory constructor must also have a regular constructor to be overriden.
	const RoverControls();

	/// Creates the appropriate [RoverControls] for this mode.
	factory RoverControls.forMode(OperatingMode mode) {
		switch (mode) {
			case OperatingMode.arm: return ArmControls();
			case OperatingMode.science: return ScienceControls();
			case OperatingMode.autonomy: return AutonomyControls();
			case OperatingMode.drive: return DriveControls();
			case OperatingMode.mars: return MarsControls();
			case OperatingMode.none: return NoControls();
		}
	}

	/// The [OperatingMode] for these controls.
	OperatingMode get mode;

	/// Any logic to run before checking [parseInputs].
	void updateState(GamepadState state) { }

	/// Return a list of commands based on the current state of the gamepad.
	Iterable<Message?> parseInputs(GamepadState state);

	/// A list of commands that disables the subsystem.
	/// 
	/// For example, after driving this should set the speed to 0.
	Iterable<Message> get onDispose;

	/// A human-readable explanation of what the controls are. 
	/// 
	/// Keys are the actions, values are the buttons that trigger them.
	Map<String, String> get buttonMapping;
}
