import "package:burt_network/burt_network.dart";
import "package:flutter/foundation.dart";  // <-- Used for ValueNotifier

import "package:rover_dashboard/data.dart";

import "service.dart";
import "wrapper_registry.dart";

/// A service to send and receive Protobuf messages over a UDP socket, using [ProtoSocket].
/// 
/// This class monitors its connection to the given [device] by sending heartbeats periodically and
/// logging the response (or lack thereof).
/// - Heartbeats are sent via [checkHeartbeats] 
/// - The strength of the connection is exposed via [connectionStrength], which is also a [ValueNotifier].
/// - For a simple connection check, use [isConnected].
/// - Use the [event] [ValueNotifier] to listen for new or dropped connections.
/// 
/// To use this class: 
/// - Call [init] to open the socket.
/// - Check [connectionStrength] for the connection to the given [device].
/// - To send a message, call [sendMessage].
/// - To be notified when a message is received, call [registerHandler]. 
/// - To remove your handler, call [removeHandler].
/// - Call [dispose] to close the socket.
class DashboardSocket extends ProtoSocket with WrapperRegistry implements Service {
	/// A list of message names that are allowed to pass without a handler.
	@override
	final Set<String> allowedFallthrough;

	/// A callback to run when the [device] has connected.
	void Function(Device device) onConnect;
	/// A callback to run when the [device] has disconnected.
	void Function(Device device) onDisconnect;

	/// Listens for incoming messages on a UDP socket and sends heartbeats to the [device].
	DashboardSocket({required this.onConnect, required this.onDisconnect, required super.device, this.allowedFallthrough = const {}}) : super(port: 0);

	/// The connection strength, as a percentage to this [device].
	final connectionStrength = ValueNotifier<double>(0);

	/// The number of heartbeats received since the last heartbeat was sent.
	int _heartbeats = 0;

	/// Whether [checkHeartbeats] is still running.
	bool _isChecking = false;

	/// Whether this socket has a stable connection to the [device].
	bool get isConnected => connectionStrength.value > 0;

	@override
	void updateSettings(UpdateSetting settings) { }

	@override
	Future<void> checkHeartbeats() async {
		if (_isChecking) return;
		_isChecking = true;
		_heartbeats = 0;
		sendMessage(Connect(sender: Device.DASHBOARD, receiver: device));
		await Future<void>.delayed(heartbeatWaitDelay);
		final wasConnected = isConnected;
		if (_heartbeats > 0) {			
			if (!wasConnected) onConnect(device);
			connectionStrength.value += connectionIncrement * _heartbeats;
		} else {
			if (wasConnected) onDisconnect(device);
			connectionStrength.value -= connectionIncrement;
		}
		connectionStrength.value = connectionStrength.value.clamp(0, 1);
		_isChecking = false;
	}

	@override
	void onHeartbeat(Connect heartbeat, SocketInfo source) => _heartbeats++;
}

/// How much each successful/missed handshake is worth, as a percent.
const connectionIncrement = 0.2;

/// How long to wait for incoming heartbeats after sending them out.
const heartbeatWaitDelay = Duration(milliseconds: 200);
