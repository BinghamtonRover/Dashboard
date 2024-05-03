import "package:protobuf/protobuf.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// A mixin that delegates [WrappedMessage]s to a handler via [registerHandler].
/// 
/// - Use [registerHandler] to invoke your handler whenever a new message is received.
/// - Use [removeHandler] to remove your handler.
/// - Override [allowedFallthrough] to allow certain massages to pass unhandled.
class MessagesModel {
	/// A set of message types that are allowed to pass through without being handled.
	static const Set<String> allowedFallthrough = {"AutonomyData", "Disconnect"};

	/// A set of handlers to be called based on [WrappedMessage.name].
	final Map<String, RawDataHandler> _handlers = {};

	/// Delegates the message contents to the appropriate handler.
	void onMessage(WrappedMessage wrapper) {
		final rawHandler = _handlers[wrapper.name];
		if (rawHandler == null) {
			if (allowedFallthrough.contains(wrapper.name)) return;
			throw StateError("No handler registered for ${wrapper.name} message");
		}
		try { return rawHandler(wrapper.data); }
		on InvalidProtocolBufferException {
			try { return rawHandler(wrapper.data); }
			on InvalidProtocolBufferException { /* Nothing we can do */ }
		}	
	}

	/// Sends a command over the network or over Serial.
	void sendMessage(Message message) {
		models.serial.sendMessage(message);
		models.sockets.data.sendMessage(message);
	}

	/// Adds a handler for the given message type. 
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
