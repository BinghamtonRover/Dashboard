import "controller.dart";

/// A [Controller] to control the science chamber. 
class ScienceController extends Controller {
	@override
	List<Message> parseInputs(GamepadState state) => [
		if (state.normalLeftY != 0) ScienceCommand(vacuumLinearPosition: (state.normalLeftY*20).round()),
		if (state.normalRightY != 0) ScienceCommand(testLinearPosition: (state.normalRightY*20).round()),
		if (state.dpadLeft) ScienceCommand(carouselLinearPosition: 20),
		if (state.dpadRight) ScienceCommand(carouselLinearPosition: -20),
		if (state.dpadDown) ScienceCommand(dirtRelease: -2),
		if (state.dpadUp) ScienceCommand(dirtRelease: 2),
		if (state.leftShoulder) ScienceCommand(carouselAngle: 1),
		if (state.rightShoulder) ScienceCommand(carouselAngle: -1),
		// These must be sent at all times to allow sending zero values
		ScienceCommand(pump1: state.buttonA),
		ScienceCommand(pump2: state.buttonB),
		ScienceCommand(pump3: state.buttonX),
		ScienceCommand(pump4: state.buttonY),
		ScienceCommand(vacuumSuck: state.normalLeftTrigger),
	];

	@override
	List<Message> get onDispose => [];

	@override
	Map<String, String> get controls => {
		"Vacuum Linear": "Left Stick (vertical)",
		"Science Linear": "Right Stick (vertical)",
		"Dirt Linear": "D-pad left/right",
		"Dirt carousel": "Bumpers",
		"Vacuum power": "Left Trigger",
		"Vacuum release": "D-pad up/down",
		"Pumps": "A/B/X/Y",
	};
}
