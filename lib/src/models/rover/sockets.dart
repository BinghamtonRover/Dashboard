import "dart:io";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";

/// Which rover-like system to communicate with.
enum RoverType { 
	/// The rover itself.
	/// 
	/// The rover has multiple computers with multiple IP addresses.
	rover, 

	/// The smaller rover used for autonomy.
	/// 
	/// The tank only has one computer with one static IP address (see [Settings.tankAddress]).
	tank
}

/// Coordinates all the sockets to point to the right [RoverType].
class Sockets extends Model {
	/// The rover-like system currently in use.
	RoverType rover = RoverType.rover;

	late final Settings settings;

	@override
	Future<void> init() async {
		settings = await services.files.readSettings();
		await updateSockets();
	}

	/// Set the right IP addresses for the rover or tank.
	Future<void> updateSockets() async {
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

	/// Change which rover is being used.
	Future<void> setRover(RoverType value) async {
		rover = value;
		models.home.setMessage(severity: Severity.info, text: "Using: ${rover.name}");
		await updateSockets();
		notifyListeners();
	}
}
