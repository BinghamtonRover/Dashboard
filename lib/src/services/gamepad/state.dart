/// The battery level of a gamepad.
enum GamepadBatteryLevel {
  /// The battery is running low.
  low,

  /// The battery is at medium charge.
  medium,

  /// The battery is fully charged.
  full,

  /// The battery's charge is unknown.
  ///
  /// Either the device does not support battery readings, or the device
  /// may be disconnected.
  unknown;

  /// Returns a battery level from a percentage.
  static GamepadBatteryLevel fromPercent(int percentage) => switch (percentage) {
    < 33 => low,
    < 66 => medium,
    < 100 => full,
    _ => unknown,
  };
}

/// The complete state of a gamepad.
///
/// A "normal" value means a value that is linked to two buttons. For example, both triggers
/// contribute to the [normalTrigger] value, so if the left was pressed less than the right,
/// the "normalized" result would be a small positive value. In general, the normal values range
/// from -1.0 to +1.0, inclusive, with -1 meaning all the way to one side, +1 to the other, and
/// 0 indicates that neither button is pressed.
///
/// For digital buttons, a normalized value will only ever be -1, 0, or +1. For analog inputs,
/// including pressure-sensitive triggers, the value will be in the range [-1.0, +1.0].
class GamepadState {
  /// Whether the A button was pressed.
  final bool buttonA;

  /// Whether the B button was pressed.
  final bool buttonB;

  /// Whether the X button was pressed.
  final bool buttonX;

  /// Whether the Y button was pressed.
  final bool buttonY;

  /// Whether the Back or Select button was pressed.
  final bool buttonBack;

  /// Whether the Start or Options button was pressed.
  final bool buttonStart;

  /// A normalized reading of the triggers.
  final double normalTrigger;

  /// A normalized reading of the shoulder buttons.
  final double normalShoulder;

  /// A normalized reading of the left joystick's X-axis.
  final double normalLeftX;

  /// A normalized reading of the left joystick's Y-axis.
  final double normalLeftY;

  /// A normalized reading of the right joystick's X-axis.
  final double normalRightX;

  /// A normalized reading of the right joystick's X-axis.
  final double normalRightY;

  /// A normalized reading of the D-pad's X-axis.
  final double normalDpadX;

  /// A normalized reading of the D-pad's X-axis.
  final double normalDpadY;

  /// Creates a new representation of the gamepad state.
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

  /// Whether the left shoulder is being pressed.
  bool get leftShoulder => normalShoulder < 0;

  /// Whether the right shoulder is being pressed.
  bool get rightShoulder => normalShoulder > 0;

  /// Whether the D-pad's down button is being pressed.
  bool get dpadDown => normalDpadY < 0;

  /// Whether the D-pad's up button is being pressed.
  bool get dpadUp => normalDpadY > 0;
}
