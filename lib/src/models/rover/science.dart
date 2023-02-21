import "controller.dart";

/// A [Controller] to drive the rover in manual drive mode.
class ScienceController extends Controller {
	@override
	List<Message> parseInputs(GamepadState state) => [
		// if (button) ScienceCommand(specific: thing),
		if (state.buttonA) ScienceCommand(pump1: true),
		if (state.buttonB) ScienceCommand(pump2: true),
		if (state.buttonX) ScienceCommand(pump3: true),
		if (state.buttonY) ScienceCommand(pump4: true),
		if (state.buttonStart) ScienceCommand(dig: true),
		if (state.buttonBack) ScienceCommand(dig: true), //calibrate
		if (state.leftTrigger > 0) ScienceCommand( :state.leftTrigger), //spins auger?
		if (state.dpadLeft) ScienceCommand(carouselLinearPosition: true), //Add vertical science actuator
		if (state.leftThumbstickY > 0) ScienceCommand(vacuum_linear_position: false),
		if (state.rightThumbstickX > 0) ScienceCommand(carouselLinearPosition: true),
	];
}
