import "gamepad.dart";
import "state.dart";

class MockGamepad extends Gamepad {
  MockGamepad(super.controllerIndex);

  GamepadState? getState() => null;
  void vibrate({double intensity = 1}) { }
  GamepadBatteryLevel get batteryLevel => GamepadBatteryLevel.unknown;
  bool get isConnected => false;
}
