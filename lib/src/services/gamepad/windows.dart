import "gamepad.dart";
import "state.dart";
import "package:win32_gamepad/win32_gamepad.dart" as win32;

/// A Windows implementation of gamepads, using [`package:win32_gamepad`](https://pub.dev/packages/win32_gamepad).
class Win32Gamepad extends Gamepad {
  final win32.Gamepad _winGamepad;

  /// Links to a gamepad at the given index using Win32 APIs.
  Win32Gamepad(super.controllerIndex) :
    _winGamepad = win32.Gamepad(controllerIndex);

  @override
  Future<void> init() async { }

  @override
  Future<void> dispose() async { }

  @override
  void vibrate({double intensity = 1}) {
    final win32Intensity = (intensity * 65000).floor();
    _winGamepad.vibrate(leftMotorSpeed: win32Intensity, rightMotorSpeed: win32Intensity);
  }

  @override
  GamepadState? getState() {
    if (!isConnected) return null;
    _winGamepad.updateState();
    return _winGamepad.state.normalize();
  }

  @override
  GamepadBatteryLevel get batteryLevel => switch (_winGamepad.gamepadBatteryInfo.batteryLevel) {
    win32.GamepadBatteryLevel.empty => GamepadBatteryLevel.low,
    win32.GamepadBatteryLevel.full => GamepadBatteryLevel.full,
    win32.GamepadBatteryLevel.low => GamepadBatteryLevel.low,
    win32.GamepadBatteryLevel.medium => GamepadBatteryLevel.medium,
    win32.GamepadBatteryLevel.unknown => GamepadBatteryLevel.unknown,
  };

  @override
  bool get isConnected => _winGamepad.isConnected;
}

extension on num {
  /// The "deadzone" of the gamepad.
  static const epsilon = 0.01;

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

extension on (bool, bool) {
  double get normalize {
    if ($1) return -1;
    if ($2) return 1;
    return 0;
  }
}

extension on win32.GamepadState {
  GamepadState normalize() => GamepadState(
    buttonA: buttonA,
    buttonB: buttonB,
    buttonX: buttonX,
    buttonY: buttonY,
    buttonBack: buttonBack,
    buttonStart: buttonStart,
    normalTrigger: (rightTrigger - leftTrigger).normalizeTrigger,
    normalShoulder: (leftShoulder, rightShoulder).normalize,
    normalLeftX: leftThumbstickX.normalizeJoystick,
    normalLeftY: leftThumbstickY.normalizeJoystick,
    normalRightX: rightThumbstickX.normalizeJoystick,
    normalRightY: rightThumbstickY.normalizeJoystick,
    normalDpadX: (dpadLeft, dpadRight).normalize,
    normalDpadY: (dpadDown, dpadUp).normalize,
  );
}
