import "package:win32_gamepad/win32_gamepad.dart";

import "service.dart";

///A service to send the comtroller's activity
///using win32_gamepad
class GamepadService extends Service {
  ///The connection to the controller
  static final gamepad = Gamepad(0);
  
  @override
  Future<void> init() async{ 
    connect();
  }

  @override
  Future<void> dispose() async{  
    gamepad.state = GamepadState.disconnected();
  } 

/// Whether the gamepad is connected to the user's device. 
bool get isConnected => gamepad.isConnected;

  /// The current state of the gamepad, its buttons, and its connection state. 
  GamepadState get state => gamepad.state; 
 
  /// Checks the state of the controller and updates [state].
  Future<void> update() async => gamepad.updateState(); 
}
