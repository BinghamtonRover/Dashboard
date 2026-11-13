import "dart:io";
import "dart:math" as math;
import "package:flutter_test/flutter_test.dart";
import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/src/models/rover/controls/swivel_jog.dart";

void main() {
  test("centre noise cannot restart movement after release", () {
    final jog = SwivelJog();
    ArmCommand? input(double value) => jog.update(
      joystick: value,
      incrementRadians: 2000,
      measuredRadians: 0,
      speedErpm: 5000,
      accelerationErpmPerSecond: 5000,
    );
    expect(input(0.12), isNull);
    expect(input(1)!.hasSwivel(), isTrue);
    expect(input(0.08)!.stop, isTrue);
    expect(input(0.12)!.stop, isTrue);
    expect(input(-0.12)!.stop, isTrue);
    expect(input(0)!.stop, isTrue);
    expect(input(0.20)!.hasSwivel(), isTrue);
  });
  test(
    "negative saved increment reverses the joystick instead of blocking movement",
    () {
      final settings = ArmSettings.fromJson({"swivel": -0.02});
      final jog = SwivelJog();
      final command = jog.update(
        joystick: 1,
        incrementRadians: settings.swivel,
        measuredRadians: 0.5,
        speedErpm: 100,
        accelerationErpmPerSecond: 100,
      );
      expect(command, isNotNull);
      expect(command!.stop, isFalse);
      expect(command.swivel.angle, closeTo(0.48, 1e-7));
      final reverse = jog.update(
        joystick: -1,
        incrementRadians: settings.swivel,
        measuredRadians: 0.5,
        speedErpm: 100,
        accelerationErpmPerSecond: 100,
      );
      expect(reverse!.swivel.angle, closeTo(0.5, 1e-7));
    },
  );
  test("shared packet preserves radians and optional motion fields", () {
    final bytes = File("test/fixtures/arm_position.pb").readAsBytesSync();
    final command = ArmCommand.fromBuffer(bytes);
    expect(command.hasSwivel(), isTrue);
    expect(command.swivel.angle, closeTo(math.pi / 18, 1e-7));
    expect(command.swivel.hasSpeedErpm(), isTrue);
    expect(command.swivel.speedErpm, 1230);
    expect(command.swivel.accelerationErpmPerSecond, 4560);
    expect(command.writeToBuffer(), orderedEquals(bytes));
  });

  test("omitted limits differ from explicit zero", () {
    final legacy = MotorCommand.fromBuffer(
      MotorCommand(angle: 1).writeToBuffer(),
    );
    expect(legacy.hasSpeedErpm(), isFalse);
    final zero = MotorCommand.fromBuffer(
      MotorCommand(angle: 1, speedErpm: 0).writeToBuffer(),
    );
    expect(zero.hasSpeedErpm(), isTrue);
    expect(zero.speedErpm, 0);
  });

  test(
    "telemetry uses the motor fields and preserves signed position and faults",
    () {
      final original = ArmData(
        baseMotor: ArmMotorData(
          position: -123,
          speed: 200,
          current: -1,
          temperature: 40,
          error: ArmMotorData_ErrorCode.OVER_CURRENT,
        ),
      );
      final received = ArmData.fromBuffer(original.writeToBuffer());
      expect(received.hasBaseMotor(), isTrue);
      expect(received.baseMotor.position / 10.0, -12.3);
      expect(received.baseMotor.error, ArmMotorData_ErrorCode.OVER_CURRENT);
      expect(received.hasShoulderMotor(), isFalse);
    },
  );

  test(
    "joystick starts from feedback and sends absolute radians with motion limits",
    () {
      final jog = SwivelJog();
      final command = jog.update(
        joystick: 1,
        incrementRadians: 0.02,
        measuredRadians: 0.5,
        speedErpm: 120,
        accelerationErpmPerSecond: 340,
      )!;
      expect(command.swivel.angle, closeTo(0.52, 1e-7));
      expect(command.swivel.moveRadians, 0);
      expect(command.swivel.speedErpm, 120);
      expect(command.swivel.accelerationErpmPerSecond, 340);
    },
  );

  test("no feedback prevents the first movement command", () {
    expect(
      SwivelJog().update(
        joystick: 1,
        incrementRadians: 0.02,
        measuredRadians: null,
        speedErpm: 100,
        accelerationErpmPerSecond: 100,
      ),
      isNull,
    );
  });

  test(
    "release repeats hold and the next movement restarts from measured position",
    () {
      final jog = SwivelJog();
      jog.update(
        joystick: 1,
        incrementRadians: 0.02,
        measuredRadians: 0.5,
        speedErpm: 100,
        accelerationErpmPerSecond: 100,
      );
      expect(
        jog
            .update(
              joystick: 0,
              incrementRadians: 0.02,
              measuredRadians: 0.51,
              speedErpm: 100,
              accelerationErpmPerSecond: 100,
            )!
            .stop,
        isTrue,
      );
      expect(
        jog
            .update(
              joystick: 0,
              incrementRadians: 0.02,
              measuredRadians: 0.51,
              speedErpm: 100,
              accelerationErpmPerSecond: 100,
            )!
            .stop,
        isTrue,
      );
      expect(
        jog
            .update(
              joystick: -1,
              incrementRadians: 0.02,
              measuredRadians: 0.3,
              speedErpm: 100,
              accelerationErpmPerSecond: 100,
            )!
            .swivel
            .angle,
        closeTo(0.28, 1e-7),
      );
    },
  );

  test("STOP has priority even while the joystick is held", () {
    final command = SwivelJog().update(
      joystick: 1,
      incrementRadians: 0.02,
      measuredRadians: 0,
      speedErpm: 100,
      accelerationErpmPerSecond: 100,
      stop: true,
    )!;
    expect(command.stop, isTrue);
    expect(command.hasSwivel(), isFalse);
  });

  test(
    "stationary feedback bounds accumulated target lead to five degrees",
    () {
      final jog = SwivelJog();
      ArmCommand? last;
      for (var i = 0; i < 100; i++) {
        last = jog.update(
          joystick: 1,
          incrementRadians: 0.02,
          measuredRadians: 0,
          speedErpm: 100,
          accelerationErpmPerSecond: 100,
        );
      }
      expect(last!.swivel.angle, closeTo(5 * math.pi / 180, 1e-7));
    },
  );

  test("invalid parameters request hold during active jogging", () {
    final jog = SwivelJog();
    jog.update(
      joystick: 1,
      incrementRadians: 0.02,
      measuredRadians: 0,
      speedErpm: 100,
      accelerationErpmPerSecond: 100,
    );
    expect(
      jog
          .update(
            joystick: 1,
            incrementRadians: 0.02,
            measuredRadians: 0,
            speedErpm: double.nan,
            accelerationErpmPerSecond: 100,
          )!
          .stop,
      isTrue,
    );
  });

  test("saved arm settings preserve speed and acceleration", () {
    final original = ArmSettings.fromJson({
      "speedErpm": 200,
      "accelerationErpmPerSecond": 300,
    });
    final decoded = ArmSettings.fromJson(original.toJson());
    expect(decoded.speedErpm, 200);
    expect(decoded.accelerationErpmPerSecond, 300);
    expect(ArmSettings.fromJson(null).speedErpm, 100);
  });
}
