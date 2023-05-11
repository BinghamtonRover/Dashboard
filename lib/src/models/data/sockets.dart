import "dart:async";
import "dart:io";
import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";

/// How much each successful/missed handshake is worth, as a percent.
const connectionIncrement = 0.2;

/// How long to wait between handshakes.
const handshakeInterval = Duration(milliseconds: 200);

/// How long to wait for incoming handshakes after sending them out.
const handshakeWaitDelay = Duration(milliseconds: 100);

extension on ProtoSocket {
	void onConnect(void Function(Connect) callback) => registerHandler<Connect>(
		name: Connect().messageName,
		decoder: Connect.fromBuffer,
		handler: callback,
	);

	void onDisconnect(void Function(Device) callback) => registerHandler<Disconnect>(
		name: Disconnect().messageName,
		decoder: Disconnect.fromBuffer,
		handler: (data) => callback(data.sender),
	);
}

/// Coordinates all the sockets to point to the right [RoverType].
class Sockets extends Model {
	/// Don't show these devices in the [connectionSummary].
	static const dontShow = {Device.DEVICE_UNDEFINED, Device.FIRMWARE, Device.DASHBOARD};

	/// A timer that sends handshakes to every device on the rover.
	Timer? handshakeTimer;

	/// A UDP socket for sending and receiving Protobuf data.
	final data = ProtoSocket();

	/// A UDP socket for receiving video.
	final video = ProtoSocket();

	/// A UDP socket for controlling autonomy.
	final autonomy = ProtoSocket();

  /// A UDP socket for controlling rover position
  final mars = ProtoSocket();

  /// The rover-like system currently in use.
  RoverType rover = RoverType.rover;

  /// Connection strengths of all rover devices, in percentages.
  final Map<Device, double> connections = {
  	for (final device in Device.values) device: 0,
  };

  /// How many handshakes have been received for each device.
  final Map<Device, int> _handshakes = {
  	for (final device in Device.values) device: 0
  };

  /// The connection strength, as a percentage, to the Subsystems Pi
  double get connectionStrength => connections[Device.SUBSYSTEMS]!;

  /// A rundown of the connection strength of each device.
  String get connectionSummary {
  	final result = StringBuffer();
  	for (final entry in connections.entries) {
  		if (dontShow.contains(entry.key)) continue;
  		result.write("${entry.key.humanName}: ${(entry.value*100).toStringAsFixed(0)}%\n");
  	}
  	return result.toString().trim();
  }

	@override
	Future<void> init() async {
		await data.init();
		await video.init();
		await autonomy.init();
    await mars.init();
    data.onConnect(handleConnect);
    video.onConnect(handleConnect);
    autonomy.onConnect(handleConnect);
    mars.onConnect(handleConnect);
    data.onDisconnect(handleDisconnect);
    video.onDisconnect(handleDisconnect);
    autonomy.onDisconnect(handleDisconnect);
    mars.onDisconnect(handleDisconnect);
		await updateSockets();
	}

	@override
	Future<void> dispose() async {
		await data.dispose();
		await video.dispose();
		await autonomy.dispose();
    await mars.dispose();
		super.dispose();
	}

	/// Logs that a handshake has been received.
	void handleConnect(Connect message) {
		_handshakes[message.sender] = _handshakes[message.sender]! + 1;
	}

	/// Indicates that a device has disconnected.
	void handleDisconnect(Device device) {
		models.home.setMessage(severity: Severity.critical, text: "The ${device.humanName} has disconnected");
		if (device == Device.VIDEO) models.video.reset();
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
				final tankAddress = settings.tankSocket.address;
				data.destination!.address = tankAddress;
				video.destination!.address = tankAddress;
				autonomy.destination!.address = tankAddress;
				mars.destination!.address = tankAddress;
				break;
			case RoverType.localhost: 
				final localAddress = InternetAddress.loopbackIPv4;
				data.destination!.address = localAddress;
				video.destination!.address = localAddress;
				autonomy.destination!.address = localAddress;				
				mars.destination!.address = localAddress;				
				break;
		}
		await reset();
	}

	/// Resets all the sockets.
	/// 
	/// When working with localhost, even UDP sockets can throw errors when the remote is unreachable.
	/// Resetting the sockets will bypass these errors.
	Future<void> reset() async {
		await data.reset();
		await video.reset();
		await autonomy.reset();
		await mars.reset();
		handshakeTimer?.cancel();
		handshakeTimer = Timer(handshakeInterval, sendHandshakes);
	}

	/// Sends a handshake message to the given device.
	Future<void> _sendHandshakeTo(Device device) async {
		final message = Connect(sender: Device.DASHBOARD, receiver: device);
		switch (device) {
			case Device.DEVICE_UNDEFINED: return;
			case Device.FIRMWARE: return;  // must be done manually through [SerialModel]
			case Device.DASHBOARD: return models.home.setMessage(severity: Severity.warning, text: "Trying to send a handshake message to ourself");
			case Device.SUBSYSTEMS: return models.sockets.data.sendMessage(message);  
			case Device.VIDEO: return models.sockets.video.sendMessage(message);
			case Device.AUTONOMY: return models.sockets.autonomy.sendMessage(message);
			case Device.MARS_SERVER: return models.sockets.mars.sendMessage(message);
			// TODO: Send heartbeats to the firwmare Teensy's.
			case Device.ARM: 
			case Device.GRIPPER:
			case Device.SCIENCE: 
			case Device.ELECTRICAL: 
			case Device.DRIVE: 
			case Device.MARS:
		}
	}

	/// Sends handshakes to every device and monitors the connection.
	Future<void> sendHandshakes([_]) async {
		for (final device in Device.values) {
			if (device == Device.DASHBOARD) continue;
			_handshakes[device] = 0;
			await _sendHandshakeTo(device);
		}
		await Future<void>.delayed(handshakeWaitDelay);
		for (final device in Device.values) {
			final wasConnected = connections[device]! > 0;
			if (_handshakes[device]! > 0) {
				if (!wasConnected) models.home.setMessage(severity: Severity.info, text: "The ${device.humanName} has connected");
				final numHandshakes = _handshakes[device]!;
				final score = connectionIncrement * numHandshakes;
				connections[device] = connections[device]! + score;
			} else {
				connections[device] = connections[device]! - connectionIncrement;
				if (wasConnected) handleDisconnect(device);
			}
			connections[device] = connections[device]!.clamp(0, 1);
		}
		handshakeTimer = Timer(handshakeInterval, sendHandshakes);
		notifyListeners();
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
