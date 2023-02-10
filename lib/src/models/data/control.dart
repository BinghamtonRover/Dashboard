import "dart:async";
import "dart:math";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";

import "model.dart";

double truncate(double x, [int digits = 2]) {
  final factor = pow(10, digits);
  final double result = x * factor;
  final int r = result.truncate();
  return r / factor;
}

/// A data model that listens for gamepad input and controls the rover.
class ControlModel extends Model {
  final drive = DriveCommand();

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
    timer = Timer.periodic(const Duration(milliseconds: 100), readGamepad);
  }

  Future<void> sendMessage(Message message) async {
    if (models.serial.isConnected) {
      await services.serial.sendMessage(message);
    } else {
      services.messageSender.sendMessage(message);
    }
  }

  /// Function to read Gamepad State
  /// Executes commands based on the current Operating mode
  void readGamepad(_) {
    services.gamepad.update();
    notifyListeners();
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
    final left = truncate(state.leftY);
    final right = truncate(state.rightY);
    services.drive.updateSpeed(left, right).forEach(sendMessage);
    if (state.dpadUp) {
      drive.throttle += 0.2;
      drive.throttle = truncate(drive.throttle);
      drive.throttle = drive.throttle.clamp(0, 1);
      services.drive.updateMaxSpeed(drive.throttle).forEach(sendMessage);
    } else if (state.dpadDown) {
      drive.throttle -= 0.2;
      drive.throttle = truncate(drive.throttle);
      drive.throttle = drive.throttle.clamp(0, 1);
      services.drive.updateMaxSpeed(drive.throttle).forEach(sendMessage);
    }
    print("Left: $left, right: $right, throttle: ${drive.throttle}");
  }

  /// Function to control rover in Science operating mode
  void handleScience() {
    final state = services.gamepad.state;
    if (!services.gamepad.isConnected) return;
    if (state.buttonA) {
      services.messageSender.sendMessage(ScienceCommand(dig: true));
    }
  }

  /// Function to control rover in Arm operating mode
  void handleArm() {

  }
}
