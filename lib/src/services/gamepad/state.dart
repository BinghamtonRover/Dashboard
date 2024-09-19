enum GamepadBatteryLevel {
  empty, low, medium, full, unknown,
}

class GamepadState {
  final bool buttonA;
  final bool buttonB;
  final bool buttonX;
  final bool buttonY;

  final bool buttonBack;
  final bool buttonStart;

  final double normalTrigger;
  final double normalShoulder;

  final double normalLeftX;
  final double normalLeftY;

  final double normalRightX;
  final double normalRightY;

  final double normalDpadX;
  final double normalDpadY;

  const GamepadState({
    required this.buttonA,
    required this.buttonB,
    required this.buttonX,
    required this.buttonY,

    required this.buttonBack,
    required this.buttonStart,

    required this.normalTrigger,
    required this.normalShoulder,

    required this.normalLeftX,
    required this.normalLeftY,

    required this.normalRightX,
    required this.normalRightY,

    required this.normalDpadX,
    required this.normalDpadY,
  });

  bool get leftShoulder => normalShoulder < 0;
  bool get rightShoulder => normalShoulder > 0;
  bool get dpadDown => normalDpadY < 0;
  bool get dpadUp => normalDpadY > 0;
}
