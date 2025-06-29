import "package:burt_network/protobuf.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/src/data/modes.dart";
import "package:rover_dashboard/src/services/gamepad/state.dart";

/// A [RoverControls] that contols the Base Station manually
class BaseStationControls extends RoverControls {
  @override
  OperatingMode get mode => OperatingMode.baseStation;

  @override
  Iterable<Message> get onDispose => [];

  @override
  Iterable<Message> parseInputs(GamepadState state) => [
    BaseStationCommand(
      mode: AntennaControlMode.MANUAL_CONTROL,
      manualCommand: AntennaFirmwareCommand(
        swivel: MotorCommand(
          moveRadians: -state.normalRightX * 0.005,
        ),
      ),
      version: Version(major: 1),
    ),
  ];

  @override
  Map<String, String> get buttonMapping => {
    "Swivel": "Right Joystick (horizontal)",
  };
}
