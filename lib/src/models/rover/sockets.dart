import "dart:io";
import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";

/// Which rover-like system to communicate with.
/// 
/// The ports on each [SocketConfig] will remain the same, but the IP addresses may vary.
enum RoverType { 
	/// The rover itself.
	/// 
	/// The rover has multiple computers with multiple IP addresses.
	rover, 

	/// The user's own computer.
	/// 
	/// Useful when debugging and running the rover programs locally.
	localhost,

	/// The smaller rover used for autonomy.
	/// 
	/// The tank only has one computer with one static IP address (see [NetworkSettings.tankSocket]).
	tank;

	/// The human-friendly name for this [RoverType].
	String get humanName {
		switch(this) {
			case rover: return "Rover";
			case tank: return "Tank";
			case localhost: return "Local";
		}
	}
}

/// Coordinates all the sockets to point to the right [RoverType].
class Sockets extends Model {
	/// The rover-like system currently in use.
	RoverType rover = RoverType.rover;

	@override
	Future<void> init() => updateSockets();

	/// The user's network settings.
	NetworkSettings get settings => models.settings.network;

	/// Set the right IP addresses for the rover or tank.
	Future<void> updateSockets() async {
		services.dataSocket.destination = settings.subsystemsSocket.copy();
		services.videoSocket.destination = settings.videoSocket.copy();
		services.autonomySocket.destination = settings.autonomySocket.copy();
		services.marsSocket.destination = settings.marsSocket.copy();

		switch (rover) {
			case RoverType.rover: break;  // IPs are already in the settings
			case RoverType.tank: 
				final tankAddress = settings.tankSocket.address;
				// [!] The destinations are set in this function.
				services.dataSocket.destination!.address = tankAddress;
				services.videoSocket.destination!.address = tankAddress;
				services.autonomySocket.destination!.address = tankAddress;
				services.marsSocket.destination!.address = tankAddress;
				break;
			case RoverType.localhost: 
				final localAddress = InternetAddress.loopbackIPv4;
				// [!] The destinations are set in this function.
				services.dataSocket.destination!.address = localAddress;
				services.videoSocket.destination!.address = localAddress;
				services.autonomySocket.destination!.address = localAddress;				
				services.marsSocket.destination!.address = localAddress;				
				break;
		}
		await reset();
	}

	/// Resets all the sockets.
	/// 
	/// When working with localhost, even UDP sockets can throw errors when the remote is unreachable.
	/// Resetting the sockets will bypass these errors.
	Future<void> reset() async {
		await services.dataSocket.reset();
		await services.videoSocket.reset();
		await services.autonomySocket.reset();
		models.rover.heartbeats.reset();
	}

	/// Change which rover is being used.
	Future<void> setRover(RoverType? value) async {
		if (value == null) return;
		rover = value;
		models.home.setMessage(severity: Severity.info, text: "Using: ${rover.name}");
		await updateSockets();
		notifyListeners();
	}
}
