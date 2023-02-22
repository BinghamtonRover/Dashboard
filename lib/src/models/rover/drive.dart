import "controller.dart";

/// A [Controller] to drive the rover in manual drive mode.
class DriveController extends Controller {
	/// Increases the throttle by +/- 20%.
	static const throttleIncrement = 0.2;

	/// The current throttle, as a percentage of the rover's top speed.
	double throttle = 0;

	@override
	List<Message> parseInputs(GamepadState state) => [
		DriveCommand(setLeft: true, left: state.leftThumbstickY.normalizeJoystick.clamp(-1, 1)),
		DriveCommand(setRight: true, right: state.rightThumbstickY.normalizeJoystick.clamp(-1, 1)),
		if (state.dpadUp) updateThrottle(throttleIncrement),
		if (state.dpadDown) updateThrottle(-throttleIncrement),
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
}
