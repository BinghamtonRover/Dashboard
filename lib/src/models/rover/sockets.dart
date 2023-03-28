import "dart:io";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";

enum RoverType { rover, tank }

class Sockets extends Model {
	RoverType rover = RoverType.rover;

	@override
	Future<void> init() async {
		await updateSockets();
	}

	/// Set the right IP addresses for the rover or tank.
	Future<void> updateSockets() async {
		final settings = await services.files.readSettings();
		services.dataSocket.destination = settings.subsystemsSocket;
		services.videoSocket.destination = settings.videoSocket;
		services.autonomySocket.destination = settings.autonomySocket;

		if (rover == RoverType.tank) {
			final tankAddress = InternetAddress(settings.tankAddress);
			services.dataSocket.destination.address = tankAddress;
			services.videoSocket.destination.address = tankAddress;
			services.autonomySocket.destination.address = tankAddress;
		}
	}

	void updateRover(RoverType rover) {
		models.home.setMessage(severity: Severity.info, text: "Using rover: ${rover.name}");
		notifyListeners();
	}
}
