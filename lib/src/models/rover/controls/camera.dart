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
  
	@override
	OperatingMode get mode => OperatingMode.cameras;

	@override
	List<Message> parseInputs(GamepadState state) => [
    DriveCommand(frontSwivel: frontSwivel),
    DriveCommand(frontTilt: frontTilt),
    DriveCommand(rearSwivel: rearSwivel),
    DriveCommand(rearTilt: rearTilt),
	];

  @override
  void updateState(GamepadState state) {
    frontSwivel += state.normalRightX * cameraSwivelIncrement;
    frontTilt += state.normalRightY * cameraTiltIncrement;
    rearSwivel += state.normalLeftX * cameraSwivelIncrement;
    rearTilt += state.normalLeftY * cameraTiltIncrement;
    frontSwivel = frontSwivel.clamp(0, 180);
    frontTilt = frontTilt.clamp(0, 180);
    rearSwivel = rearSwivel.clamp(0, 180);
    rearTilt = rearTilt.clamp(0, 180);
  }

	@override
	List<Message> get onDispose => [];

	@override
	Map<String, String> get buttonMapping => {
		"Front camera": "Right trigger + joystick",
		"Rear camera": "Left trigger + joystick",
		"MARS swivel": "D-pad (horizontal)",
	};
}
