import "package:rover_dashboard/data.dart";

/// Metrics about the gripper on the HREI subsystem.
class GripperMetrics extends Metrics<GripperData> {
	/// Metrics about the gripper.
	GripperMetrics() : super(GripperData());

	@override
	String get name => "Gripper";

	/// Returns a human-readable description of a [MotorData].
	List<String> getMotorData(MotorData motor) => [
		"  Is moving? ${motor.isMoving}",
		"  Limit? ${motor.isLimitSwitchPressed}",
		"  Direction: ${motor.direction.humanName}",
		"  Steps: ${motor.currentStep} --> ${motor.targetStep}",
		"  Angle: ${motor.angle}",
	];

	@override
	List<String> get allMetrics => [
		"Lift: ", ...getMotorData(data.lift),
		"------------------------------",
		"Rotate: ", ...getMotorData(data.rotate),
		"------------------------------",
		"Pinch: ", ...getMotorData(data.pinch),
	];
}
