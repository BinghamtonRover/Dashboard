import "controller.dart";

class DriveController extends Controller {
	static const throttleIncrement = 0.2;

	double throttle = 0;

	@override
	List<Message> parseInputs(GamepadState state) => [
		DriveCommand(setLeft: true, left: state.leftY.clamp(-1, 1)),
		DriveCommand(setRight: true, right: state.rightY.clamp(-1, 1)),
		if (state.dpadUp) updateThrottle(throttleIncrement),
		if (state.dpadDown) updateThrottle(-throttleIncrement),
	];

	Message updateThrottle(double value) {
		throttle += value;
		throttle = throttle.clamp(0, 1);
		return DriveCommand(setThrottle: true, throttle: throttle);
	}
}
