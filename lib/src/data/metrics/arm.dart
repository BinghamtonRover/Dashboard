import "package:rover_dashboard/data.dart";

/// Metrics reported by the HREI subsystem about the arm. Does not include the gripper.
class ArmMetrics extends Metrics<ArmData> {
	/// Metrics from the arm.
	ArmMetrics() : super(ArmData());

	@override
	String get name => "Arm Base";

	/// Returns a description of a [MotorData].
	List<String> getMotorData(MotorData motor) => [
		"  Is moving? ${motor.isMoving}",
		"  Limit? ${motor.isLimitSwitchPressed}",
		"  Direction: ${motor.direction.humanName}",
		"  Steps: ${motor.currentStep} --> ${motor.targetStep}",
		"  Angle: ${motor.angle}",
	];

	@override
	List<String> get allMetrics => [
		"IK: ",
		"  Current: ${data.currentPosition.prettyPrint}",
		"  Target: ${data.targetPosition.prettyPrint}",
		"------------------------------",
		"Swivel: ", ...getMotorData(data.base),
		"------------------------------",
		"Shoulder: ", ...getMotorData(data.shoulder),
		"------------------------------",
		"Elbow: ", ...getMotorData(data.elbow),
	];
}
