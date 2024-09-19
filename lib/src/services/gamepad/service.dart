import "../service.dart";
import "gamepad.dart";

class GamepadService extends Service {
  static const maxGamepads = 3;

  List<Gamepad> gamepads = [
    for (var i = 0; i < maxGamepads; i++)
      Gamepad.forPlatform(i),
  ];

  Set<int> get usedIndexes => {
    for (final gamepad in gamepads)
      if (gamepad.isConnected)
        gamepad.controllerIndex,
  };

  @override
  Future<void> init() async {
    for (var i = 0; i < maxGamepads; i++) {
      connect(i);
    }
  }

  void connect(int index) {
    for (var i = 0; i < maxGamepads; i++) {
      if (usedIndexes.contains(i)) continue;
      final gamepad = Gamepad.forPlatform(i);
      if (!gamepad.isConnected) continue;
      gamepads[i] = gamepad;
      gamepad.pulse();
      return;
    }
  }

  @override
  Future<void> dispose() async { }
}
