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

	/// The index of the gamepad to read from. Does not match [Gamepad.controller].
	final int gamepadIndex;

	/// Defines what the current controls are for the current mode.
	RoverControls controls;

	/// Maps button presses on [gamepad] to [controls].
	Controller(this.gamepadIndex, this.controls);

	/// The gamepad to read from.
	Gamepad get gamepad => services.gamepad.gamepads[gamepadIndex];

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

	/// Changes the current mode this [gamepad] is controlling, and chooses a new [RoverControls].
	void setMode(OperatingMode? mode) {
		if (mode == null) return;
    if (
      mode != OperatingMode.none
      && models.rover.controllers.any(
        (other) => other.gamepadIndex != gamepadIndex && other.mode == mode,
      )
    ) {
      models.home.setMessage(severity: Severity.error, text: "Another controller is set to that mode");
      return;
    }
    if (
      mode == OperatingMode.drive
      && models.rover.controllers.any(
        (other) => other.gamepadIndex != gamepadIndex && other.mode == OperatingMode.modernDrive,
      )
    ) {
      models.home.setMessage(severity: Severity.error, text: "Cannot use both tank and drive controls");
      return;
    }
    if (
      mode == OperatingMode.modernDrive
      && models.rover.controllers.any(
        (other) => other.gamepadIndex != gamepadIndex && other.mode == OperatingMode.drive,
      )
    ) {
      models.home.setMessage(severity: Severity.error, text: "Cannot use both tank and drive controls");
      return;
    }
    if (mode == OperatingMode.cameras && !models.settings.dashboard.splitCameras) {
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
		await services.gamepad.connect(gamepadIndex);
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
		services.gamepad.update();
		if (!gamepad.isConnected) return;
		controls.updateState(gamepad.state);
		final messages = controls.parseInputs(gamepad.state);
		for (final message in messages) {
      // print(message.toProto3Json());
			models.messages.sendMessage(message);
		}
	}
}
