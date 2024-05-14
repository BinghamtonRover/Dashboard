import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/services.dart";

import "controls.dart";

/// Modern drive controls, similar to most racing video games.
/// 
/// Triggers are for acceleration, left stick for steering.
/// Also includes camera controls on the D-pad and right stick.
class ModernDriveControls extends RoverControls {
  // static const throttleIncrement = 0.1;

  /// How far to tilt the cameras each tick.
  static const cameraTiltIncrement = 10;

  /// How far to swivel the cameras each tick.
  static const cameraSwivelIncrement = 10;

  // double throttle = 0;

  /// The angle of the front tilt servo.
  double frontTilt = 0;

  /// The angle of the front swivel servo.
  double frontSwivel = 0;

  /// The angle of the rear tilt servo.
  double rearTilt = 90;

  /// The angle of the rear swivel servo.
  double rearSwivel = 90;

  @override
  OperatingMode get mode => OperatingMode.drive;

  /// Gets the speeds of the wheels based on the speed and direction.
  (double, double) getWheelSpeeds(double speed, double direction) {
    const slope = 1 / 90;
    // if (-90 <= direction && direction <= -45) {  // [-90, -45]
    //   return (slope * direction + 0.5, slope * direction + 1.5);
    // } else {  // [45, 90]
    //   return (-1 * slope * direction + 1.5, -1 * slope * direction + 0.5);
    // }

    if (direction < -45) {  // trying to turn too far left
      return (-1, 1);
    } else if (direction >= -45 && direction < 45) {  // [-45, 45]
      // return (-1 * slope * direction + 0.5, -1 * slope * direction + 0.5 * -1);
      return (slope * direction + 0.5, slope * direction - 0.5);
    } else {
      return (1, -1);
    }
  }

  /// Gets all commands for the wheels based on the gamepad state.
  List<DriveCommand> getWheelCommands(GamepadState state) {
    final speed = state.normalTrigger;  // sum of both triggers, [-1, 1]
    if (speed == 0) {
      final left = state.normalLeftX;
      final right = state.normalLeftX * -1;
      return [
        DriveCommand(left: left, setLeft: true),
        DriveCommand(right: right, setRight: true),
      ];
    }
    final direction = state.normalLeftX * 45;  // [-1, 1] --> [-45, 45]
    final (double left, double right) = getWheelSpeeds(speed, direction);
    return [
      DriveCommand(left: speed * left, setLeft: true),
      DriveCommand(right: speed * right, setRight: true),
    ];
  }

  /// Gets all camera commands based on the gamepad state.
  List<DriveCommand> getCameraCommands(GamepadState state) => [
    DriveCommand(frontSwivel: frontSwivel),
    DriveCommand(frontTilt: frontTilt),
    DriveCommand(rearSwivel: rearSwivel),
    DriveCommand(rearTilt: rearTilt),
  ];

  @override
  List<Message> parseInputs(GamepadState state) => [
    ...getWheelCommands(state),
    ...getCameraCommands(state),
    // if (state.normalShoulder != 0) 
      // DriveCommand(setThrottle: true, throttle: throttle),
  ];

  @override
  void updateState(GamepadState state) {
    // Update values
    // throttle += state.normalShoulder * throttleIncrement;
    frontSwivel += state.normalRightX * cameraSwivelIncrement;
    frontTilt += state.normalRightY * cameraTiltIncrement;
    rearSwivel += state.normalDpadX * cameraSwivelIncrement;
    rearTilt += state.normalDpadY * cameraTiltIncrement;
    // Clamp values to their respective ranges
    // throttle = throttle.clamp(0, 1);
    frontSwivel = frontSwivel.clamp(0, 180);
    frontTilt = frontTilt.clamp(0, 180);
    rearSwivel = rearSwivel.clamp(0, 180);
    rearTilt = rearTilt.clamp(0, 180);
  }

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
