import "package:flutter/material.dart";
import "package:rover_dashboard/data.dart";

/// CubeMars feedback reported by the arm Teensy.
class ArmMetrics extends Metrics<ArmData> {
  /// Start with no received motor feedback.
  ArmMetrics() : super(ArmData());

  @override
  String name = "Arm Base";
  @override
  Version supportedVersion = Version(major: 1, minor: 5);
  @override
  IconData icon = Icons.precision_manufacturing_outlined;

  List<MetricLine> _motorLines(
    String label,
    ArmMotorData motor, {
    required bool present,
  }) => [
    MetricLine(label),
    if (!present)
      MetricLine("  No motor feedback received")
    else ...[
      MetricLine("  Position: ${motor.position / 10.0} degrees"),
      MetricLine("  Speed: ${motor.speed} electrical RPM"),
      MetricLine("  Current: ${motor.current} A"),
      MetricLine("  Temperature: ${motor.temperature} C"),
      MetricLine(
        "  Fault: ${motor.error.name}",
        severity: motor.error == ArmMotorData_ErrorCode.NO_FAULT
            ? null
            : Severity.warning,
      ),
    ],
  ];

  @override
  List<MetricLine> get allMetrics => [
    ..._motorLines("Swivel (2)", data.baseMotor, present: data.hasBaseMotor()),
    ..._motorLines(
      "Bar / shoulder motor (3)",
      data.shoulderMotor,
      present: data.hasShoulderMotor(),
    ),
    ..._motorLines(
      "Lever / elbow motor (4)",
      data.elbowMotor,
      present: data.hasElbowMotor(),
    ),
    ..._motorLines(
      "Forearm roll (7)",
      data.rollMotor,
      present: data.hasRollMotor(),
    ),
    ..._motorLines(
      "Wrist A (5)",
      data.rightDiffMotor,
      present: data.hasRightDiffMotor(),
    ),
    ..._motorLines(
      "Wrist B (6)",
      data.leftDiffMotor,
      present: data.hasLeftDiffMotor(),
    ),
    ..._motorLines(
      "Gripper (8)",
      data.pinchMotor,
      present: data.hasPinchMotor(),
    ),
  ];

  @override
  Version parseVersion(ArmData message) => message.version;
  @override
  Message get versionCommand => ArmCommand(version: supportedVersion);
}
