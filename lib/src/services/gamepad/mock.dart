import "gamepad.dart";
import "state.dart";

class MockGamepad extends Gamepad {
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
