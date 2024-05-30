import "package:burt_network/burt_network.dart";
import "package:flutter/foundation.dart";  // <-- Used for ValueNotifier

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// A service to send and receive Protobuf messages over a UDP socket, using [ProtoSocket].
/// 
/// This class monitors its connection to the given [device] by sending heartbeats periodically and
/// logging the response (or lack thereof). To be notified of connection events, pass in 
/// [onConnect] and [onDisconnect] callbacks. To be notified of incoming messages, pass in an 
/// [onMessage] callback that accepts a [WrappedMessage].
///  
/// To use this class: 
/// - Call [init] to open the socket.
/// - Check [connectionStrength] or [isConnected] for the connection to the given [device].
/// - To send a message, call [sendMessage].
/// - Call [dispose] to close the socket.
class DashboardSocket extends BurtUdpProtocol {
	/// A callback to run when the [device] has connected.
	void Function(Device device) onConnect;
	/// A callback to run when the [device] has disconnected.
	void Function(Device device) onDisconnect;

	/// The handler to call when a [WrappedMessage] comes in. Used by [onMessage].
	final WrappedMessageHandler messageHandler;

  /// Number of times to check heart beat per seconds based on [settings.network.connectionTimeout].
  double get frequency => models.settings.network.connectionTimeout;

	/// Listens for incoming messages on a UDP socket and sends heartbeats to the [device].
	DashboardSocket({
		required this.onConnect, 
		required this.onDisconnect, 
		required this.messageHandler,
		required super.device, 
	}) : super(
		port: null,
    quiet: true,
	);

  @override
  Duration get heartbeatInterval => Duration(milliseconds: 1000 ~/ frequency);

	/// The connection strength, as a percentage to this [device].
	final connectionStrength = ValueNotifier<double>(0);

	/// The number of heartbeats received since the last heartbeat was sent.
	int _heartbeats = 0;

	/// Whether [checkHeartbeats] is still running.
	bool _isChecking = false;

	/// Whether this socket has a stable connection to the [device].
  @override
	bool get isConnected => connectionStrength.value > 0;

	@override
	void onMessage(WrappedMessage wrapper) => messageHandler(wrapper);

	@override
	void onHeartbeat(Connect heartbeat, SocketInfo source) => _heartbeats++;

	@override
	Future<void> checkHeartbeats() async {
		if (_isChecking) return;
		// 1. Clear state and send a heartbeat
		_isChecking = true;
		_heartbeats = 0;
		final wasConnected = isConnected;
		sendMessage(Connect(sender: Device.DASHBOARD, receiver: device));
		// 2. Wait a bit and count the number of responses
		await Future<void>.delayed(heartbeatWaitDelay);
		if (_heartbeats > 0) {			
			connectionStrength.value += connectionIncrement * _heartbeats;
		} else {
			connectionStrength.value -= connectionIncrement;
		}
		// 3. Assess the current state
		connectionStrength.value = connectionStrength.value.clamp(0, 1);
		if (isConnected && !wasConnected) onConnect(device);
		// if (wasConnected && !isConnected) onDisconnect(device);
		_isChecking = false;
	}

  /// How much each successful/missed handshake is worth, as a percent.
  double get connectionIncrement => 1 / frequency;

  /// How long to wait for incoming heartbeats after sending them out.
  Duration get heartbeatWaitDelay => Duration(milliseconds: 1000 ~/ frequency);
}
