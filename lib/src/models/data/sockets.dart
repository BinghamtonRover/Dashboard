import "dart:io";
import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";

/// Coordinates all the sockets to point to the right [RoverType].
class Sockets extends Model {
	/// A UDP socket for sending and receiving Protobuf data.
	final data = DashboardSocket(device: Device.SUBSYSTEMS);

	/// A UDP socket for receiving video.
	final video = DashboardSocket(device: Device.VIDEO);

	/// A UDP socket for receiving video.
	final video2 = DashboardSocket(device: Device.VIDEO);

	/// A UDP socket for controlling autonomy.
	final autonomy = DashboardSocket(device: Device.AUTONOMY, allowedFallthrough: {AutonomyData().messageName});

  /// A UDP socket for controlling rover position
  final mars = DashboardSocket(device: Device.MARS_SERVER);

  /// A list of all the sockets this model manages.
  late final List<DashboardSocket> sockets = [data, video, video2, autonomy, mars];

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
		for (final socket in sockets) { 
			await socket.init(); 
			socket.event.addListener(() => onNewEvent(socket.device, socket.event.value));
		}
		await updateSockets();
	}

	@override
	Future<void> dispose() async {
		for (final socket in sockets) { 
			await socket.dispose();
		}
		super.dispose();
	}

	/// Notifies the user when a device connects or disconnects.
	void onNewEvent(Device device, HeartbeatEvent event) {
		switch (event) {
			case HeartbeatEvent.connected: 
				models.home.setMessage(severity: Severity.info, text: "The ${device.humanName} has connected");
				if (device == Device.SUBSYSTEMS) models.rover.status.value = models.rover.settings.status;
			case HeartbeatEvent.disconnected: 
				models.home.setMessage(severity: Severity.critical, text: "The ${device.humanName} has disconnected");
				if (device == Device.SUBSYSTEMS) models.rover.status.value = RoverStatus.DISCONNECTED;
				if (device == Device.VIDEO) models.video.reset();
				if (device == Device.MARS_SERVER) models.rover.metrics.mars.clearStatus();
			case HeartbeatEvent.none:
		}
	}

	/// Set the right IP addresses for the rover or tank.
	Future<void> updateSockets() async {
		// Initialize sockets
		final settings = models.settings.network;
		data.destination = settings.subsystemsSocket.copy();
		video.destination = settings.videoSocket.copy();
		video2.destination = SocketInfo(address: InternetAddress("192.168.1.30"), port: 8007);
		autonomy.destination = settings.autonomySocket.copy();
		mars.destination = settings.marsSocket.copy();

		// Change IP addresses
		for (final socket in sockets) {
			socket.destination!.address = switch (rover) {
				RoverType.rover => socket.destination!.address,
				RoverType.tank => settings.tankSocket.address,
				RoverType.localhost => InternetAddress.loopbackIPv4,
			};
		}

		// Reset
		await reset();
	}

	/// Resets all the sockets.
	/// 
	/// When working with localhost, even UDP sockets can throw errors when the remote is unreachable.
	/// Resetting the sockets will bypass these errors.
	Future<void> reset() async {
		for (final socket in sockets) { 
			await socket.dispose();
			await socket.init();
		}
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
