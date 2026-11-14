import "dart:io";
import "package:flutter/foundation.dart";
import "package:flutter_sdl_gamepad/flutter_sdl_gamepad.dart" as sdl;
import "package:sdl3/sdl3.dart" show SdlDynamicLibraryService;

import "state.dart";
import "gamepad.dart";

/// Whether `package:sdl_gamepad` has been tested on this platform.
bool get isSdlSupported => Platform.isWindows || Platform.isLinux || Platform.isMacOS;

/// Whether SDL3 was loaded, which real gamepads cannot be read without.
bool isSdlLoaded = false;

/// The key `package:sdl3` uses to look up the core SDL library.
///
/// See `entries` in `package:sdl3/src/dylib.dart`.
const _sdlKey = "sdl";

/// Points `package:sdl3` at the SDL3 library that ships with this build.
///
/// `flutter_sdl_gamepad` embeds `SDL3.framework` in the macOS app bundle, but
/// `package:sdl3` tries to load a bare `libSDL3.dylib`, which the macOS dynamic
/// linker cannot find inside a bundle. The plugin sets the path from
/// `SDLGAMEPAD_PATH` under the key `SDL3`, which `package:sdl3` no longer reads,
/// so set it under [_sdlKey] before SDL is opened.
void registerSdlPath() {
  if (!Platform.isMacOS) return;
  final frameworks = [
    File(Platform.resolvedExecutable).parent.path,
    "..",
    "Frameworks",
  ].join(Platform.pathSeparator);
  final candidates = [
    Platform.environment["SDLGAMEPAD_PATH"],
    "$frameworks/SDL3.framework/Versions/A/SDL3",
    "$frameworks/SDL3.framework/SDL3",
    "/Library/Frameworks/SDL3.framework/SDL3",
    "/opt/homebrew/lib/libSDL3.dylib",
    "/usr/local/lib/libSDL3.dylib",
  ];
  for (final path in candidates) {
    if (path == null || !File(path).existsSync()) continue;
    SdlDynamicLibraryService().set(_sdlKey, path);
    return;
  }
}

/// Initializes the SDL libraries, returning whether they could be loaded.
///
/// Loading fails when SDL3 cannot be found, which throws instead of returning
/// false, so a missing library is reported and treated as "no gamepads" rather
/// than taking down the whole app.
bool initSdl() {
  if (!isSdlSupported) return false;
  registerSdlPath();
  try {
    isSdlLoaded = sdl.SdlLibrary.init();
  } catch (error) {
    // `package:sdl3` throws an ArgumentError, which is an [Error] rather than
    // an [Exception], when the library cannot be loaded.
    debugPrint("Could not load SDL3, so gamepads are unavailable: $error");
    isSdlLoaded = false;
  }
  return isSdlLoaded;
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
