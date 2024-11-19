import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/services.dart";

import "controls.dart";

/// The skid-steer drive controls.
class DriveControls extends RoverControls {
  /// Whether the left shoulder was pressed last tick.
  bool leftShoulderFlag = false;

  /// Whether the right shoulder was pressed last tick.
  bool rightShoulderFlag = true;

  @override
  OperatingMode get mode => OperatingMode.drive;

  /// The throttle the rover should be at.
  double throttle = 0;

  @override
  void updateState(GamepadState state) {
    if (!leftShoulderFlag && state.leftShoulder) throttle -= 0.1;
    leftShoulderFlag = state.leftShoulder;
    if (!rightShoulderFlag && state.rightShoulder) throttle += 0.1;
    rightShoulderFlag = state.rightShoulder;
    throttle = throttle.clamp(0, 1);
  }

  @override
  List<Message> parseInputs(GamepadState state) => [
    DriveCommand(throttle: throttle, setThrottle: true),
    DriveCommand(setLeft: true, left: state.normalLeftY),
    DriveCommand(setRight: true, right: -1*state.normalRightJoystickY),
  ];

  @override
  List<Message> get onDispose => [
    DriveCommand(setThrottle: true, throttle: 0),
    DriveCommand(setLeft: true, left: 0),
    DriveCommand(setRight: true, right: 0),
  ];

  @override
  Map<String, String> get buttonMapping => {
    "Left Throttle": "Left joystick (vertical)",
    "Right Throttle": "Right joystick (vertical)",
    "Increase throttle": "Right bumper (R1)",
    "Decrease throttle": "Left bumper (L1)",
  };
}
