import "package:flutter_sdl_gamepad/flutter_sdl_gamepad.dart" as sdl;

import "state.dart";
import "gamepad.dart";

/// A cross-platform implementation based on the `sdl_gamepad` package.
class DesktopGamepad extends Gamepad {
  final sdl.SdlGamepad _sdl;

  /// A constructor to open a gamepad from the given controller index.
  DesktopGamepad(super.controllerIndex) :
    _sdl = sdl.SdlGamepad.fromGamepadIndex(controllerIndex);

  @override
  void vibrate({double intensity = 1}) =>
    _sdl.rumble(intensity: intensity, duration: const Duration(seconds: 1));

  @override
  GamepadBatteryLevel get batteryLevel {
    final percentage = _sdl.battery;
    if (percentage == null) return GamepadBatteryLevel.full;
    return GamepadBatteryLevel.fromPercent(percentage);
  }

  @override
  Future<void> init() async { }

  @override
  Future<void> dispose() async => _sdl.close();

  @override
  bool get isConnected => _sdl.isConnected;

  @override
  GamepadState getState() {
    final state = _sdl.getState();
    return GamepadState(
      buttonA: state.buttonA,
      buttonB: state.buttonB,
      buttonX: state.buttonX,
      buttonY: state.buttonY,
      buttonBack: state.buttonBack,
      buttonStart: state.buttonStart,
      normalDpadX: state.normalDpadX.toDouble(),
      normalDpadY: state.normalDpadY.toDouble(),
      normalLeftX: state.normalLeftJoystickX,
      // These Y values are flipped because sdl_gamepad follows the standard convention,
      // where positive means the joystick is moving towards the user (down).
      normalLeftY: -state.normalLeftJoystickY,
      normalRightX: state.normalRightJoystickX,
      normalRightY: -state.normalRightJoystickY,
      normalShoulder: state.normalShoulders.toDouble(),
      normalTrigger: state.normalTriggers,
    );
  }
}
