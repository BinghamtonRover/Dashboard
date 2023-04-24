import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";

/// A [RoverControls] that controls the arm.
class ArmControls extends RoverControls {
	/// The user's arm settings.
	ArmSettings get settings => models.settings.arm;

	/// The coordinates of the gripper.
	/// 
	/// The arm uses IK to move all the joints to stay at these coordinates.
	Coordinates ik = Coordinates(x: 0.5, y: 0.5, z: 0.5);

	@override
	OperatingMode get mode => OperatingMode.arm;

	/// Updates the IK coordinates by the given offsets.
	List<Message> updateIK(double x, double y, double z) {
		if (x == 0 && y == 0 && z == 0) return [];
		ik += Coordinates(x: x, y: y, z: z);
		return [ArmCommand(ikX: 1, ikY: ik.y, ikZ: ik.z)];
	}

	@override
	List<Message> parseInputs(GamepadState state) => [
		// Arm
		if (settings.manualControl) ...[
			// Manual control
			if (state.normalRightX != 0) ArmCommand(swivel: MotorCommand(moveRadians: state.normalRightX * settings.radianIncrement)),
			if (state.normalRightY != 0) ArmCommand(shoulder: MotorCommand(moveRadians: state.normalRightY * settings.radianIncrement)),
			if (state.normalShoulder != 0) ArmCommand(elbow: MotorCommand(moveRadians: state.normalShoulder * settings.radianIncrement)),
			if (settings.useSteps) ...[
				if (state.normalDpadX != 0) ArmCommand(swivel: MotorCommand(moveSteps: (state.normalDpadX * settings.stepIncrement).round())),
				if (state.normalDpadY != 0) ArmCommand(elbow: MotorCommand(moveSteps: (state.normalDpadY * settings.stepIncrement).round())),
			] else ...[
				if (state.normalDpadX != 0) ArmCommand(swivel: MotorCommand(moveRadians: state.normalDpadX * settings.preciseIncrement)),
				if (state.normalDpadY != 0) ArmCommand(elbow: MotorCommand(moveRadians: state.normalDpadY * settings.preciseIncrement)),
			]
		] else ...[
			// IK
			...updateIK(state.normalRightX * settings.ikIncrement, state.normalShoulder * settings.ikIncrement, state.normalRightY * settings.ikIncrement),
			...updateIK(state.normalDpadX * settings.ikPreciseIncrement, 0, state.normalRightY * settings.ikPreciseIncrement),
		],

		// Gripper
		if (state.normalTrigger != 0) GripperCommand(pinch: MotorCommand(moveRadians: state.normalTrigger * settings.radianIncrement)),
		if (state.normalLeftX != 0) GripperCommand(rotate: MotorCommand(moveRadians: state.normalLeftX * settings.radianIncrement)),
		if (state.normalLeftY != 0) GripperCommand(lift: MotorCommand(moveRadians: state.normalLeftY * settings.radianIncrement)),

		// Custom actions
		if (state.buttonA) GripperCommand(open: true),
		if (state.buttonB) GripperCommand(close: true),
		if (state.buttonX) ArmCommand(jab: true),
		if (state.buttonY) GripperCommand(spin: true),

		// General
		if (state.buttonBack) ...[ArmCommand(stop: true), GripperCommand(stop: true)],
		if (state.buttonStart) ...[ArmCommand(calibrate: true), GripperCommand(calibrate: true)],
	];

	@override
	List<Message> get onDispose => [
		ArmCommand(stop: true),
		GripperCommand(stop: true),
	];

	@override
	Map<String, String> get buttonMapping => {
		// Arm
		if (settings.manualControl) ...{
			// Manual control
			"Swivel": "Right joystick (horizontal)",
			"Shoulder": "Right joystick (vertical)",
			"Elbow": "Bumpers",
			"Precise swivel": "D-pad horizontal",
			"Precise elbow": "D-pad vertical",
		} else ...{
			// IK
			"IK control": "Right joystick",
			"IK depth": "Bumpers",
			"Precise IK": "D-pad",
		},

		// Gripper
		"Pinch": "Triggers",
		"Rotate gripper": "Left joystick (horizontal)",
		"Lift gripper": "Left joystick (vertical)",

		// Custom actions
		"Fully close": "A",
		"Fully open": "B",
		"Press keyboard": "X",
		"Spin gripper": "Y",

		// General
		"Stop": "Select",
		"Calibrate": "Start",
	};
}
