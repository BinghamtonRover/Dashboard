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

	/// Tracks whether the A button is pressed, so the action is only done once.
	bool isAPressed = false;

	/// Tracks whether the B button is pressed, so the action is only done once.
	bool isBPressed = false;

	/// Tracks whether the X button is pressed, so the action is only done once.
	bool isXPressed = false;

	/// Tracks whether the Y button is pressed, so the action is only done once.
	bool isYPressed = false;

	@override
	OperatingMode get mode => OperatingMode.arm;

	@override
	void updateState(GamepadState state) {
		if (!state.buttonA) isAPressed = false;
		if (!state.buttonB) isBPressed = false;
		if (!state.buttonX) isXPressed = false;
		if (!state.buttonY) isYPressed = false;
	}

	@override
	List<Message> parseInputs(GamepadState state) => [
    // Manual control
    if (state.normalRightX.abs() > state.normalRightY.abs() && state.normalRightX != 0)
      ArmCommand(swivel: MotorCommand(moveRadians: state.normalRightX * settings.swivel)),
    if (state.normalRightY.abs() > state.normalRightX.abs() && state.normalRightY != 0)
      ArmCommand(shoulder: MotorCommand(moveRadians: state.normalRightY * settings.shoulder)),
    if (state.normalLeftY != 0) ArmCommand(elbow: MotorCommand(moveRadians: state.normalLeftY * settings.elbow)),
    // The bumpers should be pseudo-IK: Move the shoulder and elbow in sync.
    if (state.normalShoulder != 0) ArmCommand(
      shoulder: MotorCommand(moveRadians: state.normalShoulder * settings.shoulder * -1),
      elbow: MotorCommand(moveRadians: state.normalShoulder * settings.elbow),
    ),

		// Gripper
		if (state.normalDpadY != 0) GripperCommand(lift: MotorCommand(moveRadians: state.normalDpadY * settings.lift)),
		if (state.normalDpadX != 0) GripperCommand(rotate: MotorCommand(moveRadians: state.normalDpadX * settings.rotate)),
		if (state.normalTrigger != 0) GripperCommand(pinch: MotorCommand(moveRadians: state.normalTrigger * settings.pinch)),

		// Custom actions
		if (state.buttonA && !isAPressed) () { isAPressed = true; return GripperCommand(open: true); }(),
		if (state.buttonB && !isBPressed) () { isBPressed = true; return GripperCommand(close: true); }(),
		if (state.buttonX && !isXPressed) () { isXPressed = true; return ArmCommand(jab: true); }(),
		if (state.buttonY && !isYPressed) () { isYPressed = true; return GripperCommand(spin: true); }(),

		// General commands
		if (state.buttonBack) ...[ArmCommand(stop: true), GripperCommand(stop: true)],
		if (state.buttonStart) ...[ArmCommand(calibrate: true), GripperCommand(calibrate: true)],
	];

	@override
	List<Message> get onDispose => [ ArmCommand(stop: true), GripperCommand(stop: true) ];

	@override
	Map<String, String> get buttonMapping => {
    // Manual control
    "Swivel": "Right joystick (horizontal)",
    "Shoulder": "Right joystick (vertical)",
    "Elbow": "Left stick (vertical)",
    "Pseudo-IK": "Bumpers",

		// Gripper
		"Lift gripper": "D-pad up/down",
		"Rotate gripper": "D-pad left/right",
		"Pinch": "Triggers",

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
