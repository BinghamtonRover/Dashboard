import "package:win32_gamepad/win32_gamepad.dart";

import "service.dart";

export "package:win32_gamepad/win32_gamepad.dart";

/// The "deadzone" of the gamepad.
const epsilon = 0.01;

/// An extension to do gamepad math.
extension GamepadNumbers on num {
  /// Normalizes joystick inputs to be between -1 and 1.
  double get normalizeJoystick {
    final value = (this - 128) / 32768;
    return (value.abs() < epsilon) ? 0 : value.clamp(-1, 1);
  }

  /// Normalizes the trigger inputs to be between 0 and 1.
  double get normalizeTrigger {
    final value = this / 256;
    return (value.abs() < epsilon) ? 0 : value.clamp(0, 1);
  }
}

/// More user-friendly values from [GamepadState].
extension GamepadUtils on GamepadState {
  /// Returns a normalized value for the left trigger. See [GamepadNumbers.normalizeTrigger].
  double get normalLeftTrigger => leftTrigger.normalizeTrigger;

  /// Returns a normalized value for the right trigger. See [GamepadNumbers.normalizeTrigger].
  double get normalRightTrigger => rightTrigger.normalizeTrigger;

  /// Returns a normalized value for the left joystick's X-axis. See [GamepadNumbers.normalizeJoystick].
  double get normalLeftX => leftThumbstickX.normalizeJoystick;

  /// Returns a normalized value for the left joystick's Y-axis. See [GamepadNumbers.normalizeJoystick].
  double get normalLeftY => leftThumbstickY.normalizeJoystick;

  /// Returns a normalized value for the right joystick's X-axis. See [GamepadNumbers.normalizeJoystick].
  double get normalRightX => rightThumbstickX.normalizeJoystick;

  /// Returns a normalized value for the right joystick's Y-axis. See [GamepadNumbers.normalizeJoystick].
  double get normalRightY => rightThumbstickY.normalizeJoystick;
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
  Gamepad gamepad1 = Gamepad(0);

  /// The second gamepad connected to the user's device.
  Gamepad gamepad2 = Gamepad(1);

  @override
  Future<void> init() async => connect();

  @override
  Future<void> dispose() async {}

  /// Connects to a gamepad and calls [vibrate].
  Future<bool> connect() async {
    int i;
    for (i = 0; i < maxGamepads; i++) {
      gamepad1 = Gamepad(i);
      if (gamepad1.isConnected) break;
    }
    for (i = i + 1; i < maxGamepads; i++) {
      gamepad2 = Gamepad(i);
      if (gamepad2.isConnected) break;
    }
    if (gamepad1.isConnected) await vibrate(gamepad1);
    if (gamepad2.isConnected) await vibrate(gamepad2);
    return isConnected1 || isConnected2;
  }

  /// Makes the gamepad vibrate a small "pulse"
  Future<void> vibrate(Gamepad gamepad) async {
    // ignore: avoid_void_async
    // ^ because this should not be awaited
    if (!gamepad.isConnected) return;
    gamepad.vibrate(
        leftMotorSpeed: vibrateIntensity, rightMotorSpeed: vibrateIntensity);
    await Future.delayed(const Duration(milliseconds: 300));
    gamepad.vibrate();
    await Future.delayed(const Duration(milliseconds: 100));
    gamepad.vibrate(
        leftMotorSpeed: vibrateIntensity, rightMotorSpeed: vibrateIntensity);
    await Future.delayed(const Duration(milliseconds: 300));
    gamepad.vibrate();
  }

  /// The battery of the first controller.
  GamepadBatteryLevel get battery1 => gamepad1.gamepadBatteryInfo.batteryLevel;

  /// The battery of the second controller.
  GamepadBatteryLevel get battery2 => gamepad2.gamepadBatteryInfo.batteryLevel;

  /// Whether the first gamepad is connected to the user's device.
  bool get isConnected1 => gamepad1.isConnected;

  /// Whether the second gamepad is connected to the user's device.
  bool get isConnected2 => gamepad2.isConnected;

  /// The current state of the first gamepad, its buttons, and its connection state.
  GamepadState get state1 => gamepad1.state;

  /// The current state of the second gamepad, its buttons, and its connection state.
  GamepadState get state2 => gamepad2.state;

  /// Checks the state of the controller and updates [state1] and [state2].
  ///
  /// New button presses will not be recorded until this is called, so you should try to do
  /// so in a way that it is called periodically, either via a timer or Flutter's build function.
  void update() {
    gamepad1.updateState();
    gamepad2.updateState();
  }
}
