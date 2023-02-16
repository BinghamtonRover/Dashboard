import "dart:async";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";

import "../model.dart";
import "drive.dart";
import "stub.dart";

export "package:rover_dashboard/data.dart";
export "package:rover_dashboard/services.dart";

const gamepadDelay = Duration(milliseconds: 100);

abstract class Controller extends Model {
	late final Timer gamepadTimer;

	Controller();

	factory Controller.forMode(OperatingMode mode) {
		switch (mode) {
			case OperatingMode.arm: return Stub();
			case OperatingMode.science: return Stub();
			case OperatingMode.autonomy: return Stub();
			case OperatingMode.drive: return DriveController();
		}
	}

	@override
	Future<void> init() async { 
		if (!models.rover.isConnected) {
			models.home.setMessage(severity: Severity.warning, text: "Rover is not connected");
		}
		gamepadTimer = Timer.periodic(gamepadDelay, update);
	}

	@override
	void dispose() {
		gamepadTimer.cancel();
		super.dispose();
	}

	Iterable<Message> parseInputs(GamepadState state);

	void update([_]) {
		services.gamepad.update();
		final messages = parseInputs(services.gamepad.state);
		messages.forEach(sendMessage);
	}

	Future<void> sendMessage(Message message) async {
		if (models.serial.isConnected) {
			await services.serial.sendMessage(message);
		} else {
			services.messageSender.sendMessage(message);
		}
	}
}
