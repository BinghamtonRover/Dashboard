import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/services.dart";

import "arm.dart";
import "base_station.dart";
import "camera.dart";
import "tank_drive.dart";
import "none.dart";
import "science.dart";
import "modern_drive.dart";

export "arm.dart";
export "camera.dart";
export "tank_drive.dart";
export "none.dart";
export "science.dart";
export "modern_drive.dart";

/// How often to check the gamepad for new button presses.
const gamepadDelay = Duration(milliseconds: 10);

/// A class that controls one subsystem based on the gamepad state.
/// 
/// To use this class, subclass it and implement [parseInputs]. Be sure to add your class to the
/// [RoverControls.forMode] constructor so it can be used within the UI.
abstract class RoverControls {
	/// Classes with a factory constructor must also have a regular constructor to be overriden.
	const RoverControls();

	/// Creates the appropriate [RoverControls] for this mode.
	factory RoverControls.forMode(OperatingMode mode) => switch (mode) {
    OperatingMode.arm => ArmControls(),
    OperatingMode.science => ScienceControls(),
    OperatingMode.drive => DriveControls(),
    OperatingMode.none => NoControls(),
    OperatingMode.cameras => CameraControls(),
    OperatingMode.modernDrive => ModernDriveControls(),
    OperatingMode.baseStation => BaseStationControls(),
	};

	/// The [OperatingMode] for these controls.
	OperatingMode get mode;

	/// Any logic to run before checking [parseInputs].
	void updateState(GamepadState state) { }

	/// Return a list of commands based on the current state of the gamepad.
	Iterable<Message> parseInputs(GamepadState state);

	/// A list of commands that disables the subsystem.
	/// 
	/// For example, after driving this should set the speed to 0.
	Iterable<Message> get onDispose;

	/// A human-readable explanation of what the controls are. 
	/// 
	/// Keys are the actions, values are the buttons that trigger them.
	Map<String, String> get buttonMapping;
}
