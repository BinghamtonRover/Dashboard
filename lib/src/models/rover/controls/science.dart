/// Last updated to science.proto v1.0.0
library science_controls;

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/services.dart";

import "controls.dart";

/// A [RoverControls] that controls the science chamber.
class ScienceControls extends RoverControls {
  /// Whether the shoulder buttons should move tubes or steps.
  bool tubeMode = true;
  /// The amount of steps to move the dirt carousel when the button is held.
  double carouselIncrement = 1000;
  /// The amount of steps to move the scooper when the button is held.
  double scoopIncrement = 1000;
  /// The amount of steps to move the subsurface sampler when the button is held.
  double subsurfaceIncrement = 1000;

  /// Whether the left bumper was pressed last frame.
  bool leftBumper = false;
  /// Whether the right bumper was pressed last frame.
  bool rightBumper = false;
  /// -1 if the left bumper was pressed, +1 if the right bumper was pressed, 0 otherwise.
  int bumperFlag = 0;
  
	@override
	OperatingMode get mode => OperatingMode.science;

  @override
  void updateState(GamepadState state) {
    if (bumperFlag != 0) bumperFlag = 0;
    if (state.leftShoulder && !leftBumper) bumperFlag = -1;
    if (state.rightShoulder && !rightBumper) bumperFlag = 1;
    leftBumper = state.leftShoulder;
    rightBumper = state.rightShoulder;
  }

	@override
	List<Message> parseInputs(GamepadState state) => [
    if (tubeMode) ...[
      if (bumperFlag == -1) ScienceCommand(carousel: CarouselCommand.PREV_TUBE),
      if (bumperFlag == 1) ScienceCommand(carousel: CarouselCommand.NEXT_TUBE),
    ] else ...[
      if (bumperFlag != 0) ScienceCommand(carouselMotor: carouselIncrement * bumperFlag),
    ],
        
		if (state.normalLeftY != 0) ScienceCommand(subsurfaceMotor: subsurfaceIncrement * state.normalLeftY),
		if (state.normalRightY != 0) ScienceCommand(scoopMotor: scoopIncrement * state.normalRightY),

    if (state.buttonA) ScienceCommand(pumps: PumpState.PUMP_ON)
    else ScienceCommand(pumps: PumpState.PUMP_OFF),

    if (state.buttonB) ScienceCommand(funnel: ServoState.SERVO_OPEN)
    else ScienceCommand(funnel: ServoState.SERVO_CLOSE),

    if (state.dpadUp) ScienceCommand(scoop: ServoState.SERVO_OPEN),
    if (state.dpadDown) ScienceCommand(scoop: ServoState.SERVO_CLOSE),

		if (state.buttonStart) ScienceCommand(calibrate: true),
		if (state.buttonBack) ScienceCommand(stop: true),
	];

	@override
	List<Message> get onDispose => [ScienceCommand(stop: true)];

	@override
	Map<String, String> get buttonMapping => {
    if (tubeMode) 
      "Dirt carousel": "Left and right shoulders"
    else 
      "Prev/Next tubes": "Left and right shoulders",
    "Scooper arm": "Right stick (vertical)",
    "Subsurface sampler": "Left stick (vertical)",
    "Open/Close scoop": "D-pad Up/Down",
    "Activate pumps": "A (hold)",
    "Open funnel": "B (hold)",
	};
}
