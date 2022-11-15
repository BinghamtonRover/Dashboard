import "package:win32_gamepad/win32_gamepad.dart";

import "service.dart";

/// A service to receive input from a gamepad connected to the user's device.
/// 
/// This service uses [`package:win32_gamepad`](https://pub.dev/packages/win32_gamepad), to read 
/// controller inputs, which works with XInput-compliant devices. At the time of writing, there 
/// are no gamepad plugins on pub.dev available for MacOS or Linux -- this uses Win32 libraries.
/// 
/// To read the state of the controller, check [state]. Even if the controller is disconnected, 
/// [state] will be available, but all its fields will be zero. To check for a connection, use
/// [isConnected] instead. No action is needed to check for a new gamepad, but you must call
/// [update] to read any button presses, or else [state] will never update. 
class GamepadService extends Service {
  /// The first gamepad connected to the user's device.
  /// 
  /// No action is needed to connect to a gamepad. Use [isConnected] to check if there is a 
  /// gamepad connected, and use [state] to read it. 
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
  /// 
  /// New button presses will not be recorded until this is called, so you should try to do
  /// so in a way that it is called periodically, either via a timer or Flutter's build function.
  void update() => gamepad.updateState(); 
}
