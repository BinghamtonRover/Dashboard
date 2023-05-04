import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/services.dart";

import "controls.dart";

/// A [RoverControls] that controls the science chamber.
class ScienceControls extends RoverControls {
	@override
	OperatingMode get mode => OperatingMode.science;

	@override
	List<Message> parseInputs(GamepadState state) => [
		if (state.normalLeftY != 0) ScienceCommand(vacuumLinearPosition: state.normalLeftY*1000),
		if (state.normalRightY != 0) ScienceCommand(testLinearPosition: state.normalRightY*-2000),
		if (state.dpadLeft) ScienceCommand(carouselLinearPosition: -10000),
		if (state.dpadRight) ScienceCommand(carouselLinearPosition: 10000),
		if (state.dpadDown) ScienceCommand(dirtRelease: DirtReleasePosition.OPEN_DIRT),
		if (state.dpadUp) ScienceCommand(dirtRelease: DirtReleasePosition.CLOSE_DIRT),
		if (state.leftShoulder) ScienceCommand(carouselAngle: 500),
		if (state.rightShoulder) ScienceCommand(carouselAngle: -500),
		// These must be sent at all times to allow sending zero values
		if (state.buttonA) ScienceCommand(pump1: PumpState.PUMP_ON)
		else ScienceCommand(pump1: PumpState.PUMP_OFF),
		if (state.buttonB) ScienceCommand(pump2: PumpState.PUMP_ON)
		else ScienceCommand(pump2: PumpState.PUMP_OFF),
		if (state.buttonX) ScienceCommand(pump3: PumpState.PUMP_ON)
		else ScienceCommand(pump3: PumpState.PUMP_OFF),
		if (state.buttonY) ScienceCommand(pump4: PumpState.PUMP_ON)
		else ScienceCommand(pump4: PumpState.PUMP_OFF),
	];

	@override
	List<Message> get onDispose => [];

	@override
	Map<String, String> get buttonMapping => {
		"Vacuum Linear": "Left Stick (vertical)",
		"Science Linear": "Right Stick (vertical)",
		"Dirt Linear": "D-pad left/right",
		"Dirt carousel": "Bumpers",
		"Vacuum power": "Left Trigger",
		"Vacuum release": "D-pad up/down",
		"Pumps": "A/B/X/Y",
	};
}
