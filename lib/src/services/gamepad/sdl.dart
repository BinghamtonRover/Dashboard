import "dart:ffi";
import "package:ffi/ffi.dart";

import "package:sdl3/sdl3.dart" as sdl;

import "gamepad.dart";
import "state.dart";

class SdlGamepad extends Gamepad {
  static const sdlMaxRumble = 0xFFFF;

  final Pointer<sdl.SdlGamepad> _sdlGamepad;
  final _arena = Arena();
  late Pointer<Int32> _batteryPointer;

  SdlGamepad(super.controllerIndex) :
    _sdlGamepad = sdl.sdlGetGamepadFromPlayerIndex(controllerIndex);

  @override
  Future<void> init() async {
    sdl.sdlSetGamepadEventsEnabled(true);
    _batteryPointer = _arena<Int32>();
  }

  int _getRumbleIntensity(double intensity) =>
    (sdlMaxRumble * intensity).floor();

  @override
  void vibrate({double intensity = 1}) => _sdlGamepad.rumble(
    _getRumbleIntensity(intensity),
    _getRumbleIntensity(intensity),
    1000,
  );

  @override
  GamepadBatteryLevel get batteryLevel {
    _sdlGamepad.getPowerInfo(_batteryPointer);
    return GamepadBatteryLevel.fromPercent(_batteryPointer.value);
  }

  @override
  Future<void> dispose() async {
    _sdlGamepad.close();
    _arena.releaseAll();
  }

  @override
  bool get isConnected => _sdlGamepad.connected();

  @override
  GamepadState getState() => GamepadState(
    buttonA: _getButton(sdl.SDL_GAMEPAD_BUTTON_LABEL_A),
    buttonB: _getButton(sdl.SDL_GAMEPAD_BUTTON_LABEL_B),
    buttonX: _getButton(sdl.SDL_GAMEPAD_BUTTON_LABEL_X),
    buttonY: _getButton(sdl.SDL_GAMEPAD_BUTTON_LABEL_Y),
    buttonBack: _getButton(sdl.SDL_GAMEPAD_BUTTON_BACK),
    buttonStart: _getButton(sdl.SDL_GAMEPAD_BUTTON_START),
    normalTrigger: _normalizeJoystick(
      sdl.SDL_GAMEPAD_AXIS_RIGHT_TRIGGER,
      sdl.SDL_GAMEPAD_AXIS_LEFT_TRIGGER,
    ),
    normalDpadX: _normalizeButtons(
      sdl.SDL_GAMEPAD_BUTTON_DPAD_DOWN,
      sdl.SDL_GAMEPAD_BUTTON_DPAD_UP,
    ),
    normalDpadY: _normalizeButtons(
      sdl.SDL_GAMEPAD_BUTTON_DPAD_LEFT,
      sdl.SDL_GAMEPAD_BUTTON_DPAD_RIGHT,
    ),
    normalLeftX: _sdlGamepad.getAxis(sdl.SDL_GAMEPAD_AXIS_LEFTX).normalizeJoystick,
    normalLeftY: _sdlGamepad.getAxis(sdl.SDL_GAMEPAD_AXIS_LEFTY).normalizeJoystick,
    normalRightX: _sdlGamepad.getAxis(sdl.SDL_GAMEPAD_AXIS_RIGHTX).normalizeJoystick,
    normalRightY: _sdlGamepad.getAxis(sdl.SDL_GAMEPAD_AXIS_RIGHTY).normalizeJoystick,
    normalShoulder: _normalizeButtons(
      sdl.SDL_GAMEPAD_BUTTON_RIGHT_SHOULDER,
      sdl.SDL_GAMEPAD_BUTTON_LEFT_SHOULDER,
    ),
  );

  bool _getButton(int button) => _sdlGamepad.getButton(button) == 1;

  double _normalizeJoystick(int axis1, int axis2) => (
    _sdlGamepad.getAxis(axis1) - _sdlGamepad.getAxis(axis2)
  ).normalizeJoystick;

  double _normalizeButtons(int button1, int button2) {
    if (_getButton(button1)) {
      return -1;
    } else if (_getButton(button2)) {
      return 1;
    } else {
      return 0;
    }
  }
}

extension on int {
  /// The "deadzone" of the gamepad.
  static const epsilon = 0.01;

  /// Normalizes joystick inputs to be between -1 and 1.
  double get normalizeJoystick {
    final value = (this - 128) / 32768;
    return (value.abs() < epsilon) ? 0 : value.clamp(-1, 1);
  }
}
