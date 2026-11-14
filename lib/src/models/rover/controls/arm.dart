import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";

import "slew_rate_limiter.dart";

/// Controls every joint of the CubeMars arm directly from the gamepad.
///
/// Each joint jogs while its input is deflected, limited by its own speed and
/// acceleration so no joint can start or stop instantly. The CubeMars motors
/// hold their last commanded position, so a joint that has slowed to a stop
/// stays where it is until its input moves again.
class ArmControls extends RoverControls {
  /// The number of commands sent each second, used to convert a joint speed in
  /// radians per second into the radians moved by a single command.
  static final double _commandsPerSecond = 1000 / gamepadDelay.inMilliseconds;

  /// Limits how quickly the swivel joint's speed can change.
  final _swivelLimiter = SlewRateLimiter();

  /// Limits how quickly the shoulder joint's speed can change.
  final _shoulderLimiter = SlewRateLimiter();

  /// Limits how quickly the elbow joint's speed can change.
  final _elbowLimiter = SlewRateLimiter();

  /// Limits how quickly the forearm roll's speed can change.
  final _rollLimiter = SlewRateLimiter();

  /// Limits how quickly the wrist pitch's speed can change.
  final _liftLimiter = SlewRateLimiter();

  /// Limits how quickly the wrist roll's speed can change.
  final _wristRollLimiter = SlewRateLimiter();

  /// Limits how quickly the gripper's speed can change.
  final _pinchLimiter = SlewRateLimiter();

  /// The user's arm settings, which hold how far and how fast each joint moves.
  ArmSettings get settings => models.settings.arm;

  /// Whether Stop was pressed on the previous tick, so it is only sent once.
  bool _isStopPressed = false;

  /// Whether Start was pressed on the previous tick, so it is only sent once.
  bool _isCalibratePressed = false;

  @override
  OperatingMode get mode => OperatingMode.arm;

  @override
  void updateState(GamepadState state) {
    final arm = settings;
    _swivelLimiter.rate = arm.jointRadiansPerSecond(
      arm.swivelAccelerationErpm,
      arm.swivelGearRatio,
      arm.swivelPolePairs,
    );
    _shoulderLimiter.rate = arm.jointRadiansPerSecond(
      arm.shoulderAccelerationErpm,
      arm.shoulderGearRatio,
      arm.shoulderPolePairs,
    );
    _elbowLimiter.rate = arm.jointRadiansPerSecond(
      arm.elbowAccelerationErpm,
      arm.elbowGearRatio,
      arm.elbowPolePairs,
    );
    _rollLimiter.rate = arm.jointRadiansPerSecond(
      arm.armRollAccelerationErpm,
      arm.armRollGearRatio,
      arm.armRollPolePairs,
    );
    _liftLimiter.rate = arm.jointRadiansPerSecond(
      arm.liftAccelerationErpm,
      arm.liftGearRatio,
      arm.liftPolePairs,
    );
    _wristRollLimiter.rate = arm.jointRadiansPerSecond(
      arm.wristRollAccelerationErpm,
      arm.wristRollGearRatio,
      arm.wristRollPolePairs,
    );
    _pinchLimiter.rate = arm.jointRadiansPerSecond(
      arm.pinchAccelerationErpm,
      arm.pinchGearRatio,
      arm.pinchPolePairs,
    );

    if (!state.buttonBack) _isStopPressed = false;
    if (!state.buttonStart) _isCalibratePressed = false;
  }

  /// Converts one tick of input into a command for a single joint.
  ///
  /// [increment] is how far the joint moves per command at full deflection,
  /// [speedErpm] caps how fast it may move, and [limiter] ramps the command so
  /// the joint accelerates no faster than its configured acceleration. Returns
  /// null once the joint has stopped, which leaves it holding.
  MotorCommand? _jog(
    double input,
    double increment, {
    required double speedErpm,
    required double gearRatio,
    required double polePairs,
    required SlewRateLimiter limiter,
  }) {
    final maxSpeed = settings.jointRadiansPerSecond(speedErpm, gearRatio, polePairs);
    final target = (input * increment * _commandsPerSecond).clamp(-maxSpeed, maxSpeed);
    final current = limiter.calculate(target);
    if (current == 0) return null;
    return MotorCommand(moveRadians: current / _commandsPerSecond);
  }

