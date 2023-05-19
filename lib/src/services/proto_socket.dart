import "package:async/async.dart";
import "package:flutter/foundation.dart";  // <-- Used for ValueNotifier
import "package:protobuf/protobuf.dart";

import "package:rover_dashboard/data.dart";

import "udp_socket.dart";

/// A callback to execute with a specific serialized Protobuf message.
typedef MessageHandler<T extends Message> = void Function(T);

/// An event representing a change in network connection status.
enum HeartbeatEvent {
	/// The device just connected.
	connected, 
	/// The device just disconnected.
	disconnected, 
	/// Nothing just happened. Useful for an initial value.
	none
}

/// A service to send and receive Protobuf messages over a UDP socket.
/// 
/// All messages are first wrapped in a [WrappedMessage] to identify their type before being
/// sent over the network. That means you'll need to call [registerHandler] to tell this class
/// which type you're expecting to handle and how to decode then handle it. [sendMessage] will 
/// automatically wrap your message for you. 
///
/// To listen to certain messages, call [registerHandler] with the type of message you want
/// to receive, as well as a decoder and the handler callback itself. See the documentation
/// on that function for usage. 
class ProtoSocket extends UdpSocket {
	/// Handlers for every possible type of Protobuf message in serialized form.
	final Map<String, RawDataHandler> _handlers = {};

	/// The device this socket is responsible for connecting to.
	/// 
	/// This device is reachable at [destination].
	final Device device;

	/// Allows the following messages to be received without a handler.
	/// 
	/// It is important that we default to an error if there is no handler becuase otherwise,
	/// messages with no handlers won't be handled leading to hard-to-find bugs.
	final Set<String> allowFallthrough;

	/// Opens a socket for sending and receiving Protobuf messages.
	ProtoSocket({required this.device, this.allowFallthrough = const {}, super.destination});

	/// Runs every time data is received by the socket. 
	/// 
	/// The datagram contains a [WrappedMessage]. These are Protobuf messages that wrap an
	/// underlying message and record their name. We use the type of the underlying message
	/// to get the appropriate handler from [_handlers] which decodes the message to the 
	/// correct type and processes it. 
	@override
	void onData(List<int> data) {
		final wrapped = WrappedMessage.fromBuffer(data);
		final rawHandler = _handlers[wrapped.name];
		if (rawHandler == null) {
			if (allowFallthrough.contains(wrapped.name)) return;
			throw StateError("No handler registered for ${wrapped.name} message on the $device socket");
		}
		try { return rawHandler(wrapped.data); }
		on InvalidProtocolBufferException {
			// There is a bug where CAN messages are getting mutated over the wire.
			// Since most of our data is 5 bytes, try truncating it and see if that helps.
			// TODO: Log this somehow
			if (wrapped.data.length <= 5) return;
			final data = wrapped.data.sublist(5);
			try { return rawHandler(data); }
			on InvalidProtocolBufferException { /* Nothing we can do */ }
		}
	}

	/// Adds a handler for a given type. 
	/// 
	/// When a new message is received, [onData] checks to see if its type matches [name].
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
	/// 
	/// This allows the caller to avoid having to parse out on their own which type of data
	/// was received and how to decode it. 
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

	/// Wraps the [message] in a [WrappedMessage] container and sends it to the rover. 
	void sendMessage(Message message) => sendBytes(message.wrapped.writeToBuffer());

	// ==================== Heartbeats ====================

	/// The connection strength, as a percentage to this [device].
	final connectionStrength = ValueNotifier(0.0);

	/// The latest [HeartbeatEvent] emitted by this socket. 
	final event = ValueNotifier(HeartbeatEvent.none);

	/// The number of heartbeats received since the last heartbeat was sent.
	int _heartbeats = 0;

	/// Whether this socket has a stable connection to the [device]/
	bool get isConnected => connectionStrength.value > 0;

	/// A timer that sends heartbeats to the [device] every [heartbeatInterval].
	late RestartableTimer heartbeatTimer;

	@override
	Future<void> init() async {
		super.init();
		heartbeatTimer = RestartableTimer(heartbeatInterval, sendHeartbeat);
		registerHandler<Connect>(
			name: Connect().messageName,
			decoder: Connect.fromBuffer,
			handler: (_) => _heartbeats++,
		);
	}

	@override
	Future<void> dispose() async {
		heartbeatTimer.cancel();
		super.dispose();
	}

	@override
	Future<void> reset() async {
		super.reset();
		heartbeatTimer.reset();
	} 

	/// Sends a heartbeat to the [device] and updates [connectionStrength] depending on how many
	/// heartbeats are received in [heartbeatWaitDelay].
	Future<void> sendHeartbeat() async {
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
		heartbeatTimer.reset();
	}
}

/// How much each successful/missed handshake is worth, as a percent.
const connectionIncrement = 0.2;

/// How long to wait between handshakes.
const heartbeatInterval = Duration(milliseconds: 200);

/// How long to wait for incoming heartbeats after sending them out.
const heartbeatWaitDelay = Duration(milliseconds: 100);
