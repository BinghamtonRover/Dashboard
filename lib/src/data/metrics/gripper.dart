import "package:rover_dashboard/data.dart";

/// Metrics about the gripper on the HREI subsystem.
class GripperMetrics extends Metrics<GripperData> {
	/// Metrics about the gripper.
	GripperMetrics() : super(GripperData());

	@override
	String get name => "Gripper";

	/// Returns a human-readable description of a [MotorData].
	List<MetricLine> getMotorData(MotorData motor, String functionality) => [
		MetricLine("$functionality  Is moving? ${motor.isMoving}"),
		MetricLine("$functionality  Limit? ${motor.isLimitSwitchPressed}"),
		MetricLine("$functionality  Direction: ${motor.direction.humanName}"),
		MetricLine("$functionality  Steps: ${motor.currentStep} --> ${motor.targetStep}"),
		MetricLine("$functionality  Angle: ${motor.angle}"),
	];

	@override
	List<MetricLine> get allMetrics => [
		...getMotorData(data.lift, "Lift",),
		MetricLine("------------------------------",),
		...getMotorData(data.rotate, "Rotate"),
		MetricLine("------------------------------",),
		...getMotorData(data.pinch, "Pinch"),
	];
}
