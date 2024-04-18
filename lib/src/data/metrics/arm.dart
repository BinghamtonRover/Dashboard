import "package:rover_dashboard/data.dart";

/// Metrics reported by the HREI subsystem about the arm. Does not include the gripper.
class ArmMetrics extends Metrics<ArmData> {
	/// Metrics from the arm.
	ArmMetrics() : super(ArmData());

	@override
	String get name => "Arm Base";

	/// Returns a description of a [MotorData].
	List<MetricLine> getMotorData(MotorData motor, String part) => [
		MetricLine("$part:   Is moving? ${motor.isMoving}", severity: motor.isMoving ? Severity.info : null),
		MetricLine("$part:   Limit? ${motor.isLimitSwitchPressed}", severity: motor.isLimitSwitchPressed ? Severity.warning : null),
		MetricLine("$part:   Direction: ${motor.direction.humanName}"),
		MetricLine("$part:   Steps: ${motor.currentStep} --> ${motor.targetStep}"),
		MetricLine("$part:   Angle: ${motor.angle}"),
	];

	@override
	List<MetricLine> get allMetrics => [
		MetricLine("IK: "),
		MetricLine("  Current: ${data.currentPosition.prettyPrint}"),
		MetricLine("  Target: ${data.targetPosition.prettyPrint}"),
		...getMotorData(data.base, "Swivel"),
    MetricLine("------------------------------",),
		...getMotorData(data.shoulder, "Shoulder"),
    MetricLine("------------------------------",),
		...getMotorData(data.elbow, "Elbow"),
	];
}
