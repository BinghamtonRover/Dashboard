import "package:win32_gamepad/win32_gamepad.dart";

import "service.dart";

/// A service to receive input from remote control for the robot
/// Uses win32_gamepad to interact with remote. win32_gamepad only works on windows 
///
/// Used to get the current status of the remote control 
///   -buttons pressed, etc
class GamepadService extends Service {
  ///The connection to the controller
  static final gamepad = Gamepad(0);
  
  @override
  Future<void> init() async { }

  @override
  Future<void> dispose() async { }

/// Whether the gamepad is connected to the user's device. 
bool get isConnected => gamepad.isConnected;

  /// The current state of the gamepad, its buttons, and its connection state. 
  GamepadState get state => gamepad.state; 
 
  /// Checks the state of the controller and updates [state].
  Future<void> update() async => gamepad.updateState(); 
}
