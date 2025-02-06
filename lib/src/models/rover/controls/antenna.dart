import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";

/// A [RoverControls] that controls the antenna manually.
class AntennaControls extends RoverControls {
  /// The user's arm settings.
	ArmSettings get settings => models.settings.arm;

  @override
  OperatingMode get mode => OperatingMode.antenna;

  @override
  List<Message> parseInputs(GamepadState state) => [
    if (state.normalRightX.abs() > state.normalRightY.abs() && state.normalRightX != 0)
      AntennaFirmwareCommand(swivel: MotorCommand(moveRadians: state.normalRightX * settings.swivel)),
  ];

  @override
	Map<String, String> get buttonMapping => {
    "Swivel": "Right joystick (horizontal)",
  };

  @override
	List<Message> get onDispose => [ AntennaFirmwareCommand(stop: true), ];
}
