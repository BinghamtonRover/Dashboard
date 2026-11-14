import "package:burt_network/burt_network.dart";
import "swivel_jog.dart";

/// Joystick channels: swivel, shoulder, elbow, forearm roll, wrist pitch/roll, gripper.
class ArmJog {
  final _jogs = List.generate(7, (_) => SwivelJog());
  final _wasMoving = List.filled(7, false);
  final _usedGroups = List.filled(5, false);
  static const _groups = [
    [0],
    [1, 2],
    [3],
    [4, 5],
    [6],
  ];
  static const _masks = [
    1 << 2,
    (1 << 3) | (1 << 4),
    1 << 7,
    (1 << 5) | (1 << 6),
    1 << 8,
  ];

  /// Build one combined packet. Neutral groups hold without stopping active groups.
  ArmCommand? update({
    required ArmData feedback,
    required List<double> sticks,
    required List<double> increments,
    required double speedErpm,
    required double accelerationErpmPerSecond,
    bool stop = false,
  }) {
    if (stop) return hold();
    if (sticks.length != 7 || increments.length != 7) {
      throw ArgumentError("Expected seven arm channels");
    }
    final joints = feedback.jointAngles;
    double? measured(double value, {required bool present}) =>
        present ? value : null;
    final positions = <double?>[
      measured(
        joints.swivelMulti,
        present: feedback.hasBaseMotor() && feedback.hasJointAngles(),
      ),
      measured(
        joints.shoulderMulti,
        present:
            feedback.hasShoulderMotor() &&
            feedback.hasElbowMotor() &&
            feedback.hasJointAngles(),
      ),
      measured(
        joints.elbowMulti,
        present:
            feedback.hasShoulderMotor() &&
            feedback.hasElbowMotor() &&
            feedback.hasJointAngles(),
      ),
      measured(
        joints.rollMulti,
        present: feedback.hasRollMotor() && feedback.hasJointAngles(),
      ),
      measured(
        feedback.wrist.pitchAngle,
        present:
            feedback.hasRightDiffMotor() &&
            feedback.hasLeftDiffMotor() &&
            feedback.hasWrist(),
      ),
      measured(
        feedback.wrist.rollAngle,
        present:
            feedback.hasRightDiffMotor() &&
            feedback.hasLeftDiffMotor() &&
            feedback.hasWrist(),
      ),
      measured(
        feedback.pinchMotor.position * 0.0017453292519943296,
        present: feedback.hasPinchMotor(),
      ),
    ];
    final targets = List<MotorCommand?>.filled(7, null);
    var holdMask = 0;
    for (var g = 0; g < _groups.length; g++) {
      final group = _groups[g];
      if (group.any((i) => positions[i] == null || !positions[i]!.isFinite)) {
        for (final i in group) {
          _jogs[i].hold();
          _wasMoving[i] = false;
        }
        if (_usedGroups[g]) holdMask |= _masks[g];
        continue;
      }
      final updates = <int, ArmCommand?>{};
      final previous = <int, bool>{};
      for (final i in group) {
        previous[i] = _wasMoving[i];
        updates[i] = _jogs[i].update(
          joystick: sticks[i],
          incrementRadians: increments[i],
          measuredRadians: positions[i],
          speedErpm: speedErpm,
          accelerationErpmPerSecond: accelerationErpmPerSecond,
        );
        _wasMoving[i] = updates[i]?.hasSwivel() ?? false;
      }
      if (!group.any((i) => _wasMoving[i])) {
        if (_usedGroups[g]) holdMask |= _masks[g];
        continue;
      }
      _usedGroups[g] = true;
      for (final i in group) {
        if (_wasMoving[i]) {
          targets[i] = updates[i]!.swivel;
        } else if (previous[i]!) {
          // One coupled joint was released while its partner is still moving.
          targets[i] = MotorCommand(
            angle: positions[i],
            speedErpm: speedErpm,
            accelerationErpmPerSecond: accelerationErpmPerSecond,
          );
        }
      }
    }
    if (holdMask == 0 && targets.every((c) => c == null)) return null;
    return ArmCommand(
      holdMotorMask: holdMask,
      swivel: targets[0],
      shoulder: targets[1],
      elbow: targets[2],
      roll: targets[3],
      pinch: targets[6],
      wrist: targets[4] == null && targets[5] == null
          ? null
          : WristCommand(pitch: targets[4], roll: targets[5]),
    );
  }

  /// Cancel all commanded groups and reset their joystick references.
  ArmCommand hold() {
    for (final jog in _jogs) {
      jog.hold();
    }
    _wasMoving.fillRange(0, 7, false);
    _usedGroups.fillRange(0, 5, false);
    return ArmCommand(stop: true);
  }
}
