import "dart:async";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";

import "arm.dart";
import "drive.dart";
import "science.dart";
import "stub.dart";

export "package:rover_dashboard/data.dart";
export "package:rover_dashboard/services.dart";

/// How often to check the gamepad for new button presses.
const gamepadDelay = Duration(milliseconds: 10);

/// An abstract class for controlling one subsystem of the rover.
/// 
/// Once every [gamepadDelay], the [gamepadTimer] will trigger, which [_update]s the gamepad and
/// call [parseInputs] to see what actions can be done. Each command is then sent, one at a time,
/// through [sendMessage], which will either send them over the network or via USB ([SerialModel]).
/// 
/// To use this class, subclass it and implement [parseInputs]. Be sure to add your class to the
/// [Controller.forMode] constructor so it can be used within the UI.
abstract class Controller extends Model {
	/// Reads the gamepad and controls the rover when triggered.
	late final Timer gamepadTimer;

	/// Whether the start button has been pressed.
	/// 
	/// When the start button is released, the dashboard will switch to the next mode.
	bool isStartPressed = false;

	/// Allows this class to be subclassed.
	Controller();

	/// Constructs the appropriate [Controller] for each mode.
	factory Controller.forMode(OperatingMode mode) {
		switch (mode) {
			case OperatingMode.arm: return ArmController();
			case OperatingMode.science: return ScienceController();
			case OperatingMode.autonomy: return StubController();
			case OperatingMode.drive: return DriveController();
		}
	}

	@override
	Future<void> init() async { 
		if (!models.rover.isConnected) {
			models.home.setMessage(severity: Severity.warning, text: "Rover is not connected");
		}
		gamepadTimer = Timer.periodic(gamepadDelay, _update);
	}

	@override
	void dispose() {
		gamepadTimer.cancel();
		onDispose.forEach(sendMessage);
		super.dispose();
	}

	/// Return a list of commands based on the current state of the gamepad.
	Iterable<Message> parseInputs(GamepadState state);

	/// A list of commands to send when switching modes.
	/// 
	/// Use this to stop the rover when the user switches modes.
	Iterable<Message> get onDispose;

	/// A human-readable list of controls.
	Map<String, String> get controls;

	/// Sends a command over the network or over Serial.
	Future<void> sendMessage(Message message) async {
		if (models.serial.isConnected) {
			await services.serial.sendMessage(message);
		} else {
			services.messageSender.sendMessage(message);
		}
	}

	/// Reads the gamepad, chooses commands, and sends them to the rover.
	Future<void> _update([_]) async {
		services.gamepad.update();
		if (services.gamepad.state.buttonStart) {
			isStartPressed = true;
		} else if (isStartPressed) {
			models.home.nextMode();
		} 
		final messages = parseInputs(services.gamepad.state);
		messages.forEach(sendMessage);
	}
}
