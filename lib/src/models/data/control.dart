import 'dart:async';
import 'package:rover_dashboard/data.dart';

import "model.dart";
import "package:rover_dashboard/services.dart";
import "package:rover_dashboard/models.dart";

class ControlModel extends Model {
  Timer? timer;

  /// Initializes any data needed by this model.
  @override
  Future<void> init() async {}

  /// Function to connect to the Gamepad
  /// Only to be called after the rover and gamepad are connected
  Future<void> connect() async {
    timer = Timer.periodic(const Duration(milliseconds: 10), readGamepad);
  }

  /// Function to read Gamepad State
  /// Executes commands based on the current Operating mode
  void readGamepad(_) {
    services.gamepad.update();
    switch (models.home.mode) {
      case OperatingMode.arm:
        break;
      case OperatingMode.autonomy:
        break;
      case OperatingMode.drive:
        handleDrive();
        break;
      case OperatingMode.science:
        break;
    }
  }

  /// Function to control rover in drive operating mode
  void handleDrive() {
    final state = services.gamepad.state;
    services.drive.updateSpeed(
        state.leftThumbstickY.toDouble(), state.rightThumbstickY.toDouble(), 1);
  }
}