  @override
  List<Message> parseInputs(GamepadState state) {
    // Stop and calibrate are one-shot commands, so only send them on the press.
    if (state.buttonBack) {
      if (_isStopPressed) return [];
      _isStopPressed = true;
      return [ArmCommand(stop: true)];
    }
    if (state.buttonStart) {
      if (_isCalibratePressed) return [];
      _isCalibratePressed = true;
      return [ArmCommand(calibrate: true)];
    }

    // The right stick drives one joint at a time, so pushing it diagonally does
    // not swivel and raise the arm at once.
    final isSwiveling = state.normalRightX.abs() > state.normalRightY.abs();
    final swivel = isSwiveling
        ? _jog(
            state.normalRightX,
            settings.swivel,
            speedErpm: settings.swivelSpeedErpm,
            gearRatio: settings.swivelGearRatio,
            polePairs: settings.swivelPolePairs,
            limiter: _swivelLimiter,
          )
        : null;
    final shoulder = isSwiveling
        ? null
        : _jog(
            state.normalRightY,
            settings.shoulder,
            speedErpm: settings.shoulderSpeedErpm,
            gearRatio: settings.shoulderGearRatio,
            polePairs: settings.shoulderPolePairs,
            limiter: _shoulderLimiter,
          );
    final elbow = _jog(
      state.normalLeftY,
      settings.elbow,
      speedErpm: settings.elbowSpeedErpm,
      gearRatio: settings.elbowGearRatio,
      polePairs: settings.elbowPolePairs,
      limiter: _elbowLimiter,
    );
    final roll = _jog(
      state.normalShoulders.toDouble(),
      settings.armRoll,
      speedErpm: settings.armRollSpeedErpm,
      gearRatio: settings.armRollGearRatio,
      polePairs: settings.armRollPolePairs,
      limiter: _rollLimiter,
    );
    final wristPitch = _jog(
      state.normalDpadY.toDouble(),
      settings.lift,
      speedErpm: settings.liftSpeedErpm,
      gearRatio: settings.liftGearRatio,
      polePairs: settings.liftPolePairs,
      limiter: _liftLimiter,
    );
    final wristRoll = _jog(
      state.normalDpadX.toDouble(),
      settings.wristRoll,
      speedErpm: settings.wristRollSpeedErpm,
      gearRatio: settings.wristRollGearRatio,
      polePairs: settings.wristRollPolePairs,
      limiter: _wristRollLimiter,
    );
    final pinch = _jog(
      state.normalTriggers,
      settings.pinch,
      speedErpm: settings.pinchSpeedErpm,
      gearRatio: settings.pinchGearRatio,
      polePairs: settings.pinchPolePairs,
      limiter: _pinchLimiter,
    );

    final isMoving =
        swivel != null ||
        shoulder != null ||
        elbow != null ||
        roll != null ||
        wristPitch != null ||
        wristRoll != null ||
        pinch != null;
    if (!isMoving) return [];

    // All joints go out in a single command so they start moving together.
    final command = ArmCommand(usingIk: BoolState.NO);
    if (swivel != null) command.swivel = swivel;
    if (shoulder != null) command.shoulder = shoulder;
    if (elbow != null) command.elbow = elbow;
    if (roll != null) command.roll = roll;
    if (wristPitch != null || wristRoll != null) {
      final wrist = WristCommand();
      if (wristPitch != null) wrist.pitch = wristPitch;
      if (wristRoll != null) wrist.roll = wristRoll;
      command.wrist = wrist;
    }
    if (pinch != null) command.pinch = pinch;
    return [command];
  }

  @override
  List<Message> get onDispose => [ArmCommand(stop: true)];

  @override
  Map<String, String> get buttonMapping => {
    "Swivel (motor 2)": "Right joystick (horizontal)",
    "Shoulder (motor 3)": "Right joystick (vertical)",
    "Elbow (motor 4)": "Left joystick (vertical)",
    "Forearm roll (motor 7)": "Bumpers",
    "Wrist pitch (motor 5/6)": "D-pad up/down",
    "Wrist roll (motor 5/6)": "D-pad left/right",
    "Gripper (motor 8)": "Triggers",
    "Hold position": "Select",
    "Calibrate": "Start",
  };
}
