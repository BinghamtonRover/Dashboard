import "dart:io";

import "mock.dart";
import "state.dart";
import "sdl.dart";

import "../service.dart";

/// A physical gamepad that can be connected and used to control the rover.
///
/// To interact with a gamepad, create an instance of this class. This class is completely safe to
/// use even if the gamepad in question is not connected or suddenly disconnects. Check
/// [isConnected] if you need to know the current state of the gamepad.
///
/// Use [Gamepad.forPlatform] to get the right implementation for the current platform.
abstract class Gamepad extends Service {
  /// The unique number assigned to this controller by the operating system.
  final int controllerIndex;

  /// Creates a new gamepad object, whether it is connected or not.
  Gamepad(this.controllerIndex);

  /// Returns a functional instance of this class, or a mock on unsupported platforms.
  factory Gamepad.forPlatform(int index) => Platform.isWindows
    ? DesktopGamepad(index)
    : MockGamepad(index);

  /// Gets the current state of the gamepad, or null if it's not connected.
  GamepadState? getState();

  /// Whether the gamepad is currently connected.
  ///
  /// The gamepad can suddenly disconnect at any time, and does not have to be connected to start.
  ///
  /// Note that some gamepads with wireless receivers will show up as connected when the *receiver* is
  /// plugged in, even if the gamepad itself is turned off. This is a fundamental limitation.
  bool get isConnected;

  /// The current battery of the controller, or [GamepadBatteryLevel.unknown] if disconnected.
  GamepadBatteryLevel get batteryLevel;

  /// Vibrates the gamepad at the given intensity, from a scale of 0.0 to 1.0.
  ///
  /// The vibration may not stop until you call [stopVibrating].
  void vibrate({double intensity = 1});

  /// Stops vibrating the controller.
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
