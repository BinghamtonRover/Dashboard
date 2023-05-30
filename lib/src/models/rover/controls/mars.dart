import "dart:math";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/services.dart";

import "controls.dart";

/// A [RoverControls] for the MARS subsystems.
class MarsControls extends RoverControls {
	@override
	OperatingMode get mode => OperatingMode.mars;

	@override
	List<Message> parseInputs(GamepadState state) => [
		if (state.normalLeftX != 0) MarsCommand(swivel: state.normalLeftX * pi / 50),
		if (state.normalRightY != 0) MarsCommand(tilt: state.normalRightY * 5000),
	];

	@override
	Map<String, String> get buttonMapping => {
		"Swivel": "Left joystick (horizontal)",
		"Tilt": "Right joystick (vertical)",
	};

	@override
	List<Message> get onDispose => [];
}
