import "dart:async";

import "package:burt_network/protobuf.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/src/data/modes.dart";
import "package:rover_dashboard/src/services/gamepad/state.dart";

/// The [RoverControls] which controls the arm with Inverse Kinematics
class ArmIkControls extends RoverControls {
  /// The coordinates of the end effector.
  ///
  /// The arm uses IK to move all the joints to stay at these coordinates.
  Pose3d ikPosition = Pose3d();

  bool _positionReceived = false;

  late StreamSubscription<ArmData>? _dataSubscription = models.messages.stream
      .onMessage(
        name: ArmData().messageName,
        constructor: ArmData.fromBuffer,
        callback: _onArmData,
      );

  void _onArmData(ArmData data) {
    ikPosition.translation = data.currentPosition;
    ikPosition.rotation = data.currentOrientation;

    _positionReceived = true;
    _dataSubscription?.cancel();
    _dataSubscription = null;
  }

  @override
  OperatingMode get mode => OperatingMode.armIk;

  @override
  Iterable<Message> parseInputs(GamepadState state) {
    if (state.buttonStart) {
      return [ArmCommand(stop: true)];
    }

    if (_positionReceived) {
      ikPosition.translation.x +=
          state.normalLeftJoystickX * models.settings.arm.ikIncrement;
      ikPosition.translation.y +=
          state.normalLeftJoystickY * models.settings.arm.ikIncrement;

      final normalZMovement = (state.buttonY ? 0 : 1) - (state.buttonA ? 0 : 1);
      ikPosition.translation.z +=
          normalZMovement * models.settings.arm.ikIncrement;

      ikPosition.rotation.x +=
          state.normalRightJoystickY * models.settings.arm.lift;
      ikPosition.rotation.y +=
          state.normalRightJoystickX * models.settings.arm.wristRoll;
    }

    return [
      if (_positionReceived)
        ArmCommand(usingIk: BoolState.YES, pose: ikPosition),

      // Wrist pitch
      ArmCommand(
        wrist: WristCommand(
          pitch: MotorCommand(
            moveRadians: state.normalRightJoystickY * models.settings.arm.lift,
          ),
        ),
      ),

      // Wrist roll
      ArmCommand(
        wrist: WristCommand(
          roll: MotorCommand(
            moveRadians:
                state.normalRightJoystickX * models.settings.arm.wristRoll,
          ),
        ),
      ),
    ];
  }

  @override
  Iterable<Message> get onDispose => () {
    _dataSubscription?.cancel();
    _dataSubscription = null;

    return <Message>[];
  }();

  @override
  Map<String, String> get buttonMapping => {
    // IK movement
    "Left Joystick Y": "End-effector forward/back on Y-Axis",
    "Left Joystick X": "End-effector left/right on X-Axis",
    "Button Y/A": "End-effector up/down on Z-Axis",

    "Right Joystick Y": "Wrist pitch",
    "Right Joystick X": "Wrist roll",

    "Start": "Stop the arm",
  };
}
