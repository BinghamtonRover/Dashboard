import "controller.dart";

class ArmController extends Controller {
	// double swivel = 0, shoulder = 0, elbow = 0;

		// dpad: swivel + wrist
		// leftY: shoulder
		// rightY: elbow
		// bumpers: rotate wrist
	@override
	List<Message> parseInputs(GamepadState state) => [
		// ARM ONLY
		// if (state.dpadLeft) ArmCommand(moveSwivel: -1),
		// if (state.dpadRight) ArmCommand(moveSwivel: 1),
		// ArmCommand(moveElbow: state.normalRightY),
		// ArmCommand(moveShoulder: state.normalLeftY),

		// GRIPPER ONLY
		if (state.leftTrigger > 0) GripperCommand(moveGripper: -state.normalLeftTrigger),
		if (state.rightTrigger > 0) GripperCommand(moveGripper: state.normalRightTrigger),
		GripperCommand(moveRotate: state.normalRightX),
		// WARNING: LIFT IS BROKEN
		// GripperCommand(moveLift: state.normalRightY),
	];
	
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
