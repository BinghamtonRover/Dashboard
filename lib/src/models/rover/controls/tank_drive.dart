import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/services.dart";

import "controls.dart";

/// The skid-steer drive controls.
class DriveControls extends RoverControls {
	@override
	OperatingMode get mode => OperatingMode.drive;

	@override
	List<Message> parseInputs(GamepadState state) => [
		DriveCommand(setLeft: true, left: state.normalLeftY),
		DriveCommand(setRight: true, right: -1*state.normalRightY),
	];

  @override
  List<Message> get onDispose => [
    DriveCommand(setThrottle: true, throttle: 0),
		DriveCommand(setLeft: true, left: 0),
		DriveCommand(setRight: true, right: 0),
  ];

	@override
	Map<String, String> get buttonMapping => {
		"Left Throttle": "Left joystick (vertical)",
		"Right Throttle": "Right joystick (vertical)",
	};
}
