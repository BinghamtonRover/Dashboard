import "dart:async";
import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";

/// How much each successful/missed handshake is worth, as a percent.
const connectionIncrement = 0.2;

/// How long to wait between handshakes.
const handshakeInterval = Duration(milliseconds: 200);

/// How long to wait for incoming handshakes after sending them out.
const handshakeWaitDelay = Duration(milliseconds: 100);

/// Monitors the connection to the rover.
class RoverHeartbeats extends Model {
	/// A timer that sends handshakes to every device on the rover.
	late Timer handshakeTimer;

	/// Connection strengths of all rover devices, in percentages.
	final Map<Device, double> connections = {
		for (final device in Device.values)
			device: 0,
	};

	/// How many handshakes have been received for each device.
	final Map<Device, int> _handshakes = {
		for (final device in Device.values)
			device: 0
	};

	/// The connection strength, as a percentage, to the Subsystems Pi
	double get connectionStrength => connections[Device.SUBSYSTEMS]!;

	/// A rundown of the connection strength of each device.
	String get connectionSummary {
		final result = StringBuffer();
		for (final entry in connections.entries) {
			if (entry.key == Device.DEVICE_UNDEFINED || entry.key == Device.FIRMWARE) continue;
			result.write("${entry.key.humanName}: ${(entry.value*100).toStringAsFixed(0)}%\n");
		}
		return result.toString().trim();
	}

	@override
	Future<void> init() async {
		services.dataSocket.registerHandler<Connect>(
			name: Connect().messageName,
			decoder: Connect.fromBuffer,
			handler: onHandshakeReceived,
		);
		services.videoSocket.registerHandler<Connect>(
			name: Connect().messageName,
			decoder: Connect.fromBuffer,
			handler: onHandshakeReceived,
		);
		services.autonomySocket.registerHandler<Connect>(
			name: Connect().messageName,
			decoder: Connect.fromBuffer,
			handler: onHandshakeReceived,
		);
		services.dataSocket.registerHandler<Disconnect>(
			name: Disconnect().messageName,
			decoder: Disconnect.fromBuffer,
			handler: (data) => onDisconnect(data.sender),
		);
		services.videoSocket.registerHandler<Disconnect>(
			name: Disconnect().messageName,
			decoder: Disconnect.fromBuffer,
			handler: (data) => onDisconnect(data.sender),
		);
		services.autonomySocket.registerHandler<Disconnect>(
			name: Disconnect().messageName,
			decoder: Disconnect.fromBuffer,
			handler: (data) => onDisconnect(data.sender),
		);
		handshakeTimer = Timer(handshakeInterval, sendHandshakes);
	}

	/// Stops sending heartbeats to the old enpoints and begins sending heartbeats again.
	/// 
	/// Use this function whenever the endpoints to the rover programs have changed -- 
	/// for example, when switching between the rover and the tank, you'll want to stop
	/// all outgoing requests to the rover and begin sending heartbeats to the tank instead.
	void reset() {
		handshakeTimer.cancel();
		handshakeTimer = Timer(handshakeInterval, sendHandshakes);
	}

	@override
	void dispose() {
		handshakeTimer.cancel();
		super.dispose();
	}

	/// Indicates that a device has disconnected.
	void onDisconnect(Device device) {
		models.home.setMessage(severity: Severity.critical, text: "The ${device.humanName} has disconnected");
		if (device == Device.VIDEO) models.video.reset();
	}

	/// Logs that a handshake has been received.
	void onHandshakeReceived(Connect message) {
		if (message.receiver != Device.DASHBOARD) {
			return models.home.setMessage(severity: Severity.warning, text: "Received a handshake meant for ${message.receiver}");
		}
		_handshakes[message.sender] = _handshakes[message.sender]! + 1;
	}

	/// Sends a handshake message to the given device.
	Future<void> _sendHandshakeTo(Device device) async {
		final message = Connect(sender: Device.DASHBOARD, receiver: device);
		switch (device) {
			case Device.DEVICE_UNDEFINED: return;
			case Device.FIRMWARE: return;  // must be done manually through [SerialModel]
			case Device.DASHBOARD:
				return models.home.setMessage(severity: Severity.warning, text: "Trying to send a handshake message to ourself");
			case Device.SUBSYSTEMS: 
				return services.dataSocket.sendMessage(message);  
			case Device.VIDEO: 
				return services.videoSocket.sendMessage(message);
			case Device.AUTONOMY: 
				return services.autonomySocket.sendMessage(message);
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
	///
	/// Each received/missed handshake is worth 20%, so 5 successful hadnshakes means
	/// the rover has a 100% connection strength. We use this handshake protocol instead
	/// of TCP to allow *some* packets to drop for up to 25 seconds before giving up.
	Future<void> sendHandshakes([_]) async {
		for (final device in Device.values) {
			if (device == Device.DASHBOARD) continue;
			_handshakes[device] = 0;
			await _sendHandshakeTo(device);
		}
		await Future<void>.delayed(handshakeWaitDelay);
		for (final device in Device.values) {
			final oldConnection = connections[device];
			if (_handshakes[device]! > 0) {
				if (connections[device]! == 0) {
					models.home.setMessage(severity: Severity.info, text: "The ${device.humanName} has connected");
				}
				final numHandshakes = _handshakes[device]!;
				final score = connectionIncrement * numHandshakes;
				connections[device] = connections[device]! + score;
			} else {
				connections[device] = connections[device]! - connectionIncrement;
			}
			if (connections[device]! > 1) connections[device] = 1;
			if (connections[device]! < 0) connections[device] = 0;
			if (oldConnection! > 0 && connections[device]! == 0) onDisconnect(device);
		}
		handshakeTimer = Timer(handshakeInterval, sendHandshakes);
		notifyListeners();
	}
}
