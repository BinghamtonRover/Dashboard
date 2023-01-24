import "../message_sender.dart";
import "../service.dart";


/// A service to send commands to the Rover when it is the [DriveControl] mode
class DriveControl extends Service {
  
  @override
  Future<void> init() async {
    final sender = MessageSender(); 
  } 

  @override
	Future<void> dispose() async {}

  /// Command to change the Rover's speed
  void updateSpeed(double left, double right, double throttle) { 
    //final message = DriveCommand(left, right, throttle);  // TODO: Protobuf class
    //sender.send_message(message);
  }
  
  /// Command to tell the Rover to brake
  void brake(){
    //final message = DriveCommand();
    //sender.send_message(message);
  }
}