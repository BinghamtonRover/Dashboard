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

  ///Check to see if the remote is connected
  ///
  ///returns true or false
  Future<bool> connect() async{ 
    if(gamepad.isConnected){
      return true;
    }else{
      return false;
    }
  }

  ///Return the current state of the remote
  GamepadState getState() => gamepad.state; 
 
  /// Checks the state of the controller and updates [state].
  Future<void> update() async => gamepad.updateState(); 

 

}