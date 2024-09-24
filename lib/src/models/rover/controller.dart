import "dart:async";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";

/// Uses the gamepad to control the rover.
///
/// Each gamepad can only control one subsystem at a time, so this class uses [controls] to
/// keep track of what each button does in the current [OperatingMode].
///
/// Once every [gamepadDelay], the [gamepadTimer] will trigger, which [_update]s the gamepad and
/// call [RoverControls.parseInputs] to see what actions can be done. Each command is then sent
/// with [MessagesModel.sendMessage], which will either send them over the network or via serial.
class Controller extends Model {
  /// Reads the gamepad and controls the rover when triggered.
  late final Timer gamepadTimer;

  /// The index of the gamepad to read from. Does not match [Gamepad.controllerIndex].
  final int index;

  /// Defines what the current controls are for the current mode.
  RoverControls controls;

  /// Maps button presses on [gamepad] to [controls].
  Controller(this.index, this.controls);

  /// The gamepad to read from.
  Gamepad get gamepad => services.gamepad.gamepads[index];

  @override
  Future<void> init() async {
    gamepadTimer = Timer.periodic(gamepadDelay, _update);
    models.settings.addListener(notifyListeners);
  }

  @override
  void dispose() {
    gamepadTimer.cancel();
    models.settings.removeListener(notifyListeners);
    controls.onDispose.forEach(models.messages.sendMessage);
    super.dispose();
  }

  /// The current operating mode.
  OperatingMode get mode => controls.mode;

  /// Whether this controller is ready to use.
  bool get isConnected => gamepad.isConnected;

  /// Returns Whether another controller is set to the given mode.
  bool otherControllerIs(OperatingMode mode) => models.rover.controllers
    .any((other) => other.index != index && other.mode == mode);

  /// Changes the current mode this [gamepad] is controlling, and chooses a new [RoverControls].
  void setMode(OperatingMode? mode) {
    if (mode == null) return;
    if (mode != OperatingMode.none && otherControllerIs(mode)) {
      models.home.setMessage(severity: Severity.error, text: "Another controller is set to that mode");
      return;
    } else if (mode == OperatingMode.drive && otherControllerIs(OperatingMode.modernDrive)) {
      models.home.setMessage(severity: Severity.error, text: "Cannot use both tank and drive controls");
      return;
    } else if (mode == OperatingMode.modernDrive && otherControllerIs(OperatingMode.drive)) {
      models.home.setMessage(severity: Severity.error, text: "Cannot use both tank and drive controls");
      return;
    } else if (mode == OperatingMode.cameras && !models.settings.dashboard.splitCameras) {
      models.home.setMessage(severity: Severity.error, text: "Enable split camera controls in the settings");
      return;
    }
    controls.onDispose.forEach(models.messages.sendMessage);
    controls = RoverControls.forMode(mode);
    gamepad.pulse();
    notifyListeners();
  }

  /// Connects the [gamepad] to the user's device.
  Future<void> connect() async {
    await services.gamepad.connect(index);
    if (gamepad.isConnected) {
      models.home.setMessage(severity: Severity.info, text: "Connected to gamepad");
    } else {
      models.home.setMessage(severity: Severity.error, text: "No gamepad connected");
    }
    notifyListeners();
  }

  /// Same as [setMode], but uses [OperatingMode.index] instead.
  void setModeIndex(int index) => setMode(OperatingMode.values[index]);

  /// Reads the gamepad, chooses commands, and sends them to the rover.
  Future<void> _update([_]) async {
    final state = gamepad.getState();
    if (state == null) return;
    controls.updateState(state);
    final messages = controls.parseInputs(state);
    for (final message in messages) {
      models.messages.sendMessage(message);
    }
  }
}
