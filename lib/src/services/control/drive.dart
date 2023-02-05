import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/services.dart";
import "../service.dart";

/// A service to send commands to the Rover when it is the [DriveControl] mode
class DriveControl extends Service {
  @override
  Future<void> init() async {}

  @override
  Future<void> dispose() async {}

  /// Command to change the Rover's speed
  void updateSpeed(double left, double right) {
    //final message = DriveCommand(left, right, throttle); // TODO: Protobuf class
    //services.messageSender.sendMessage(message);
    if (left != 0) {
      services.messageSender.sendMessage(DriveCommand(left: left));
    }
    if (right != 0) {
      services.messageSender.sendMessage(DriveCommand(right: right));
    }
  }

  /// Updates the maximum speed of the rover, as a percentage of its total capable speed.
  void updateMaxSpeed(double throttle) {
    services.messageSender.sendMessage(DriveCommand(throttle: throttle));
  }

  /// Command to tell the Rover to brake
  void brake() {
    updateMaxSpeed(0);
    updateSpeed(0, 0);
  }
}
