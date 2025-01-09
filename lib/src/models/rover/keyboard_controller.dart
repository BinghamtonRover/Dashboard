import "dart:async";

import "package:flutter/services.dart";
import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// A model that sends [DriveCommand]s based on keyboard inputs.
///
/// This model cannot be refactored to use the standard Flutter keyboard shortcuts API since it
/// depends on detecting [KeyUpEvent]s, which are not dispatched as shortcut events.
///
/// This class enables basic WASD control and up/down arrows for throttle.
class KeyboardController extends Model {
  static const _readInterval = Duration(milliseconds: 100);
  static const _driveModes = {OperatingMode.drive, OperatingMode.modernDrive};

  Timer? _inputTimer;

  /// Whether the user is able to use these controls
  bool get _isEnabled => _inputTimer != null;

  bool get _shouldEnable => models.settings.dashboard.enableKeyboardShortcuts;

  @override
  Future<void> init() async {
    if (models.settings.dashboard.enableKeyboardShortcuts) _startListening();
    models.settings.addListener(_onUpdateSettings);
    models.rover.controllerModes.addListener(_onControlsUpdated);
    _onControlsUpdated();  // handle the on launch case
  }

  /// Whether any controller has control of the drive. Controllers take priority.
  bool get _controllerHasDrive => models.rover.controllers
    .any((controller) => controller.isConnected && _driveModes.contains(controller.mode));

  void _onControlsUpdated() {
    if (_isEnabled && _controllerHasDrive) {
      _stopListening();
    } else if (_shouldEnable && !_isEnabled && !_controllerHasDrive) {
      _startListening();
    }
  }

  void _onUpdateSettings() {
    if (_shouldEnable && !_isEnabled) {
      _startListening();
    } else if (!_shouldEnable && _isEnabled) {
      _stopListening();
    }
  }

  void _startListening() {
    HardwareKeyboard.instance.addHandler(_handleKeyboardEvents);
    _inputTimer = Timer.periodic(_readInterval, _sendCommands);
    notifyListeners();
  }

  void _stopListening() {
    HardwareKeyboard.instance.removeHandler(_handleKeyboardEvents);
    _inputTimer?.cancel();
    _inputTimer = null;
    notifyListeners();
  }

  bool _handleKeyboardEvents(KeyEvent event) {
    final isReleased = event is KeyUpEvent;
    switch (event.logicalKey) {  // speed and direction
      case LogicalKeyboardKey.keyA: _direction = isReleased ? 0 :  0.5;
      case LogicalKeyboardKey.keyD: _direction = isReleased ? 0 : -0.5;
      case LogicalKeyboardKey.keyW: _speed = isReleased ? 0 :  0.5;
      case LogicalKeyboardKey.keyS: _speed = isReleased ? 0 : -0.5;
      case LogicalKeyboardKey.arrowUp:
        if (isReleased) break;
        _throttle = (_throttle + 0.1).clamp(0, 1);
      case LogicalKeyboardKey.arrowDown:
        if (isReleased) break;
        _throttle = (_throttle - 0.1).clamp(0, 1);
    }
    return true;
  }

  void _sendCommands(_) {
    final (left, right) = ModernDriveControls.getWheelSpeeds(_speed, _direction * 20);
    models.messages.sendMessage(DriveCommand(setLeft: true, left: left));
    models.messages.sendMessage(DriveCommand(setRight: true, right: right));
    models.messages.sendMessage(DriveCommand(setThrottle: true, throttle: _throttle));
  }

  double _speed = 0;
  double _direction = 0;
  double _throttle = 0;

  /// A description of which buttons are mapped to which functions.
  Map<String, String> get buttonMapping => {
    if (_isEnabled) ...{
      "Drive": "WASD",
      "Change throttle": "Arrow keys",
    },
    "Reset the network": "N",
    "Toggle localhost mode": "L",
    "Toggle tank mode": "T",
    "Stop immediately": "Space",
  };
}
