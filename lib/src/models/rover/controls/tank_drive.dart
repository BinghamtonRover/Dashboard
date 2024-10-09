import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";
import "package:rover_dashboard/src/models/rover/controls/slew_rate_limiter.dart";

import "controls.dart";

/// The skid-steer drive controls.
class DriveControls extends RoverControls {
  /// The rate limit for the drive input
  static const double rateLimit = 2.50;

  /// The [SlewRateLimiter] for the left joystick input
  SlewRateLimiter leftLimiter = SlewRateLimiter(rate: rateLimit);

  /// The [SlewRateLimiter] for the right joystick input
  SlewRateLimiter rightLimiter = SlewRateLimiter(rate: rateLimit);

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
    leftLimiter.rate = models.settings.dashboard.slewRateLimit;
    rightLimiter.rate = models.settings.dashboard.slewRateLimit;
    if (!leftShoulderFlag && state.leftShoulder) throttle -= 0.1;
    leftShoulderFlag = state.leftShoulder;
    if (!rightShoulderFlag && state.rightShoulder) throttle += 0.1;
    rightShoulderFlag = state.rightShoulder;
    throttle = throttle.clamp(0, 1);
  }

  @override
  List<Message> parseInputs(GamepadState state) {
    final leftInput = state.normalLeftY;
    final rightInput = -state.normalRightY;

    return [
      DriveCommand(throttle: throttle, setThrottle: true),
      DriveCommand(setLeft: true, left: leftLimiter.calculate(leftInput)),
      DriveCommand(setRight: true, right: rightLimiter.calculate(rightInput)),
    ];
  }

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
