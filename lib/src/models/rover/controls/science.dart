import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/services.dart";

import "controls.dart";

/// A [RoverControls] that controls the science chamber.
class ScienceControls extends RoverControls {
	@override
	OperatingMode get mode => OperatingMode.science;

	@override
	List<Message> parseInputs(GamepadState state) => [
		if (state.normalLeftY != 0) ScienceCommand(vacuumLinear: state.normalLeftY*1000),
		if (state.normalRightY != 0) ScienceCommand(scienceLinear: state.normalRightY*-10000),
		if (state.normalDpadX != 0) ScienceCommand(dirtLinear: state.normalDpadX * 10000),
		if (state.dpadUp) ScienceCommand(dirtRelease: DirtReleaseState.CLOSE_DIRT),
		if (state.dpadDown) ScienceCommand(dirtRelease: DirtReleaseState.OPEN_DIRT),
		if (state.leftShoulder) ScienceCommand(dirtCarousel: -750),
		if (state.rightShoulder) ScienceCommand(dirtCarousel: 750),
		// These must be sent at all times to allow sending zero values
		if (state.buttonA) ScienceCommand(pump1: PumpState.PUMP_ON)
		else ScienceCommand(pump1: PumpState.PUMP_OFF),
		if (state.buttonB) ScienceCommand(pump2: PumpState.PUMP_ON)
		else ScienceCommand(pump2: PumpState.PUMP_OFF),
		if (state.buttonX) ScienceCommand(pump3: PumpState.PUMP_ON)
		else ScienceCommand(pump3: PumpState.PUMP_OFF),
		if (state.buttonY) ScienceCommand(pump4: PumpState.PUMP_ON)
		else ScienceCommand(pump4: PumpState.PUMP_OFF),
		if (state.normalTrigger != 0) ScienceCommand(vacuum: PumpState.PUMP_ON)
		else ScienceCommand(vacuum: PumpState.PUMP_OFF),

		if (state.buttonStart) ScienceCommand(calibrate: true),
		if (state.buttonBack) ScienceCommand(stop: true),
	];

	@override
	List<Message> get onDispose => [ScienceCommand(stop: true)];

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
