import "dart:io";
import "package:flutter_sdl_gamepad/flutter_sdl_gamepad.dart" as sdl;

import "state.dart";
import "gamepad.dart";

/// Whether `package:sdl_gamepad` has been tested on this platform.
bool get isSdlSupported => Platform.isWindows || Platform.isLinux;

/// Initializes the SDL libraries.
void initSdl() {
  if (!isSdlSupported) return;
  if (!sdl.SdlLibrary.init()) {
    throw StateError("Could not initialize SDL libraries");
  }
}

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
  GamepadState getState() => _sdl.getState();
}
