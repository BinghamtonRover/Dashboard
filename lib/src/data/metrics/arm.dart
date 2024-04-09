import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/src/data/metrics/metrics.dart";

/// Metrics reported by the HREI subsystem about the arm. Does not include the gripper.
class ArmMetrics extends Metrics<ArmData> {
	/// Metrics from the arm.
	ArmMetrics() : super(ArmData());

	@override
	String get name => "Arm Base";

	/// Returns a description of a [MotorData].
	List<MetricLine> getMotorData(MotorData motor, String part) => [
		MetricLine("$part:   Is moving? ${motor.isMoving}", severity: Severity.critical),
		MetricLine("$part:   Limit? ${motor.isLimitSwitchPressed}", severity: Severity.critical),
		MetricLine("$part:   Direction: ${motor.direction.humanName}", severity: Severity.critical),
		MetricLine("$part:   Steps: ${motor.currentStep} --> ${motor.targetStep}", severity: Severity.critical),
		MetricLine("$part:   Angle: ${motor.angle}", severity: Severity.critical),
	];

  /// Ask about what variable we need to put for data.targetPosition.?
  /// Change severity of MotorData

	@override
	List<MetricLine> get allMetrics => [
		MetricLine("IK: "),
		MetricLine(
			"  Current: ${data.currentPosition.prettyPrint}",
			severity: data.currentPosition.x < 0 ? Severity.warning : Severity.info,
		),
		MetricLine("  Target: ${data.targetPosition.prettyPrint}", 
    severity: data.targetPosition.x < 0 ? Severity.warning : Severity.info,),
		...getMotorData(data.base, "Swivel"),
    MetricLine("------------------------------",),
		...getMotorData(data.shoulder, "Shoulder"),
    MetricLine("------------------------------",),
		...getMotorData(data.elbow, "Elbow"),
	];
}
