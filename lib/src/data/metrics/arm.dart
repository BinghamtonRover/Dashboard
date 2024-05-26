import "package:rover_dashboard/data.dart";

/// Metrics reported by the HREI subsystem about the arm. Does not include the gripper.
class ArmMetrics extends Metrics<ArmData> {
	/// Metrics from the arm.
	ArmMetrics() : super(ArmData());

	@override
	String get name => "Arm Base";

	/// Returns a description of a [MotorData].
	List<MetricLine> getMotorData(MotorData motor) => [
		MetricLine("  Is moving? ${motor.isMoving.displayName}", severity: motor.isMoving.toBool() ? Severity.info : null),
		MetricLine("  Limit? ${motor.isLimitSwitchPressed.displayName}", severity: motor.isLimitSwitchPressed.toBool() ? Severity.warning : null),
		MetricLine("  Direction: ${motor.direction.humanName}"),
		MetricLine("  Steps: ${motor.currentStep} --> ${motor.targetStep}"),
		MetricLine("  Angle: ${motor.angle.toDegrees()} degrees"),
	];

	@override
	List<MetricLine> get allMetrics => [
		MetricLine("IK: "),
		MetricLine("  Current: ${data.currentPosition.prettyPrint}"),
		MetricLine("  Target: ${data.targetPosition.prettyPrint}"),
		MetricLine("------------------------------"),
		MetricLine("Swivel: "),
    ...getMotorData(data.base),
		MetricLine("------------------------------"),
		MetricLine("Shoulder: "),
    ...getMotorData(data.shoulder),
		MetricLine("------------------------------"),
		MetricLine("Elbow: "),
    ...getMotorData(data.elbow),
	];

  @override
  Version get supportedVersion => Version(major: 1);

  @override
  Version parseVersion(ArmData message) => message.version;

  @override
  Message get versionCommand => ArmCommand(version: supportedVersion);
}
