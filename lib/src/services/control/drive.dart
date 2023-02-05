import "package:rover_dashboard/services.dart";
import "../service.dart";

/// A service to send commands to the Rover when it is the [DriveControl] mode
class DriveControl extends Service {
  @override
  Future<void> init() async {}

  @override
  Future<void> dispose() async {}

  /// Command to change the Rover's speed
  void updateSpeed(double left, double right, double throttle) {
    //final message = DriveCommand(left, right, throttle); // TODO: Protobuf class
    //services.messageSender.sendMessage(message);
    print("Speed is being updated ${left}, ${right}, ${throttle}");
  }

  /// Command to tell the Rover to brake
  void brake() {
    updateSpeed(0, 0, 0);
  }
}
