import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/services.dart";

import "controls.dart";

/// A [RoverControls] that drives the rover.
class DriveControls extends RoverControls {
	/// Increases the throttle by +/- 20%.
	static const throttleIncrement = 0.1;

	/// The current throttle, as a percentage of the rover's top speed.
	double throttle = 0;

	@override
	OperatingMode get mode => OperatingMode.drive;

	@override
	List<Message> parseInputs(GamepadState state) => [
		// Manual controls
		DriveCommand(setLeft: true, left: -1*state.leftThumbstickY.normalizeJoystick.clamp(-1, 1)),
		DriveCommand(setRight: true, right: state.rightThumbstickY.normalizeJoystick.clamp(-1, 1)),
		if (state.dpadUp) updateThrottle(throttleIncrement),
		if (state.dpadDown) updateThrottle(-throttleIncrement),

		// More intuitive controls
		if (state.leftShoulder) ...[
			DriveCommand(setLeft: true, left: 1),
			DriveCommand(setRight: true, right: 1),
		] else if (state.rightShoulder)...[
			DriveCommand(setLeft: true, left: -1),
			DriveCommand(setRight: true, right: -1),
		],
		if (state.leftTrigger > 0) ...[
			DriveCommand(setLeft: true, left: state.normalLeftTrigger),
			DriveCommand(setRight: true, right: -1*state.normalRightTrigger),
		] else if (state.rightTrigger > 0)...[
			DriveCommand(setLeft: true, left: -1*state.normalLeftTrigger),
			DriveCommand(setRight: true, right: state.normalRightTrigger),
		]
	];

	/// Updates the throttle by [throttleIncrement], clamping at [0, 1].
	Message updateThrottle(double value) {
		throttle += value;
		throttle = throttle.clamp(0, 1);
		return DriveCommand(setThrottle: true, throttle: throttle);
	}

	@override
	List<Message> get onDispose => [
		DriveCommand(setThrottle: true, throttle: 0),
		DriveCommand(setLeft: true, left: 0),
		DriveCommand(setLeft: false, left: 0),
	];

	@override
	Map<String, String> get buttonMapping => {
		"Left Throttle": "Left joystick (vertical)",
		"Right Throttle": "Right joystick (vertical)",
		"Drive Straight": "Triggers",
		"Turn in place": "Bumpers",
		"Adjust speed": "D-pad up/down",
	};
}
