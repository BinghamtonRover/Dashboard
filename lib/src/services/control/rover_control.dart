import "../service.dart";
import "arm.dart";
import "drive.dart";


/// Class to Control the Rover based on different modes
class RoverControl extends Service {  
  final DriveControl drive = DriveControl();
  final ArmControl arm = ArmControl();
  
  @override 
  Future<void> init() async{ 
    await drive.init(); 
    await arm.init(); 
  }

  @override
	Future<void> dispose() async {}

  /// Method to [connect] to the rover
  /// There is a chance that the rover is not yet connected
  Future<void> connect() async { /* I'll explain this later */ }

  
  // ...
}