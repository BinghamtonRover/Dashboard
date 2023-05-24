import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/services.dart";

import "controls.dart";

/// A [RoverControls] for the rover's front and rear cameras.
class CameraControls extends RoverControls {
	@override
	OperatingMode get mode => OperatingMode.cameras;

	@override
	List<Message> parseInputs(GamepadState state) => [
		DriveCommand(frontSwivel: state.normalRightX * 1000),
		DriveCommand(frontTilt: state.normalRightY * 1000),
		DriveCommand(rearSwivel: state.normalLeftX * 1000),
		DriveCommand(rearTilt: state.normalLeftY * 1000),
	];

	@override
	List<Message> get onDispose => [];

	@override
	Map<String, String> get buttonMapping => {
		"Front camera": "Left joystick",
		"Rear camera": "Right joystick",
	};
}
