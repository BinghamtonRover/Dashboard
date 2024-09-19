import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";

/// Modern drive controls, similar to most racing video games.
///
/// Triggers are for acceleration, left stick for steering.
/// Also includes camera controls on the D-pad and right stick.
class ModernDriveControls extends RoverControls {
  /// How far to tilt the cameras each tick.
  static const cameraTiltIncrement = -0.75;

  /// How far to swivel the cameras each tick.
  static const cameraSwivelIncrement = -1;

  /// The angle of the front tilt servo.
  double frontTilt = 90;

  /// The angle of the front swivel servo.
  double frontSwivel = 90;

  /// The angle of the rear tilt servo.
  double rearTilt = 90;

  /// The angle of the rear swivel servo.
  double rearSwivel = 90;

  /// The throttle value.
  double throttle = 0;

  /// Whether the left shoulder was pressed last tick.
  bool leftShoulderFlag = false;
  /// Whether the right shoulder was pressed last tick.
  bool rightShoulderFlag = true;

  @override
  OperatingMode get mode => OperatingMode.modernDrive;

  /// Gets the speeds of the wheels based on the speed and direction.
  (double, double) getWheelSpeeds(double speed, double direction) {
    const slope = 1 / 90;
    if (direction < -45) {  // trying to turn too far left
      return (-1, 1);
    } else if (direction >= -45 && direction < 45) {  // [-45, 45]
      return (slope * direction + 0.5, slope * direction - 0.5);
    } else {  // trying to turn too far right
      return (1, -1);
    }
  }

  /// Gets all commands for the wheels based on the gamepad state.
  List<DriveCommand> getWheelCommands(GamepadState state) {
    final speed = state.normalTrigger;  // sum of both triggers, [-1, 1]
    if (speed == 0) {
      final left = state.normalLeftX;
      final right = state.normalLeftX;
      return [
        DriveCommand(left: left / 2, setLeft: true),
        DriveCommand(right: right / 2, setRight: true),
        DriveCommand(throttle: throttle, setThrottle: true),
      ];
    }
    final direction = state.normalLeftX * 20;  // [-1, 1] --> [-45, 45]
    final (double left, double right) = getWheelSpeeds(speed, direction);
    return [
      DriveCommand(left: speed * left, setLeft: true),
      DriveCommand(right: speed * right, setRight: true),
      DriveCommand(throttle: throttle, setThrottle: true),
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
    if (!models.settings.dashboard.splitCameras)
      ...getCameraCommands(state),
  ];

  /// Updates the throttle if either shoulder button is pressed.
  void updateThrottle(GamepadState state) {
    if (!leftShoulderFlag && state.leftShoulder) throttle -= 0.1;
    leftShoulderFlag = state.leftShoulder;
    if (!rightShoulderFlag && state.rightShoulder) throttle += 0.1;
    rightShoulderFlag = state.rightShoulder;
    throttle = throttle.clamp(0, 1);
  }

  /// Updates variables for both cameras' servos.
  void updateCameras(GamepadState state) {
    // Update only ONE camera. Go left to right.
    final newFrontSwivel = state.normalDpadX;
    final newFrontTilt = state.normalDpadY;
    final newRearSwivel = state.normalRightX;
    final newRearTilt = state.normalRightY;
    if (newFrontSwivel.abs() >= 0.05 || newFrontTilt.abs() >= 0.05) {
      // Update the front camera. Now, choose which axis
      if (newFrontSwivel.abs() > newFrontTilt.abs()) {
        frontSwivel += newFrontSwivel * cameraSwivelIncrement;
      } else {
        frontTilt += newFrontTilt * cameraTiltIncrement;
      }
    } else if (newRearSwivel.abs() >= 0.05 || newRearTilt.abs() >= 0.05) {
      if (newRearSwivel.abs() > newRearTilt.abs()) {
        rearSwivel += newRearSwivel * cameraSwivelIncrement;
      } else {
        rearTilt += newRearTilt * cameraTiltIncrement * -1;
      }
    }
    // Clamp cameras
    frontSwivel = frontSwivel.clamp(0, 180);
    frontTilt = frontTilt.clamp(0, 180);
    rearSwivel = rearSwivel.clamp(0, 180);
    rearTilt = rearTilt.clamp(0, 180);
  }

  @override
  void updateState(GamepadState state) {
    updateThrottle(state);
    updateCameras(state);
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
