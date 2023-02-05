import "../service.dart";
import "arm.dart";
import "drive.dart";


/// Class to Control the Rover based on different modes
class RoverControl extends Service {  
  /// A service to control the drive subsystem.
  final DriveControl drive = DriveControl();

  /// A service to control the arm subsystem.
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
