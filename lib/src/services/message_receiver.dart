import "dart:async";
import "dart:io";

import "package:rover_dashboard/data.dart";
import "service.dart";

/// A callback to execute with raw Protobuf data.
typedef RawMessageHandler = void Function(List<int> data);

/// A callback to execute with a specific serialized Protobuf message.
// typedef MessageHandler<T extends Message> = void Function(T);
typedef Handler<T> = void Function(T);

/// The port to listen for messages on.
const port = 22201;

/// A function that handles incoming data. 
extension on RawDatagramSocket {
	StreamSubscription listenForData(Handler<List<int>> handler) => listen((event) {
		final datagram = receive();
		if (datagram == null) return; 
		handler(datagram.data);
	});
}

/// A service that receives messages over a UDP connection. 
/// 
/// To listen to certain messages, call [registerHandler] with the type of message you want
/// to receive, as well as a decoder and the handler callback itself. 
class MessageReceiver extends Service {
	/// Handlers for every possible type of Protobuf message in serialized form.
	final Map<String, RawMessageHandler> _handlers = {};

	/// The UDP socket to listen on.
	/// 
	/// Initialized in [init].
	late final RawDatagramSocket _socket;

	/// The subscription that listens to [_socket]. 
	late final StreamSubscription _subscription;

	@override
	Future<void> init() async {
		_socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, port);
		_subscription = _socket.listenForData(_listener);
	}

	@override
	Future<void> dispose() async {
		await _subscription.cancel();
		_socket.close();
	}

	/// Runs every time data is received by the socket. 
	/// 
	/// The datagram contains a [WrappedMessage]. These are Protobuf messages that wrap an
	/// underlying message and record their name. We use the type of the underlying message
	/// to get the appropriate handler from [_handlers] which decodes the message to the 
	/// correct type and processes it. 
	void _listener(List<int> data) {
		final wrapped = WrappedMessage.fromBuffer(data);
		final RawMessageHandler? rawHandler = _handlers[wrapped.name];
		if (rawHandler == null) { /* Log in some meaningful way, through the UI */ }
		else { rawHandler(wrapped.data); }
	}

	/// Adds a handler for a given type. 
	/// 
	/// [decoder] is a function that decodes a byte buffer to a Protobuf message class. [handler] 
	/// then handles that message somehow. 
	void registerHandler<T extends Message>({
		required String name, 
		required MessageDecoder<T> decoder, 
		required Handler<T> handler
	}) {
		if (T == Message) {  // no T was actually passed, [Message] is the default
			throw ArgumentError("No message type was passed");
		} else if (_handlers.containsKey(name)) {  // handler was already registered
			throw ArgumentError("Message handler for type [$T] already registered");
		} else {
			_handlers[name] = (List<int> data) => handler(decoder(data));
		}
	}
}
