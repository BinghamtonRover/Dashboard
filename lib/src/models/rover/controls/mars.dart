import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/services.dart";

import "controls.dart";

class MarsControls extends RoverControls {
	@override
	OperatingMode get mode => OperatingMode.mars;

	@override
	List<Message> parseInputs(GamepadState state) => [
		MarsCommand(swivel: state.normalLeftX * 1000),
		MarsCommand(tilt: state.normalRightY * 1000),
	];

	@override
	Map<String, String> get buttonMapping => {
		"Swivel": "Left joystick (horizontal)",
		"Tilt": "Right joystick (vertical)",
	};

	@override
	List<Message> get onDispose => [];
}
