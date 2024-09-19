import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/services.dart";

import "controls.dart";

/// A [RoverControls] for the rover's front and rear cameras.
class CameraControls extends RoverControls {
  /// How far to tilt the cameras each tick.
  static const cameraTiltIncrement = 1;

  /// How far to swivel the cameras each tick.
  static const cameraSwivelIncrement = 1;

  /// The angle of the front tilt servo.
  double frontTilt = 90;

  /// The angle of the front swivel servo.
  double frontSwivel = 90;

  /// The angle of the rear tilt servo.
  double rearTilt = 90;

  /// The angle of the rear swivel servo.
  double rearSwivel = 90;

  /// The angle of the camera attached to the arm.
  double armTilt = 90;

	@override
	OperatingMode get mode => OperatingMode.cameras;

	@override
	List<Message> parseInputs(GamepadState state) => [
    DriveCommand(frontSwivel: frontSwivel),
    DriveCommand(frontTilt: frontTilt),
    DriveCommand(rearSwivel: rearSwivel),
    DriveCommand(rearTilt: rearTilt),
    GripperCommand(servoAngle: armTilt.round()),
	];

  @override
  void updateState(GamepadState state) {
    // Update only ONE camera. Go left to right.
    final newFrontSwivel = state.normalLeftX;
    final newFrontTilt = state.normalLeftY;
    final newRearSwivel = state.normalRightX;
    final newRearTilt = -1 * state.normalRightY;
    if (newFrontSwivel.abs() >= 0.05 || newFrontTilt.abs() >= 0.05) {
      // Update the front camera. Now, choose which axis
      if (newFrontSwivel.abs() > newFrontTilt.abs()) {
        frontSwivel += newFrontSwivel * cameraSwivelIncrement;
      } else {
        frontTilt += newFrontTilt * cameraTiltIncrement;
      }
    } else if (newRearSwivel.abs() >= 0.05 || newRearTilt.abs() >= 0.05) {
      if (newRearSwivel.abs() > newRearTilt.abs()) {
        rearSwivel += newRearSwivel * cameraSwivelIncrement;
      } else {
        rearTilt += newRearTilt * cameraTiltIncrement * -1;
      }
    }

    armTilt += -1 * state.normalDpadY * cameraTiltIncrement;
    armTilt = armTilt.clamp(0, 180);
    frontSwivel = frontSwivel.clamp(0, 180);
    frontTilt = frontTilt.clamp(0, 60);
    rearSwivel = rearSwivel.clamp(0, 180);
    rearTilt = rearTilt.clamp(0, 180);
  }

	@override
	List<Message> get onDispose => [];

	@override
	Map<String, String> get buttonMapping => {
		"Front camera": "Right trigger + joystick",
		"Rear camera": "Left trigger + joystick",
    "Arm camera": "D-pad up/down",
	};
}
