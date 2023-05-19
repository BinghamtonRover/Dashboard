import "dart:async";
import "dart:io";
import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";

/// Coordinates all the sockets to point to the right [RoverType].
class Sockets extends Model {
	/// A timer that sends handshakes to every device on the rover.
	Timer? handshakeTimer;

	/// A UDP socket for sending and receiving Protobuf data.
	final data = ProtoSocket(device: Device.SUBSYSTEMS);

	/// A UDP socket for receiving video.
	final video = ProtoSocket(device: Device.VIDEO);

	/// A UDP socket for controlling autonomy.
	final autonomy = ProtoSocket(device: Device.AUTONOMY);

  /// A UDP socket for controlling rover position
  final mars = ProtoSocket(device: Device.MARS_SERVER);

  /// A list of all the sockets this model manages.
  late final List<ProtoSocket> sockets = [data, video, autonomy, mars];

  /// The rover-like system currently in use.
  RoverType rover = RoverType.rover;

  /// A rundown of the connection strength of each device.
  String get connectionSummary {
  	final result = StringBuffer();
  	for (final socket in sockets) {
  		result.write("${socket.device.humanName}: ${(socket.connectionStrength.value*100).toStringAsFixed(0)}%\n");
  	}
  	return result.toString().trim();
  }

	@override
	Future<void> init() async {
		for (final socket in sockets) { await socket.init(); }
		await updateSockets();
	}

	@override
	Future<void> dispose() async {
		for (final socket in sockets) { await socket.dispose(); }
		handshakeTimer?.cancel();
		super.dispose();
	}

	/// Set the right IP addresses for the rover or tank.
	Future<void> updateSockets() async {
		final settings = models.settings.network;
		data.destination = settings.subsystemsSocket.copy();
		video.destination = settings.videoSocket.copy();
		autonomy.destination = settings.autonomySocket.copy();
		mars.destination = settings.marsSocket.copy();

		switch (rover) {
			case RoverType.rover: break;  // IPs are already in the settings
			case RoverType.tank: 
				for (final socket in sockets) {
					socket.destination!.address = settings.tankSocket.address;
				}
			case RoverType.localhost: 
				for (final socket in sockets) {
					socket.destination!.address = InternetAddress.loopbackIPv4;
				}
		}
		await reset();
	}

	/// Resets all the sockets.
	/// 
	/// When working with localhost, even UDP sockets can throw errors when the remote is unreachable.
	/// Resetting the sockets will bypass these errors.
	Future<void> reset() async {
		for (final socket in sockets) { await socket.reset(); }
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
