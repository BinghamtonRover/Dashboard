import "dart:async";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";

import "model.dart";


/// A data model that listens for gamepad input and controls the rover.
class ControlModel extends Model {
  /// Timer object to readGamepad
  /// Could be nullable
  Timer? timer;

  /// Initializes any data needed by this model.
  @override
  Future<void> init() async {
    await connect();
  }

  /// Function to connect to the Gamepad
  /// Only to be called after the rover and gamepad are connected
  Future<void> connect() async {
    // TODO: Actually connect
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
        handleScience();
        break;
    }
  }

  /// Function to control rover in Drive operating mode
  void handleDrive() {
    final state = services.gamepad.state;
    services.drive.updateSpeed(state.leftY, state.rightY);
  }

  /// Function to control rover in Science operating mode
  void handleScience() {

  }

  /// Function to control rover in Arm operating mode
  void handleArm() {

  }

}
