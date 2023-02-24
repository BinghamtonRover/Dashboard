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
		if (state.leftShoulder) ArmCommand(moveSwivel: -1),
		if (state.rightShoulder) ArmCommand(moveSwivel: 1),
		if (state.normalRightY != 0) ArmCommand(moveElbow: state.normalRightY),
		if (state.normalLeftY != 0) ArmCommand(moveShoulder: state.normalLeftY),

		// GRIPPER
		if (state.leftTrigger > 0) GripperCommand(moveGripper: -state.normalLeftTrigger),
		if (state.rightTrigger > 0) GripperCommand(moveGripper: state.normalRightTrigger),
		if (state.dpadUp) GripperCommand(moveLift: 1),
		if (state.dpadDown) GripperCommand(moveLift: -1),
		if (state.normalRightX != 0) GripperCommand(moveRotate: state.normalRightX),

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
		"Elbow": "Right joystick (vertical)",
		"Gripper Lift": "D-pad up/down",
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
