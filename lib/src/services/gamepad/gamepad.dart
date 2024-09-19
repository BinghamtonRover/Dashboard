import "dart:io";

import "mock.dart";
import "state.dart";
import "windows.dart";

abstract class Gamepad {
  factory Gamepad.forPlatform(int index) => Platform.isWindows
    ? Win32Gamepad(index)
    : MockGamepad(index);

  final int controllerIndex;
  Gamepad(this.controllerIndex);

  void vibrate({double intensity = 1});
  GamepadState? getState();
  bool get isConnected;
  GamepadBatteryLevel get batteryLevel;

  void stopVibrating() => vibrate(intensity: 0);

  /// Makes the gamepad vibrate a small "pulse"
  // ignore: avoid_void_async -- meant to be ignored
  void pulse() async {
    if (!isConnected) return;
    vibrate();
    await Future<void>.delayed(const Duration(milliseconds: 200));
    stopVibrating();
    await Future<void>.delayed(const Duration(milliseconds: 100));
    vibrate();
    await Future<void>.delayed(const Duration(milliseconds: 200));
    stopVibrating();
  }
}
