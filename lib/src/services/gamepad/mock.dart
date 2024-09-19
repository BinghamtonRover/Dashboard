import "gamepad.dart";
import "state.dart";

/// A mock gamepad for unsupported platforms.
class MockGamepad extends Gamepad {
  /// A mock gamepad for unsupported platforms.
  MockGamepad(super.controllerIndex);

  @override
  GamepadState? getState() => null;

  @override
  void vibrate({double intensity = 1}) { }

  @override
  GamepadBatteryLevel get batteryLevel => GamepadBatteryLevel.unknown;

  @override
  bool get isConnected => false;
}
