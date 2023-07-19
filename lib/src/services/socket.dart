import "package:burt_network/burt_network.dart";
import "package:flutter/foundation.dart";  // <-- Used for ValueNotifier
import "package:protobuf/protobuf.dart";

import "package:rover_dashboard/data.dart";

import "service.dart";

/// A callback to execute with a specific serialized Protobuf message.
typedef MessageHandler<T extends Message> = void Function(T);

/// A callback to execute with raw Protobuf data.
typedef RawDataHandler = void Function(List<int> data);

/// A service to send and receive Protobuf messages over a UDP socket, using [ProtoSocket].
/// 
/// - To send a message, call [sendMessage].
/// - To be notified when a message is received, call [registerHandler].
class DashboardSocket extends ProtoSocket implements Service {
	// ================== Final fields ==================
	/// A list of message names that are allowed to pass without a handler.
	final Set<String> allowedFallthrough;
	/// The handlers registered by [registerHandler].
	final Map<String, RawDataHandler> _handlers = {};

	/// Listens for incoming messages on a UDP socket and sends heartbeats to the [device].
	DashboardSocket({required super.device, this.allowedFallthrough = const {}}) : super(port: 0);

	// ================== Mutable fields ==================
	/// The connection strength, as a percentage to this [device].
	final connectionStrength = ValueNotifier<double>(0);

	/// The latest [HeartbeatEvent] emitted by this socket. 
	final event = ValueNotifier(HeartbeatEvent.none);

	/// The number of heartbeats received since the last heartbeat was sent.
	int _heartbeats = 0;

	/// Whether [checkHeartbeats] is still running.
	bool _isChecking = false;

	/// Whether this socket has a stable connection to the [device].
	bool get isConnected => connectionStrength.value > 0;

	// ================== Overriden methods ==================

	@override
	void onMessage(WrappedMessage wrapper) {
		final rawHandler = _handlers[wrapper.name];
		if (rawHandler == null) {
			if (allowedFallthrough.contains(wrapper.name)) return;
			throw StateError("No handler registered for ${wrapper.name} message on the $device socket");
		}
		try { return rawHandler(wrapper.data); }
		on InvalidProtocolBufferException {
			try { return rawHandler(wrapper.data); }
			on InvalidProtocolBufferException { /* Nothing we can do */ }
		}	
	}

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
			if (!wasConnected) event.value = HeartbeatEvent.connected;
			connectionStrength.value += connectionIncrement * _heartbeats;
		} else {
			if (wasConnected) event.value = HeartbeatEvent.disconnected;
			connectionStrength.value -= connectionIncrement;
		}
		connectionStrength.value = connectionStrength.value.clamp(0, 1);
		_isChecking = false;
	}

	@override
	void onHeartbeat(Connect heartbeat, SocketInfo source) => _heartbeats++;

	// ================== Public methods ==================

	/// Adds a handler for a given type. 
	/// 
	/// When a new message is received, [onMessage] checks to see if its type matches [name].
	/// If so, it calls [decoder] to parse the binary data into a Protobuf class, and then
	/// calls [handler] with that parsed data class. 
	/// 
	/// For example, with a message called `ScienceData`, you would use this function as: 
	/// ```dart
	/// registerHandler<ScienceData>(
	/// 	name: ScienceData().messageName,  // identify the data as a ScienceData message
	/// 	decoder: ScienceData.fromBuffer,  // deserialize into a ScienceData instance
	/// 	handler: (ScienceData data) => print(data.methane),  // do something with the data
	/// );
	/// ```
	void registerHandler<T extends Message>({
		required String name, 
		required MessageDecoder<T> decoder, 
		required MessageHandler<T> handler,
	}) {
		if (_handlers.containsKey(name)) {  // handler was already registered
			throw ArgumentError("There's already a message handler for $name.");
		} else {
			_handlers[name] = (data) => handler(decoder(data));
		}
	}

	/// Removes the handler for a given message type. 
	/// 
	/// This is useful if you register a handler to update a piece of UI that is no longer on-screen.
	void removeHandler(String name) => _handlers.remove(name);
}

/// An event representing a change in network connection status.
enum HeartbeatEvent {
	/// The device just connected.
	connected, 
	/// The device just disconnected.
	disconnected, 
	/// Nothing just happened. Useful for an initial value.
	none
}

/// How much each successful/missed handshake is worth, as a percent.
const connectionIncrement = 0.2;

/// How long to wait for incoming heartbeats after sending them out.
const heartbeatWaitDelay = Duration(milliseconds: 200);
