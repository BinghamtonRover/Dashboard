import "dart:math";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/services.dart";

import "controls.dart";

/// A [RoverControls] for the rover's front and rear cameras.
class CameraControls extends RoverControls {
	@override
	OperatingMode get mode => OperatingMode.cameras;

	@override
	List<Message> parseInputs(GamepadState state) => [
		if (state.normalRightTrigger.abs() > 0.75) ...[
			DriveCommand(frontSwivel: 90 - state.normalRightX * 90),
			DriveCommand(frontTilt: 90 - state.normalRightY * 90),
		],
		if (state.normalLeftTrigger.abs() > 0.75) ...[
			DriveCommand(rearSwivel: 90 - state.normalLeftX * 90),
			DriveCommand(rearTilt: 90 + state.normalLeftY * 90),
		],
		if (state.normalDpadX != 0) MarsCommand(swivel: state.normalDpadX * pi / 50),
	];

	@override
	List<Message> get onDispose => [];

	@override
	Map<String, String> get buttonMapping => {
		"Front camera": "Right trigger + joystick",
		"Rear camera": "Left trigger + joystick",
		"MARS swivel": "D-pad (horizontal)",
	};
}
