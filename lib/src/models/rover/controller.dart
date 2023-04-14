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

	/// The gamepad to read from. Multiple gamepads may be connected.
	final Gamepad gamepad;

	/// Defines what the current controls are for the current mode.
	RoverControls controls;

	/// Whether the start button has been pressed.
	///
	/// When the start button is released, the dashboard will switch to the next mode.

	bool isStartPressed = false;

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
	Controller(this.gamepad, this.controls);

	@override
	Future<void> init() async {
		gamepadTimer = Timer.periodic(gamepadDelay, _update);
	}

	@override
	void dispose() {
		gamepadTimer.cancel();
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

	/// Same as [setMode], but uses [OperatingMode.index] instead.
	void setModeIndex(int index) => setMode(OperatingMode.values[index]);

	/// Sends a command over the network or over Serial.
	Future<void> sendMessage(Message message) async {
		if(models.serial.isConnected && (services.serial.connectedDevice == teensyCommands[message.messageName])){
			await services.serial.sendMessage(message);
		} else {
			services.dataSocket.sendMessage(message);
		}
	}

	/// Reads the gamepad, chooses commands, and sends them to the rover.
	Future<void> _update([_]) async {
		services.gamepad.update();
		if (gamepad.state.buttonStart) {
			isStartPressed = true;
		} else if (isStartPressed) {
			// switch to the next mode
			int index = controls.mode.index + 1;
			if (index == OperatingMode.values.length) index = 0;
			setModeIndex(index);
		}
		final messages = controls.parseInputs(gamepad.state);
		messages.forEach(sendMessage);
	}
}
