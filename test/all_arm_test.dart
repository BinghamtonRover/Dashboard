import "dart:typed_data";
import "package:burt_network/burt_network.dart";
import "package:burt_network/src/serial/framing.dart";
import "package:flutter_test/flutter_test.dart";
import "package:rover_dashboard/src/models/rover/controls/arm_jog.dart";

ArmData feedback() => ArmData(
  baseMotor: ArmMotorData(),
  shoulderMotor: ArmMotorData(),
  elbowMotor: ArmMotorData(),
  rollMotor: ArmMotorData(),
  rightDiffMotor: ArmMotorData(),
  leftDiffMotor: ArmMotorData(),
  pinchMotor: ArmMotorData(),
  jointAngles: JointAngleData(),
  wrist: WristData(),
);

void main() {
  test(
    "all seven channels map to the expected protobuf joints and share motion settings",
    () {
      final command = ArmJog().update(
        feedback: feedback(),
        sticks: List.filled(7, 1),
        increments: List.filled(7, 0.02),
        speedErpm: 500,
        accelerationErpmPerSecond: 700,
      )!;
      expect(
        command.hasSwivel() &&
            command.hasShoulder() &&
            command.hasElbow() &&
            command.hasRoll() &&
            command.hasPinch() &&
            command.wrist.hasPitch() &&
            command.wrist.hasRoll(),
        isTrue,
      );
      for (final motor in [
        command.swivel,
        command.shoulder,
        command.elbow,
        command.roll,
        command.pinch,
        command.wrist.pitch,
        command.wrist.roll,
      ]) {
        expect(motor.angle, closeTo(0.02, 1e-7));
        expect(motor.speedErpm, 500);
        expect(motor.accelerationErpmPerSecond, 700);
      }
      expect(command.holdMotorMask, 0);
      expect(command.writeToBuffer().length, greaterThan(64));
    },
  );
  test("releasing one group holds it while another group keeps moving", () {
    final jog = ArmJog();
    ArmCommand? update(List<double> sticks) => jog.update(
      feedback: feedback(),
      sticks: sticks,
      increments: List.filled(7, 0.02),
      speedErpm: 100,
      accelerationErpmPerSecond: 100,
    );
    update([1, 0, 0, 1, 0, 0, 0]);
    final command = update([0, 1, 0, 0, 0, 0, 0])!;
    expect(command.holdMotorMask, (1 << 2) | (1 << 7));
    expect(command.hasShoulder(), isTrue);
    expect(command.hasElbow(), isFalse);
    expect(command.stop, isFalse);
    final repeated = update([0, 1, 0, 0, 0, 0, 0])!;
    expect(repeated.holdMotorMask, command.holdMotorMask);
  });
  test(
    "releasing one wrist axis freezes that axis while its partner continues",
    () {
      final jog = ArmJog();
      final data = feedback();
      ArmCommand? update(List<double> sticks) => jog.update(
        feedback: data,
        sticks: sticks,
        increments: List.filled(7, 0.02),
        speedErpm: 100,
        accelerationErpmPerSecond: 100,
      );
      update([0, 0, 0, 0, 1, 1, 0]);
      data.wrist.pitchAngle = 0.01;
      final command = update([0, 0, 0, 0, 0, 1, 0])!;
      expect(command.wrist.pitch.angle, closeTo(0.01, 1e-7));
      expect(command.wrist.roll.angle, closeTo(0.04, 1e-7));
      expect(command.holdMotorMask, 0);
      final released = update(List.filled(7, 0))!;
      expect(released.holdMotorMask, (1 << 5) | (1 << 6));
    },
  );
  test("missing a paired motor blocks only that group", () {
    final data = feedback()..clearElbowMotor();
    final command = ArmJog().update(
      feedback: data,
      sticks: [1, 1, 0, 0, 0, 0, 0],
      increments: List.filled(7, 0.02),
      speedErpm: 100,
      accelerationErpmPerSecond: 100,
    )!;
    expect(command.hasSwivel(), isTrue);
    expect(command.hasShoulder(), isFalse);
  });
  test("global HOLD contains no movement targets", () {
    final command = ArmJog().update(
      feedback: feedback(),
      sticks: List.filled(7, 1),
      increments: List.filled(7, 0.02),
      speedErpm: 100,
      accelerationErpmPerSecond: 100,
      stop: true,
    )!;
    expect(command.stop, isTrue);
    expect(command.hasSwivel(), isFalse);
    expect(command.hasWrist(), isFalse);
  });
  test(
    "large frames survive every split boundary and multiple frames in one read",
    () {
      final command = ArmJog().update(
        feedback: feedback(),
        sticks: List.filled(7, 1),
        increments: List.filled(7, 0.02),
        speedErpm: 100,
        accelerationErpmPerSecond: 100,
      )!;
      final packet = command.writeToBuffer(),
          framed = frameFirmwareMessage(command.writeToBuffer());
      for (var split = 0; split <= framed.length; split++) {
        final decoder = FirmwareFrameDecoder();
        final decoded = [
          ...decoder.add(Uint8List.sublistView(framed, 0, split)),
          ...decoder.add(Uint8List.sublistView(framed, split)),
        ];
        expect(decoded.length, 1);
        expect(decoded.single, orderedEquals(packet));
      }
      final decoder = FirmwareFrameDecoder();
      expect(decoder.add(Uint8List.fromList([...framed, ...framed])).length, 2);
    },
  );
  test("frame decoder resynchronizes after noise and invalid lengths", () {
    final frame = frameFirmwareMessage(Uint8List.fromList([8, 1]));
    final decoded = FirmwareFrameDecoder().add(
      Uint8List.fromList([0, 1, 0xa5, 0x5a, 0, 0, ...frame]),
    );
    expect(decoded.single, orderedEquals([8, 1]));
  });
}
