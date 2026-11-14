import "package:flutter/material.dart";
import "package:rover_dashboard/data.dart";

/// Feedback from every joint of the CubeMars arm.
class ArmMetrics extends Metrics<ArmData> {
  /// Starts with no received motor feedback.
  ArmMetrics() : super(ArmData());

  /// The latest CubeMars feedback, decoded from the arm's packets.
  ///
  /// The generated [ArmData] this app builds against predates the CubeMars
  /// fields, so they are pulled out of each packet before it is merged.
  ArmTelemetry telemetry = const ArmTelemetry.empty();

  @override
  void update(ArmData value) {
    final cubeMars = ArmTelemetry.fromArmData(value);
    if (cubeMars.isNotEmpty) telemetry = cubeMars;
    super.update(value);
    // The merged [data] keeps a copy of every packet's unknown fields, so drop
    // the CubeMars ones now that [telemetry] holds the latest values.
    cubeMars.clearFrom(data);
  }

  @override
  String name = "Arm Base";

  @override
  Version supportedVersion = Version(major: 1, minor: 5);

  @override
  IconData icon = Icons.precision_manufacturing_outlined;

  /// Returns a description of a single joint, or a note if it is not reporting.
  List<MetricLine> _motorLines(
    String label,
    MotorData motor, {
    required bool present,
  }) => [
    MetricLine(label),
    if (!present)
      MetricLine("  Waiting for feedback")
    else ...[
      MetricLine(
        "  Angle: ${motor.currentAngle.toDegrees()} --> ${motor.targetAngle.toDegrees()} degrees",
      ),
      MetricLine("  Steps: ${motor.currentStep} --> ${motor.targetStep}"),
      MetricLine("  Direction: ${motor.direction.humanName}"),
      MetricLine(
        "  Moving: ${motor.isMoving.displayName}",
        severity: motor.isMoving.toBool() ? Severity.info : null,
      ),
      MetricLine(
        "  Limit switch: ${motor.isLimitSwitchPressed.displayName}",
        severity: motor.isLimitSwitchPressed.toBool() ? Severity.warning : null,
      ),
    ],
  ];

  /// Returns a description of the differentially-driven wrist.
  List<MetricLine> get _wristLines => [
    MetricLine("Wrist (motors 5 and 6)"),
    if (!data.hasWrist())
      MetricLine("  Waiting for feedback")
    else ...[
      MetricLine(
        "  Pitch: ${data.wrist.pitchAngle.toDegrees()} degrees, roll: ${data.wrist.rollAngle.toDegrees()} degrees",
      ),
      MetricLine(
        "  Motor A (5): ${data.wrist.motorA.currentAngle.toDegrees()} --> ${data.wrist.motorA.targetAngle.toDegrees()} degrees",
      ),
      MetricLine(
        "  Motor B (6): ${data.wrist.motorB.currentAngle.toDegrees()} --> ${data.wrist.motorB.targetAngle.toDegrees()} degrees",
      ),
      MetricLine(
        "  Moving: ${data.wrist.isMoving.displayName}",
        severity: data.wrist.isMoving.toBool() ? Severity.info : null,
      ),
      MetricLine(
        "  Calibrated: ${data.wrist.isCalibrated.displayName}",
        severity: data.wrist.isCalibrated.toBool() ? null : Severity.warning,
      ),
    ],
  ];

  /// Describes one CubeMars motor, or says it is not reporting.
  List<MetricLine> _telemetryLines(ArmMotor motor) {
    final motorData = telemetry[motor];
    if (motorData == null) {
      return [MetricLine(motor.label), MetricLine("  Waiting for feedback")];
    }
    return [
      MetricLine(motor.label),
      MetricLine("  Position: ${motorData.degrees.toStringAsFixed(1)} degrees"),
      MetricLine("  Speed: ${motorData.speed.toStringAsFixed(0)} ERPM"),
      MetricLine("  Current: ${motorData.current.toStringAsFixed(2)} A"),
      MetricLine(
        "  Temperature: ${motorData.temperature} C",
        severity: motorData.temperature >= 60 ? Severity.warning : null,
      ),
      MetricLine(
        "  Fault: ${motorData.fault.label}",
        severity: motorData.fault == ArmMotorFault.none
            ? null
            : Severity.critical,
      ),
    ];
  }

  /// The joint angles the CubeMars arm reports, when it sends them.
  List<MetricLine> get _jointLines {
    if (!data.hasJointAngles()) return const [];
    final joints = data.jointAngles;
    String pair(double single, double? multi) => multi == null
        ? "${single.toDegrees()} degrees"
        : "${single.toDegrees()} / ${multi.toDegrees()} degrees";
    return [
      MetricLine("Joint angles (single / multi turn)"),
      MetricLine(
        "  Swivel: ${pair(joints.swivelSingle, joints.hasSwivelMulti() ? joints.swivelMulti : null)}",
      ),
      MetricLine(
        "  Shoulder: ${pair(joints.shoulderSingle, joints.hasShoulderMulti() ? joints.shoulderMulti : null)}",
      ),
      MetricLine(
        "  Elbow: ${pair(joints.elbowSingle, joints.hasElbowMulti() ? joints.elbowMulti : null)}",
      ),
      MetricLine(
        "  Roll: ${pair(joints.rollSingle, joints.hasRollMulti() ? joints.rollMulti : null)}",
      ),
      MetricLine(
        "  Wrist pitch: ${pair(joints.wristPitchSingle, joints.hasWristPitchMulti() ? joints.wristPitchMulti : null)}",
      ),
    ];
  }

  @override
  List<MetricLine> get allMetrics => telemetry.isNotEmpty
      ? [for (final motor in ArmMotor.values) ..._telemetryLines(motor)]
      : [
          ..._jointLines,
          ..._motorLines(
            "Swivel (motor 2)",
            data.base,
            present: data.hasBase(),
          ),
          ..._motorLines(
            "Bar / shoulder (motor 3)",
            data.shoulder,
            present: data.hasShoulder(),
          ),
          ..._motorLines(
            "Lever / elbow (motor 4)",
            data.elbow,
            present: data.hasElbow(),
          ),
          ..._motorLines(
            "Forearm roll (motor 7)",
            data.roll,
            present: data.hasRoll(),
          ),
          ..._wristLines,
          ..._motorLines(
            "Gripper (motor 8)",
            data.pinch,
            present: data.hasPinch(),
          ),
        ];

  @override
  Version parseVersion(ArmData message) => message.version;

  @override
  Message get versionCommand => ArmCommand(version: supportedVersion);
}
