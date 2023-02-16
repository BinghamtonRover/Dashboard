import "dart:async";
import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";

import "../model.dart";

const connectionIncrement = 0.2;
const handshakeInterval = Duration(seconds: 2);

class RoverCore extends Model {
	Timer? handshakeTimer;

	final Map<Device, double> connections = {
		for (final device in Device.values)
			device: 0,
	};

	final Map<Device, bool> _handshakes = {
		for (final device in Device.values)
			device: false
	};

	bool get isConnected => connections[Device.SUBSYSTEMS]! > 0;

	@override
	Future<void> init() async {
		services.messageReceiver.registerHandler<Connect>(
			name: Connect().messageName,
			decoder: Connect.fromBuffer,
			handler: onConnectReceived,
		);
	}

	@override
	void dispose() {
		handshakeTimer?.cancel();
		super.dispose();
	}

	void onConnectReceived(Connect message) {
		if (message.receiver != Device.DASHBOARD) {
			return models.home.setMessage(severity: Severity.warning, text: "Received a handshake meant for ${message.receiver}");
		}
		// Subsystems sends its own handshakes, we must reciprocate
		if (message.sender == Device.SUBSYSTEMS) _sendHandshakeTo(Device.SUBSYSTEMS);
		_handshakes[message.sender] = true;
	}

	Future<void> _sendHandshakeTo(Device device) async {
		final message = Connect(sender: Device.DASHBOARD, receiver: device);
		switch (device) {
			case Device.DEVICE_UNDEFINED: return;
			case Device.FIRMWARE: return;  // must be done manually through [SerialModel]
			case Device.SUBSYSTEMS: 
				return services.messageSender.sendMessage(message);  
			case Device.DASHBOARD: 
				return models.home.setMessage(severity: Severity.warning, text: "Trying to send a handshake message to ourself");
			case Device.VIDEO: 
				return services.messageSender.sendMessage(message, address: secondaryPiAddress, port: videoPort);
			case Device.AUTONOMY: 
				return services.messageSender.sendMessage(message, address: secondaryPiAddress, port: autonomyPort);
		}
	}

	Future<bool> sendHandshakes([_]) async {
		for (final device in Device.values) {
			if (device == Device.DASHBOARD) continue;
			await _sendHandshakeTo(device);
			_handshakes[device] = false;
		}
		await Future.delayed(const Duration(milliseconds: 500));
		for (final device in Device.values) {
			if (_handshakes[device]!) { connections[device] = connections[device]! + connectionIncrement; }
			else { connections[device] = connections[device]! - connectionIncrement; }
		}
		return _handshakes[Device.SUBSYSTEMS]!;
	}

	/// Connects to the rover and establishes the handshake protocol.
	Future<void> connect() async {
		if (!await sendHandshakes()) return models.home.setMessage(severity: Severity.error, text: "Cannot connect to the rover");
		handshakeTimer = Timer.periodic(handshakeInterval, sendHandshakes);
	}
}
