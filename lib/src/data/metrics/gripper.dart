import "package:rover_dashboard/data.dart";

/// Metrics about the gripper on the HREI subsystem.
class GripperMetrics extends Metrics<GripperData> {
	/// Metrics about the gripper.
	GripperMetrics() : super(GripperData());

	@override
	String get name => "Gripper";

	/// Returns a description of a [MotorData].
	List<MetricLine> getMotorData(MotorData motor) => [
		MetricLine("  Is moving? ${motor.isMoving}", severity: motor.isMoving ? Severity.info : null),
		MetricLine("  Limit? ${motor.isLimitSwitchPressed}", severity: motor.isLimitSwitchPressed ? Severity.warning : null),
		MetricLine("  Direction: ${motor.direction.humanName}"),
		MetricLine("  Steps: ${motor.currentStep} --> ${motor.targetStep}"),
		MetricLine("  Angle: ${motor.angle.toDegrees()} degrees"),
	];

	@override
	List<MetricLine> get allMetrics => [
    MetricLine("Lift:"),
		...getMotorData(data.lift,),
		MetricLine("------------------------------",),
    MetricLine("Rotate"),
		...getMotorData(data.rotate),
		MetricLine("------------------------------",),
    MetricLine("Pinch:"),
		...getMotorData(data.pinch),
	];

  @override
  Version get supportedVersion => Version();

  @override
  Version parseVersion(GripperData message) => Version();

  @override
  Message get versionCommand => GripperCommand();
}
