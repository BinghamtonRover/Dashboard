import "dart:math";

import "package:protobuf/protobuf.dart";

import "package:burt_network/protobuf.dart";

/// The motors the CubeMars arm reports feedback for.
///
/// The tag is the field number of that motor's `ArmMotorData` in `ArmData`,
/// as defined by `arm.proto` on the Protobuf repo's `Arm-Data-Add` branch.
enum ArmMotor {
  /// The swivel motor, an AKH70-48.
  swivel(19, "Swivel"),

  /// The first bar of the four-bar linkage, an AKH70-48.
  shoulder(20, "Shoulder"),

  /// The second bar of the four-bar linkage, an AKH70-48.
  elbow(21, "Elbow"),

  /// The forearm roll, an AK45-36.
  roll(22, "Forearm roll"),

  /// One of the two wrist motors, an AK45-36.
  wristRoll(23, "Wrist roll"),

  /// The other wrist motor, an AK45-36.
  wristPitch(24, "Wrist pitch"),

  /// The gripper motor, an AK40-10.
  pinch(25, "Gripper");

  const ArmMotor(this.tag, this.label);

  /// The field number this motor's feedback arrives on.
  final int tag;

  /// A human-readable name for this motor.
  final String label;
}

/// The faults a CubeMars motor can report.
enum ArmMotorFault {
  /// The motor is healthy.
  none("No fault"),

  /// The motor is too hot.
  overTemperature("Over temperature"),

  /// The motor is drawing too much current.
  overCurrent("Over current"),

  /// The supply voltage is too high.
  overVoltage("Over voltage"),

  /// The supply voltage is too low.
  underVoltage("Under voltage"),

  /// The motor's encoder is not reading correctly.
  encoder("Encoder fault"),

  /// The motor's MOSFETs are too hot.
  mosfetOverTemperature("MOSFET over temperature"),

  /// The motor reported a fault this dashboard does not recognize.
  unknown("Unknown error");

  const ArmMotorFault(this.label);

  /// A human-readable name for this fault.
  final String label;

  /// Converts the enum value a motor reports into a fault.
  static ArmMotorFault fromValue(int value) =>
      value >= 0 && value < values.length ? values[value] : unknown;
}

/// The feedback one CubeMars motor reports.
///
/// This mirrors `ArmMotorData` in `arm.proto`. The generated `ArmData` this
/// app builds against stops at field 18, so these packets arrive in its
/// unknown fields and are decoded here.
class ArmMotorTelemetry {
  /// Creates motor feedback.
  const ArmMotorTelemetry({
    this.speed = 0,
    this.current = 0,
    this.temperature = 0,
    this.fault = ArmMotorFault.none,
    this.position = 0,
  });

  /// Decodes an `ArmMotorData` message from [bytes].
  factory ArmMotorTelemetry.fromBuffer(List<int> bytes) {
    final reader = CodedBufferReader(bytes);
    var speed = 0.0;
    var current = 0.0;
    var temperature = 0;
    var fault = ArmMotorFault.none;
    var position = 0;
    while (true) {
      final tag = reader.readTag();
      if (tag == 0) break;
      switch (getTagFieldNumber(tag)) {
        case 1:
          speed = reader.readFloat();
        case 2:
          current = reader.readFloat();
        case 3:
          temperature = reader.readInt32();
        case 4:
          fault = ArmMotorFault.fromValue(reader.readEnum());
        case 5:
          position = reader.readInt32();
        default:
          reader.skipField(tag);
      }
    }
    return ArmMotorTelemetry(
      speed: speed,
      current: current,
      temperature: temperature,
      fault: fault,
      position: position,
    );
  }

  /// The motor's speed, in electrical RPM.
  final double speed;

  /// The current the motor draws, in amps.
  final double current;

  /// The motor's temperature, in degrees Celsius.
  final int temperature;

  /// The fault the motor is reporting.
  final ArmMotorFault fault;

  /// The angle of the motor shaft, in tenths of a degree.
  ///
  /// This is the motor's own angle, before the gearbox, so divide by the
  /// joint's gear ratio to get the joint's angle.
  final int position;

  /// The motor shaft's angle, in degrees.
  double get degrees => position / 10;

  /// The joint's angle for a joint with the given [gearRatio], in radians.
  double radians(double gearRatio) => degrees * pi / 180 / gearRatio;
}

/// The CubeMars feedback reported by every joint of the arm.
class ArmTelemetry {
  /// Creates telemetry from the motors that reported.
  const ArmTelemetry(this.motors);

  /// Telemetry from an arm that has not reported yet.
  const ArmTelemetry.empty() : motors = const {};

  /// Reads the CubeMars fields out of an [ArmData] packet.
  ///
  /// Fields the packet did not include are left out, so [isEmpty] tells you
  /// whether this is CubeMars firmware speaking at all.
  factory ArmTelemetry.fromArmData(ArmData data) {
    final motors = <ArmMotor, ArmMotorTelemetry>{};
    for (final motor in ArmMotor.values) {
      final payloads = data.unknownFields.getField(motor.tag)?.lengthDelimited;
      if (payloads == null || payloads.isEmpty) continue;
      try {
        // A repeated field is merged, so the last copy is the latest one.
        motors[motor] = ArmMotorTelemetry.fromBuffer(payloads.last);
      } on InvalidProtocolBufferException {
        // A malformed packet should not take down the dashboard; skip it and
        // wait for the next one.
        continue;
      }
    }
    return ArmTelemetry(motors);
  }

  /// The feedback from each motor that reported, by joint.
  final Map<ArmMotor, ArmMotorTelemetry> motors;

  /// The feedback for [motor], or null if it did not report.
  ArmMotorTelemetry? operator [](ArmMotor motor) => motors[motor];

  /// Whether every joint of the arm reported.
  bool get isComplete => motors.length == ArmMotor.values.length;

  /// Whether no joint of the arm reported.
  bool get isEmpty => motors.isEmpty;

  /// Whether any joint of the arm reported.
  bool get isNotEmpty => motors.isNotEmpty;

  /// Removes the CubeMars fields from [data], after they were decoded.
  ///
  /// The generated [ArmData] treats them as unknown fields and keeps every
  /// copy it is merged with, so without this the metrics would accumulate a
  /// copy of each packet forever.
  void clearFrom(ArmData data) {
    for (final motor in ArmMotor.values) {
      data.unknownFields.clearField(motor.tag);
    }
  }
}
