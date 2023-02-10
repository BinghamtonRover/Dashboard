import "package:rover_dashboard/data.dart";
import "../service.dart";

/// A service to send commands to the Rover when it is the [DriveControl] mode
class DriveControl extends Service {
  @override
  Future<void> init() async {}

  @override
  Future<void> dispose() async {}

  /// Command to change the Rover's speed
  Iterable<Message> updateSpeed(double left, double right) => [
    DriveCommand(left: left),
    DriveCommand(right: right),
  ];

  /// Updates the maximum speed of the rover, as a percentage of its total capable speed.
  Iterable<Message> updateMaxSpeed(double throttle) => [
    DriveCommand(throttle: throttle),
  ];

  /// Command to tell the Rover to brake
  Iterable<Message> brake() => [
    ...updateMaxSpeed(0),
    ...updateSpeed(0, 0),
  ];
}
