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
		// Adjust throttle
		if (state.dpadUp) updateThrottle(throttleIncrement)
		else if (state.dpadDown) updateThrottle(-throttleIncrement),
		// Adjust wheels 
		DriveCommand(setLeft: true, left: state.normalLeftY),
		DriveCommand(setRight: true, right: -1*state.normalRightY),
		// More intuitive controls
		if (state.normalShoulder != 0) ...[
			DriveCommand(setLeft: true, left: state.normalShoulder),
			DriveCommand(setRight: true, right: state.normalShoulder),
		],
		if (state.normalTrigger != 0) ...[
			DriveCommand(setLeft: true, left: state.normalTrigger),
			DriveCommand(setRight: true, right: -1 * state.normalTrigger),
		],
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
