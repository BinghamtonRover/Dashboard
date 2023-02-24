import "controller.dart";

/// Controls the arm.
class ArmController extends Controller {
	// double swivel = 0, shoulder = 0, elbow = 0;

	// dpad: swivel + wrist
	// leftY: shoulder
	// rightY: elbow
	// bumpers: rotate wrist
	@override
	List<Message> parseInputs(GamepadState state) => [
		// ARM
		if (state.dpadLeft) ArmCommand(moveSwivel: -1),
		if (state.dpadRight) ArmCommand(moveSwivel: 1),
		ArmCommand(moveElbow: state.normalRightY),
		ArmCommand(moveShoulder: state.normalLeftY),

		// GRIPPER
		if (state.leftTrigger > 0) GripperCommand(moveGripper: -state.normalLeftTrigger),
		if (state.rightTrigger > 0) GripperCommand(moveGripper: state.normalRightTrigger),
		GripperCommand(moveRotate: state.normalRightX),
		GripperCommand(moveLift: state.normalRightY),

		if (state.buttonStart) ...[
			ArmCommand(stop: true),
			GripperCommand(stop: true),
		]
	];

	@override
	List<Message> get onDispose => [
		ArmCommand(stop: true),
		GripperCommand(stop: true),
	];

	@override
	Map<String, String> get controls => {
		"Swivel": "Bumpers",
		"Shoulder": "Left joystick (vertical)",
		"Elbow": "D-pad up/down",
		"Gripper Lift": "Right joystick (vertical)",
		"Gripper rotate": "Right joystick (horizontal)",
		"Pinch": "Triggers",
	};
	
	// Message updateElbow(double value) {
	// 	elbow += value*increment;
	// 	elbow = elbow.clamp(-1, 1);
	// 	return ArmCommand(moveElbow: elbow);
	// }

	// Message updateSwivel(double value) {
	// 	swivel += value*increment;
	// 	swivel = swivel.clamp(-1, 1);
	// 	return ArmCommand(moveElbow: elbow);
	// }

	// Message updateShoulder(double value) {
	// 	shoulder += value*increment;
	// 	shoulder = shoulder.clamp(-1, 1);
	// 	return ArmCommand(moveShoulder: shoulder);
	// }
}
