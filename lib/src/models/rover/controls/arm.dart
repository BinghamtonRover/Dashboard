import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";
import "arm_jog.dart";

/// Manual joint control for the complete CubeMars arm.
class ArmControls extends RoverControls {
  final ArmJog _arm = ArmJog();

  /// Shared speed/acceleration and signed per-joint joystick increments.
  ArmSettings get settings => models.settings.arm;
  @override
  OperatingMode get mode => OperatingMode.arm;
  @override
  List<Message> parseInputs(GamepadState state) {
    final command = _arm.update(
      feedback: models.rover.metrics.arm.data,
      sticks: [
        state.normalRightX,
        state.normalRightY,
        state.normalLeftY,
        state.normalShoulder,
        state.normalDpadY.toDouble(),
        state.normalDpadX.toDouble(),
        state.normalTriggers,
      ],
      increments: [
        settings.swivel,
        settings.shoulder,
        settings.elbow,
        settings.armRoll,
        settings.lift,
        settings.wristRoll,
        settings.pinch,
      ],
      speedErpm: settings.speedErpm,
      accelerationErpmPerSecond: settings.accelerationErpmPerSecond,
      stop: state.buttonBack,
    );
    return command == null ? [] : [command];
  }

  @override
  List<Message> get onDispose => [_arm.hold()];
  @override
  Map<String, String> get buttonMapping => {
    "Swivel (2)": "Right stick horizontal",
    "Shoulder (bar 3 + lever 4)": "Right stick vertical",
    "Elbow (lever 4; configured limits apply)": "Left stick vertical",
    "Forearm roll (7)": "Bumpers",
    "Wrist pitch (5 + 6)": "D-pad up/down",
    "Wrist roll (5 + 6)": "D-pad left/right",
    "Gripper jog (8)": "Triggers",
    "Hold position": "Release the control or press Select for all motors",
  };
}
