import "dart:io";

import "package:rover_dashboard/data.dart";

import "service.dart";

/// A service to send [Message] objects to the rover. 
class MessageSender extends Service {
	/// The IP address of the rover. 
	static final address = InternetAddress("127.0.0.1");

	/// The port on the rover to send to. 
	static const port = 8082;

	/// The socket for the UDP connection. 
	late final RawDatagramSocket _socket;

	@override
	Future<void> init() async {
		_socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, port);
	}

	@override
	Future<void> dispose() async { 
		_socket.close();
	}

	/// Resets the connection. 
	/// 
	/// When in doubt, turn it off and back on again.
	Future<void> reset() async {
		await dispose();
		await init();
	} 

	/// Wraps the [message] in a [WrappedMessage] container and sends it to the rover. 
	Future<void> send(Message message) async { 
		final wrapper = WrappedMessage(name: message.info_.messageName, data: message.writeToBuffer());
		_socket.send(wrapper.writeToBuffer(), address, port);
	}
}
