import "dart:math" as math;
import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";
import "swivel_jog.dart";

/// First Teensy bench integration: swivel motor ID 2 and STOP-as-hold.
class ArmControls extends RoverControls {
  final SwivelJog _swivel = SwivelJog();

  /// Persisted motion settings for the bench motor.
  ArmSettings get settings => models.settings.arm;

  @override
  OperatingMode get mode => OperatingMode.arm;

  @override
  List<Message> parseInputs(GamepadState state) {
    final arm = models.rover.metrics.arm.data;
    final command = _swivel.update(
      joystick: state.normalRightX,
      incrementRadians: settings.swivel,
      measuredRadians: arm.hasBaseMotor()
          ? arm.baseMotor.position * math.pi / 1800
          : null,
      speedErpm: settings.speedErpm,
      accelerationErpmPerSecond: settings.accelerationErpmPerSecond,
      stop: state.buttonBack,
    );
    return command == null ? [] : [command];
  }

  @override
  List<Message> get onDispose => [_swivel.hold()];

  @override
  Map<String, String> get buttonMapping => {
    "Swivel (motor 2)": "Right joystick horizontal; release to hold",
    "Hold position": "Select",
  };
}
