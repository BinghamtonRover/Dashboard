import "dart:io";
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

/// An "implementation" of `package:win32_gamepad` for non-supported platforms.
class MockGamepad implements Gamepad {
  @override
  void updateState() { }

  @override
  void vibrate({int? leftMotorSpeed, int? rightMotorSpeed}) { }

  @override
  int get controller => -1;

  @override
  GamepadBatteryInfo get gamepadBatteryInfo => GamepadBatteryInfo(0, GamepadDeviceType.controller);

  @override
  GamepadBatteryInfo get headsetBatteryInfo => GamepadBatteryInfo(0, GamepadDeviceType.headset);

  @override
  bool get isConnected => false;

  @override
  GamepadState get state => GamepadState.disconnected();

  @override
  set appHasFocus(bool value) { }  // ignore: avoid_setters_without_getters

  @override
  set state(GamepadState value) { }
}

/// More user-friendly values from [GamepadState].
extension GamepadStateUtils on GamepadState {
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

  /// The signed value of the bumpers. The left bumper is negative, the right is positive.
  double get normalShoulder {
    if (leftShoulder) return -1;
    if (rightShoulder) return 1;
    return 0;
  }

  /// The signed value of the triggers. The left trigger is negative, the right is positive.
  double get normalTrigger {
    if (leftTrigger > 0) return -normalLeftTrigger;
    if (rightTrigger > 0) return normalRightTrigger;
    return 0;
  }

  /// The signed value of the D-pad's horizontal axis. Left is -1, right is +1.
  double get normalDpadX {
    if (dpadLeft) return -1;
    if (dpadRight) return 1;
    return 0;
  }

  /// The signed value of the D-pad's vertical axis. Up is +1, down is -1.
  double get normalDpadY {
    if (dpadUp) return 1;
    if (dpadDown) return -1;
    return 0;
  }
}

/// Convenience methods on [Gamepad].
extension GamepadUtils on Gamepad {
  /// A shorthand to get the battery level of this controller.
  GamepadBatteryLevel get battery => gamepadBatteryInfo.batteryLevel;

  /// Makes the gamepad vibrate a small "pulse"
  void pulse() async {  // ignore: avoid_void_async, because this should not be awaited
    if (!isConnected) return;
    vibrate(leftMotorSpeed: vibrateIntensity, rightMotorSpeed: vibrateIntensity);
    await Future<void>.delayed(const Duration(milliseconds: 200));
    vibrate();  // default speed of 0
    await Future<void>.delayed(const Duration(milliseconds: 100));
    vibrate(leftMotorSpeed: vibrateIntensity, rightMotorSpeed: vibrateIntensity);
    await Future<void>.delayed(const Duration(milliseconds: 200));
    vibrate();  // default speed of 0
  }
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
/// To read the state of the controller, check [Gamepad.state], which will always be available, even
/// when the controller is disconnected (all its fields will be zero). To check for a connection, use
/// [Gamepad.isConnected]. No action is needed to check for a new gamepad, but you must call
/// [update] to read any button presses, or else [Gamepad.state] will never update.
class GamepadService extends Service {
  /// The maximum number of gamepads we support.
  static const int numGamepads = 2;

  /// A list of all the [Gamepad]s the user has connected.
  /// 
  /// Non-connected gamepads are represented with [MockGamepad]s, which has the nice benefit of
  /// automatically handling the case where the user is on a non-supported platform.
  final List<Gamepad> gamepads = [
    for (int i = 0; i < numGamepads; i++) MockGamepad()
  ];

  /// The set of all the [Gamepad.controller] IDs.
  Set<int> get ids => {
    for (final gamepad in gamepads) gamepad.controller
  };

  @override
  Future<void> init() async {
    for (int i = 0; i < numGamepads; i++) {
      await connect(i);
    }
  }

  @override
  Future<void> dispose() async {}

  /// Connects to a gamepad and calls [GamepadUtils.pulse].
  Future<void> connect(int index) async {
    if (!Platform.isWindows) return;
    gamepads[index] = MockGamepad();
    for (int i = 0; i < maxGamepads; i++) {
      final gamepad = Gamepad(i);
      if (!gamepad.isConnected) continue;
      if (ids.contains(i)) continue;
      gamepads[index] = gamepad;
      gamepad.pulse();
      return;
    }
  }
  /// Checks the state of the controller and updates each [Gamepad.state].
  ///
  /// New button presses will not be recorded until this is called, so you should try to do
  /// so in a way that it is called periodically, either via a timer or Flutter's build function.
  void update() {
    for (final gamepad in gamepads) {
      gamepad.updateState();
    }
  }
}
