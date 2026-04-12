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

  /// The maximum RPM to apply to the auger motor when the stick is fully deflected.
  double augerMaxRpm = 0.4;

  /// The amount of steps to move the linear slider when the stick is held.
  double linearSliderIncrement = 1000;

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
      if (state.normalShoulder != 0)
        ScienceCommand(carouselMotor: carouselIncrement * state.normalShoulder),
    ],

    if (state.normalTriggers != 0)
      ScienceCommand(
        auger: AugerCommand(speedRpm: state.normalTriggers.abs() * augerMaxRpm),
      ),

    if (state.normalRightY != 0)
      ScienceCommand(linearSlider: linearSliderIncrement * state.normalRightY),

    if (state.buttonA)
      ScienceCommand(pumps: PumpState.PUMP_ON)
    else
      ScienceCommand(pumps: PumpState.PUMP_OFF),

    if (state.buttonB)
      ScienceCommand(
        auger: AugerCommand(
          upperServo: ServoState.SERVO_OPEN,
          lowerServo: ServoState.SERVO_OPEN,
        ),
      )
    else
      ScienceCommand(
        auger: AugerCommand(
          upperServo: ServoState.SERVO_CLOSE,
          lowerServo: ServoState.SERVO_CLOSE,
        ),
      ),

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
      "Auger speed": "Triggers",
      "Linear slider": "Right stick (vertical)",
      "Activate pumps": "A (hold)",
      "Open auger servos": "B (hold)",
  };
}
