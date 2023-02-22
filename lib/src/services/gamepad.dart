import "package:win32_gamepad/win32_gamepad.dart";

import "service.dart";

export "package:win32_gamepad/win32_gamepad.dart";

/// The "deadzone" of the gamepad.
const epsilon = 0.01;

/// An extension to do gamepad math.
extension GamepadNumbers on num {
  /// Normalizes joystick inputs to be between 0 and 1.
  double get normalizeJoystick {
    final value = (this - 128) / 32768;
    return (value.abs() < epsilon) ? 0 : value;
  }

  double get normalizeTrigger {
    final value = this / 256;
    return (value.abs() < epsilon) ? 0 : value;
  }
}

extension GamepadUtils on GamepadState {
  double get normalLeftTrigger => leftTrigger.normalizeTrigger.clamp(0, 1);
  double get normalRightTrigger => rightTrigger.normalizeTrigger.clamp(0, 1);

  double get normalLeftX => leftThumbstickX.normalizeJoystick.clamp(-1, 1);
  double get normalLeftY => leftThumbstickY.normalizeJoystick.clamp(-1, 1);
  double get normalRightX => rightThumbstickX.normalizeJoystick.clamp(-1, 1);
  double get normalRightY => rightThumbstickY.normalizeJoystick.clamp(-1, 1);
}

/// The maximum amount of gamepads a user can have.
const maxGamepads = 4;

/// The default vibration intensity.
/// 
/// This value is stored in an unsigned 16-bit integer, so it's range is from 0-65,535.
const vibrateIntensity = 65000;

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
  Gamepad gamepad = Gamepad(0);
  
  @override
  Future<void> init() async => connect();

  @override
  Future<void> dispose() async { }

  /// Connects to a gamepad and calls [vibrate].
  Future<bool> connect() async {
    for (int i = 0; i < maxGamepads; i++) {
      gamepad = Gamepad(i);
      if (gamepad.isConnected) break;
    }
    if (gamepad.isConnected) vibrate();
    return gamepad.isConnected;
  }

  /// Makes the gamepad vibrate a small "pulse" 
  void vibrate() async {  // ignore: avoid_void_async 
    // ^ because this should not be awaited
    if (!isConnected) return;
    gamepad.vibrate(leftMotorSpeed: vibrateIntensity, rightMotorSpeed: vibrateIntensity);
    await Future.delayed(const Duration(milliseconds: 300));
    gamepad.vibrate();
    await Future.delayed(const Duration(milliseconds: 100));
    gamepad.vibrate(leftMotorSpeed: vibrateIntensity, rightMotorSpeed: vibrateIntensity);
    await Future.delayed(const Duration(milliseconds: 300));
    gamepad.vibrate();
  }

  /// The battery of the connected controller.
  GamepadBatteryLevel get battery => gamepad.gamepadBatteryInfo.batteryLevel;

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
