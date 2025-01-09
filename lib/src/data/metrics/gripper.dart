import "package:rover_dashboard/data.dart";

/// Metrics about the gripper on the HREI subsystem.
class GripperMetrics extends Metrics<GripperData> {
	/// Metrics about the gripper.
	GripperMetrics() : super(GripperData());

	@override
	String get name => "Gripper";

	/// Returns a description of a [MotorData].
	List<MetricLine> getMotorData(MotorData motor) => [
		MetricLine("  Is moving? ${motor.isMoving.displayName}", severity: motor.isMoving.toBool() ? Severity.info : null),
		MetricLine("  Limit? ${motor.isLimitSwitchPressed.displayName}", severity: motor.isLimitSwitchPressed.toBool() ? Severity.warning : null),
		MetricLine("  Direction: ${motor.direction.humanName}"),
		MetricLine("  Steps: ${motor.currentStep} --> ${motor.targetStep}"),
		MetricLine("  Angle: ${motor.currentAngle.toDegrees() % 360} degrees"),
	];

	@override
	List<MetricLine> get allMetrics => [
    MetricLine("Camera Angle: ${data.servoAngle} degrees"),
    MetricLine("Laser: ${data.laserState.displayName}", severity: data.laserState.toBool() ? Severity.critical : null),
    MetricLine("------------------------------",),
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
  Version get supportedVersion => Version(major: 1);

  @override
  Version parseVersion(GripperData message) => message.version;

  @override
  Message get versionCommand => GripperCommand(version: supportedVersion);
}
