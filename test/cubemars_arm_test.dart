// Verification for the CubeMars telemetry the arm firmware sends.

import "dart:math";

import "package:flutter_test/flutter_test.dart";
import "package:protobuf/protobuf.dart";
import "package:rover_dashboard/data.dart";

/// Encodes one `ArmMotorData` message the way the arm firmware would.
List<int> motorBytes({
  required double speed,
  required double current,
  required int temperature,
  required int fault,
  required int position,
}) =>
    (CodedBufferWriter()
          ..writeField(1, PbFieldType.OF, speed)
          ..writeField(2, PbFieldType.OF, current)
          ..writeField(3, PbFieldType.O3, temperature)
          // Enums are varints on the wire, so an int encodes the same bytes.
          ..writeField(4, PbFieldType.O3, fault)
          ..writeField(5, PbFieldType.O3, position))
        .toBuffer();

/// Encodes an [ArmData] packet with CubeMars field [tag].
ArmData packetWith(int tag, List<int> payload) => ArmData.fromBuffer(
  (CodedBufferWriter()..writeField(tag, PbFieldType.OY, payload)).toBuffer(),
);

void main() {
  final payload = motorBytes(
    speed: 1234.5,
    current: -2.25,
    temperature: 47,
    fault: ArmMotorFault.overCurrent.index,
    position: -12345,
  );

  test("decodes an ArmMotorData the arm reports", () {
    final telemetry = ArmTelemetry.fromArmData(
      packetWith(ArmMotor.shoulder.tag, payload),
    );

    expect(telemetry.isNotEmpty, isTrue);
    expect(telemetry.isComplete, isFalse);
    final motor = telemetry[ArmMotor.shoulder];
    expect(motor, isNotNull);
    expect(motor!.speed, closeTo(1234.5, 1e-3));
    expect(motor.current, closeTo(-2.25, 1e-6));
    expect(motor.temperature, 47);
    expect(motor.fault, ArmMotorFault.overCurrent);
    expect(motor.position, -12345);
    expect(motor.degrees, closeTo(-1234.5, 1e-9));
    expect(motor.radians(48), closeTo(-1234.5 * pi / 180 / 48, 1e-12));
  });

  test("every motor has its own field and label", () {
    for (final motor in ArmMotor.values) {
      final telemetry = ArmTelemetry.fromArmData(
        packetWith(
          motor.tag,
          motorBytes(
            speed: motor.index.toDouble(),
            current: 0,
            temperature: 20,
            fault: ArmMotorFault.none.index,
            position: 0,
          ),
        ),
      );
      expect(telemetry[motor]!.speed, closeTo(motor.index.toDouble(), 1e-6));
    }
  });

  test("an old arm packet has no CubeMars telemetry", () {
    expect(ArmTelemetry.fromArmData(ArmData()).isEmpty, isTrue);
  });

  test("clearing removes the CubeMars fields from the packet", () {
    final arm = packetWith(ArmMotor.pinch.tag, payload);
    final telemetry = ArmTelemetry.fromArmData(arm);
    expect(telemetry.isNotEmpty, isTrue);

    telemetry.clearFrom(arm);
    expect(ArmTelemetry.fromArmData(arm).isEmpty, isTrue);
  });

  test("the metrics read out each motor's CubeMars feedback", () {
    final metrics = ArmMetrics()
      ..telemetry = const ArmTelemetry({
        ArmMotor.shoulder: ArmMotorTelemetry(
          speed: 1234,
          current: 2.5,
          temperature: 47,
          fault: ArmMotorFault.overCurrent,
          position: 12345,
        ),
      });
    final lines = metrics.allMetrics;
    final texts = lines.map((line) => line.text).toList();

    expect(texts, contains("Shoulder"));
    expect(texts, contains("  Position: 1234.5 degrees"));
    expect(texts, contains("  Speed: 1234 ERPM"));
    expect(texts, contains("  Current: 2.50 A"));
    expect(texts, contains("  Temperature: 47 C"));
    expect(texts, contains("  Fault: Over current"));
    // Motors that did not report say so instead of showing zeros.
    expect(texts, contains("  Waiting for feedback"));
    expect(
      lines.firstWhere((line) => line.text.contains("Fault")).severity,
      Severity.critical,
    );
    expect(
      lines.firstWhere((line) => line.text.contains("Temperature")).severity,
      isNull,
    );
  });

  test("an unknown fault is reported as unknown", () {
    final motor = ArmMotorTelemetry.fromBuffer(
      motorBytes(speed: 0, current: 0, temperature: 20, fault: 99, position: 0),
    );
    expect(motor.fault, ArmMotorFault.unknown);
  });
}
