import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/services.dart";

import "controls.dart";

class DriveControls extends RoverControls {
  static const throttleIncrement = 0.1;
  static const cameraTiltIncrement = 10;
  static const cameraSwivelIncrement = 10;

  double throttle = 0;
  double frontTilt = 90;
  double frontSwivel = 90;
  double rearTilt = 90;
  double rearSwivel = 90;

  @override
  OperatingMode get mode => OperatingMode.drive;

  (double, double) getWheelSpeeds(double speed, double direction) {
    const slope = 1 / 90;
    if (-90 <= direction && direction <= -45) {  // [-90, -45]
      return (slope * direction + 1.5, slope * direction + 0.5);
    } else if (direction > -45 && direction < 45) {  // [-45, 45]
      return (-1 * slope * direction + 0.5, slope * direction + 0.5);
    } else {  // [45, 90]
      return (-1 * slope * direction + 0.5, -1 * slope * direction + 1.5);
    }
  }

  List<DriveCommand> getWheelCommands(GamepadState state) {
    final speed = state.normalTrigger;  // sum of both triggers, [-1, 1]
    final direction = state.normalLeftX*90 + 90;  // [-1, 1] --> [-90, 90]
    final (double left, double right) = getWheelSpeeds(speed, direction);
    return [
      DriveCommand(left: speed * left, setLeft: true),
      DriveCommand(right: speed * right, setRight: true),
    ];
  }

  List<DriveCommand> getCameraCommands(GamepadState state) {
    if (state.normalDpadX != 0) {
      frontSwivel += state.normalDpadX * cameraSwivelIncrement;
      frontSwivel = frontSwivel.clamp(0, 180);
    }
    if (state.normalDpadY != 0) {
      frontTilt += state.normalDpadY * cameraTiltIncrement;
      frontTilt = frontTilt.clamp(0, 180);
    }
    if (state.normalRightX != 0) {
      rearSwivel += state.normalRightX * cameraSwivelIncrement;
      rearSwivel = rearSwivel.clamp(0, 180);
    }
    if (state.normalRightY != 0) {
      rearTilt += state.normalDpadY * cameraTiltIncrement;
      rearTilt = rearTilt.clamp(0, 180);
    }
    return [
      DriveCommand(frontSwivel: frontSwivel),
      DriveCommand(frontTilt: frontTilt),
      DriveCommand(rearSwivel: rearSwivel),
      DriveCommand(rearTilt: rearTilt),
    ];
  }

  @override
  List<Message> parseInputs(GamepadState state) => [
    ...getWheelCommands(state),
    ...getCameraCommands(state),
    if (state.dpadUp) DriveCommand(throttle: (throttle + throttleIncrement).clamp(0, 1), setThrottle: true)
    else if (state.dpadDown) DriveCommand(throttle: (throttle - throttleIncrement).clamp(0, 1), setThrottle: true),
  ];

  @override
  List<Message> get onDispose => [
    DriveCommand(setThrottle: true, throttle: 0),
		DriveCommand(setLeft: true, left: 0),
		DriveCommand(setRight: true, right: 0),
  ];

  @override
  Map<String, String> get buttonMapping => {
    "Forward": "Right trigger",
    "Reverse / Brake": "Left trigger",
    "Steering": "Left joystick (horizontal)",
    "Decrease throttle": "Left bumper",
    "Increase throttle": "Right bumper",
    "Rear camera": "D-pad",
    "Front camera": "Right joystick",
  };
}
