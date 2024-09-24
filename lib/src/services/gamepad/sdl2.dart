import "package:sdl_gamepad/sdl_gamepad.dart" as sdl;

import "state.dart";
import "gamepad.dart";

class DashboardSdlGamepad extends Gamepad {
  static final lib = sdl.SdlLibrary();
  final sdl.SdlGamepad _sdl;

  DashboardSdlGamepad(super.controllerIndex) :
    _sdl = sdl.SdlGamepad.fromGamepadIndex(controllerIndex);

  @override
  void vibrate({double intensity = 1}) =>
    _sdl.rumble(intensity: intensity, duration: const Duration(seconds: 1));

  @override
  GamepadBatteryLevel get batteryLevel {
    final percentage = _sdl.battery;
    print(percentage);
    if (percentage == null) return GamepadBatteryLevel.full;
    return GamepadBatteryLevel.fromPercent(percentage);
  }

  @override
  Future<void> init() async {
    final result = lib.init();
    print("  device id: ${_sdl.sdlGamepad}");
    if (!isConnected) return;
    print("  Device types: ${_sdl.getInfo().name}");
    print("  Device types: ${_sdl.getInfo().path}");
    print("  Device types: ${_sdl.getInfo().vendor}");
    // print("Init lib? $result");
  }

  @override
  Future<void> dispose() async => _sdl.close();

  @override
  bool get isConnected => _sdl.isConnected;

  @override
  GamepadState getState() {
    final state = _sdl.getState();
    // print(state.leftJoystickX);
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
      normalLeftY: state.normalLeftJoystickY,
      normalRightX: state.normalRightJoystickX,
      normalRightY: state.normalRightJoystickY,
      normalShoulder: state.normalShoulders.toDouble(),
      normalTrigger: state.normalTriggers,
    );
  }
}
