import "package:rover_dashboard/data.dart";

import "udp_server.dart";

/// A callback to execute with a specific serialized Protobuf message.
typedef MessageHandler<T extends Message> = void Function(T);

/// A service that receives Protobuf messages over a UDP connection. 
/// 
/// To listen to certain messages, call [registerHandler] with the type of message you want
/// to receive, as well as a decoder and the handler callback itself. See the documentation
/// on that function for usage. 
class MessageReceiver extends UdpServer {
	/// Handlers for every possible type of Protobuf message in serialized form.
	final Map<String, RawDataHandler> _handlers = {};

	/// Listens for incoming data.
	MessageReceiver({required super.port});

	/// Runs every time data is received by the socket. 
	/// 
	/// The datagram contains a [WrappedMessage]. These are Protobuf messages that wrap an
	/// underlying message and record their name. We use the type of the underlying message
	/// to get the appropriate handler from [_handlers] which decodes the message to the 
	/// correct type and processes it. 
	@override
	void onData(List<int> data) {
		final wrapped = WrappedMessage.fromBuffer(data);
		final RawDataHandler? rawHandler = _handlers[wrapped.name];
		if (rawHandler == null) { /* TODO: Log in some meaningful way, through the UI */ }
		else { rawHandler(wrapped.data); }
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
		required MessageHandler<T> handler
	}) {
		if (_handlers.containsKey(name)) {  // handler was already registered
			throw ArgumentError("Message handler for type [$T] already registered");
		} else {
			_handlers[name] = (List<int> data) => handler(decoder(data));
		}
	}
}
