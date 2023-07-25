import "dart:io";
import "package:burt_network/burt_network.dart";
import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";

/// Coordinates all the sockets to point to the right [RoverType].
class Sockets extends Model {
	/// A UDP socket for sending and receiving Protobuf data.
	late final data = DashboardSocket(
		device: Device.SUBSYSTEMS,
		onConnect: onConnect, 
		onDisconnect: onDisconnect,
		messageHandler: models.messages.onMessage,
	);

	/// A UDP socket for receiving video.
	late final video = DashboardSocket(
		device: Device.VIDEO,
		onConnect: onConnect, 
		onDisconnect: onDisconnect,
		messageHandler: models.messages.onMessage,
	);

	/// A UDP socket for receiving video.
	late final video2 = DashboardSocket(
		device: Device.VIDEO,
		onConnect: onConnect, 
		onDisconnect: onDisconnect,
		messageHandler: models.messages.onMessage,
	);

	/// A UDP socket for controlling autonomy.
	late final autonomy = DashboardSocket(
		device: Device.AUTONOMY,
		onConnect: onConnect, 
		onDisconnect: onDisconnect,
		messageHandler: models.messages.onMessage,
	);

  /// A UDP socket for controlling the MARS subsystem.
  late final mars = DashboardSocket(
  	device: Device.MARS_SERVER,
  	onConnect: onConnect, 
		onDisconnect: onDisconnect,
		messageHandler: models.messages.onMessage,
	);

  /// A list of all the sockets this model manages.
  List<DashboardSocket> get sockets => [data, video, video2, autonomy, mars];

  /// The rover-like system currently in use.
  RoverType rover = RoverType.rover;

  /// The [InternetAddress] to use instead of the address on the rover.
  InternetAddress? get addressOverride => switch (rover) {
  	RoverType.rover => null,
  	RoverType.tank => models.settings.network.tankSocket.address,
  	RoverType.localhost => InternetAddress.loopbackIPv4,
  };

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
		}
		final level = BurtLogger.level;
		BurtLogger.level = LogLevel.warning;
		await updateSockets();
		BurtLogger.level = level;
	}

	@override
	Future<void> dispose() async {
		for (final socket in sockets) { 
			await socket.dispose();
		}
		super.dispose();
	}

	/// Notifies the user when a new device has connected.
	void onConnect(Device device) {
		models.home.setMessage(severity: Severity.info, text: "The ${device.humanName} has connected");
		if (device == Device.SUBSYSTEMS) models.rover.status.value = models.rover.settings.status;
	}

	/// Notifies the user when a device has disconnected.
	void onDisconnect(Device device) {
		models.home.setMessage(severity: Severity.critical, text: "The ${device.humanName} has disconnected");
		if (device == Device.SUBSYSTEMS) models.rover.status.value = RoverStatus.DISCONNECTED;
		if (device == Device.VIDEO) models.video.reset();
		if (device == Device.MARS_SERVER) models.rover.metrics.mars.clearStatus();
	}

	/// Set the right IP addresses for the rover or tank.
	Future<void> updateSockets() async {
		final settings = models.settings.network;
		data.destination = settings.subsystemsSocket.copyWith(address: addressOverride);
		video.destination = settings.videoSocket.copyWith(address: addressOverride);
		video2.destination = SocketInfo(address: InternetAddress("192.168.1.30"), port: 8007);
		autonomy.destination = settings.autonomySocket.copyWith(address: addressOverride);
		mars.destination = settings.marsSocket.copyWith(address: addressOverride);
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
