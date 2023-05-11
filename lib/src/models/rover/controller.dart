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
/// via [sendMessage], which will either send them over the network or via USB ([SerialModel]).
class Controller extends Model {
	/// Reads the gamepad and controls the rover when triggered.
	late final Timer gamepadTimer;

	/// The index of the gamepad to read from. Does not match [Gamepad.controller].
	final int gamepadIndex;

	/// Defines what the current controls are for the current mode.
	RoverControls controls;

	/// Map to figure out what device is connected
	/// 
	/// Used to send data to the correct teensy
	/// <Command, Teensy>
	Map<String, Device> teensyCommands = {
		"ArmCommand": Device.ARM,
		"GripperCommand": Device.GRIPPER,
		"ScienceCommand": Device.SCIENCE,
		"ElecticalCommand": Device.ELECTRICAL,
		"DriveCommand": Device.DRIVE,
		"MarsCommand": Device.MARS,
		"FirmwareCommand": Device.FIRMWARE
	};

	/// Maps button presses on [gamepad] to [controls].
	Controller(this.gamepadIndex, this.controls) {
		models.settings.addListener(notifyListeners);
	}

	/// The gamepad to read from.
	Gamepad get gamepad => services.gamepad.gamepads[gamepadIndex];

	@override
	Future<void> init() async {
		gamepadTimer = Timer.periodic(gamepadDelay, _update);
	}

	@override
	void dispose() {
		gamepadTimer.cancel();
		models.settings.removeListener(notifyListeners);
		controls.onDispose.forEach(sendMessage);
		super.dispose();
	}

	/// The current operating mode.
	OperatingMode get mode => controls.mode;

	/// Whether this controller is ready to use.
	bool get isConnected => gamepad.isConnected;

	/// Changes the current mode this [gamepad] is controlling, and chooses a new [RoverControls].
	void setMode(OperatingMode? mode) {
		if (mode == null) return;
		controls.onDispose.forEach(sendMessage);
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

	/// Sends a command over the network or over Serial.
	Future<void> sendMessage(Message message) async {
		if (models.serial.isConnected && (services.serial.connectedDevice == teensyCommands[message.messageName])) {
			await services.serial.sendMessage(message);
		} else {
			services.dataSocket.sendMessage(message);
		}
	}

	/// Reads the gamepad, chooses commands, and sends them to the rover.
	Future<void> _update([_]) async {
		services.gamepad.update();
		if (!gamepad.isConnected) return;
		controls.updateState(gamepad.state);
		final messages = controls.parseInputs(gamepad.state);
		for (final message in messages) {
			if (message != null) await sendMessage(message);
		}
	}
}
