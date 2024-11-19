import "package:flutter_sdl_gamepad/flutter_sdl_gamepad.dart" as sdl;

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
    <= 100 => full,
    _ => unknown,
  };
}

/// The complete state of a gamepad.
///
/// Acts as a wrapper around [sdl.GamepadState] to allow backwards compatibility with older
/// rover gamepad APIs
typedef GamepadState = sdl.GamepadState;

/// An extension on [GamepadState] to allow for backwards compatibility with
/// the rover joystick direction system
extension RoverGamepadState on GamepadState {
  /// A normalized reading of the left joystick's X-axis.
  double get normalLeftX => normalLeftJoystickX;

  /// A normalized reading of the left joystick's Y-axis.
  double get normalLeftY => -normalLeftJoystickY;

  /// A normalized reading of the right joystick's X-axis.
  double get normalRightX => normalRightJoystickX;

  /// A normalized reading of the right joystick's Y-axis.
  double get normalRightY => -normalRightJoystickY;

  /// A normalized reading of the shoulder buttons.
  double get normalShoulder => normalShoulders.toDouble();
}
