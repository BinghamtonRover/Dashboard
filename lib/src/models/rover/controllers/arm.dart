import "controller.dart";

/// Controls the arm.
class ArmController extends Controller {
	@override
	List<Message> parseInputs(GamepadState state) => [
		// ARM
		if (state.leftShoulder) ArmCommand(moveSwivel: -0.25),
		if (state.rightShoulder) ArmCommand(moveSwivel: 0.25),
		if (state.normalRightY != 0) ArmCommand(moveElbow: state.normalRightY),
		if (state.normalLeftY != 0) ArmCommand(moveShoulder: -state.normalLeftY),

		// GRIPPER
		if (state.leftTrigger > 0) GripperCommand(moveGripper: -state.normalLeftTrigger),
		if (state.rightTrigger > 0) GripperCommand(moveGripper: state.normalRightTrigger),
		if (state.dpadUp) GripperCommand(moveLift: 1),
		if (state.dpadDown) GripperCommand(moveLift: -1),
		if (state.normalRightX != 0) GripperCommand(moveRotate: 1.25*state.normalRightX),

		if (state.buttonBack) ArmCommand(stop: true),
		if (state.buttonBack) GripperCommand(stop: true),
		// if (state.buttonStart) ArmCommand(calibrate: true), 
		// if (state.buttonStart) GripperCommand(calibrate: true),
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
}
