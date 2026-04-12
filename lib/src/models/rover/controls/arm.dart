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
    // Base command
    ArmCommand(usingIk: BoolState.NO),

    // Manual control
    if (state.normalRightX.abs() > state.normalRightY.abs() && state.normalRightX != 0)
      ArmCommand(swivel: MotorCommand(moveRadians: state.normalRightX * settings.swivel)),
    if (state.normalRightY.abs() > state.normalRightX.abs() && state.normalRightY != 0)
      ArmCommand(shoulder: MotorCommand(moveRadians: state.normalRightY * settings.shoulder)),
    if (state.normalLeftY != 0) ArmCommand(elbow: MotorCommand(moveRadians: state.normalLeftY * settings.elbow)),

    // Arm band roll
    if (state.normalShoulder != 0)
      ArmCommand(
        roll: MotorCommand(
          moveRadians: state.normalShoulder * settings.armRoll,
        ),
      ),

    // Wrist
		if (state.normalDpadY != 0)
      ArmCommand(
        wrist: WristCommand(
          pitch: MotorCommand(moveRadians: state.normalDpadY * settings.lift),
        ),
      ),
    if (state.normalDpadX != 0)
      ArmCommand(
        wrist: WristCommand(
          roll: MotorCommand(moveRadians: state.normalDpadX * settings.wristRoll),
        ),
      ),
    if (state.normalTriggers != 0)
      ArmCommand(
        pinch: MotorCommand(moveRadians: state.normalTriggers * settings.pinch),
      ),

		// Custom actions
		if (state.buttonA && !isAPressed) () { isAPressed = true; return ArmCommand(open: true); }(),
		if (state.buttonB && !isBPressed) () { isBPressed = true; return ArmCommand(close: true); }(),
		if (state.buttonX && !isXPressed) () { isXPressed = true; return ArmCommand(jab: true); }(),
		if (state.buttonY && !isYPressed) () { isYPressed = true; return ArmCommand(spin: true); }(),

		// General commands
		if (state.buttonBack) ...[ArmCommand(stop: true), ArmCommand(stop: true)],
		if (state.buttonStart) ...[ArmCommand(calibrate: true), ArmCommand(calibrate: true)],
	];

  @override
  List<Message> get onDispose => [ ArmCommand(stop: true), ArmCommand(stop: true) ];

  @override
  Map<String, String> get buttonMapping => {
    // Manual control
    "Swivel": "Right joystick (horizontal)",
    "Shoulder": "Right joystick (vertical)",
    "Elbow": "Left stick (vertical)",

    // Wrist
    "Arm Roll": "Bumpers",
    "Wrist Pitch": "D-pad up/down",
    "Wrist Roll": "D-pad left/right",
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
