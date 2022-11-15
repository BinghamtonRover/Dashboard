import "dart:async";
import "dart:io";

import "service.dart";

/// A callback to execute with raw Protobuf data.
typedef RawDataHandler = void Function(List<int> data);

/// Helper methods on raw data streams.
extension on RawDatagramSocket {
	/// Parses out empty data before handling it. 
	StreamSubscription listenForData(RawDataHandler handler) => listen((event) {
		final datagram = receive();
		if (datagram == null) return; 
		handler(datagram.data);
	});
}

/// A UDP server that listens for incoming data. 
/// 
/// The dashboard uses a Local Area Network (LAN) to interface with the rover. 
/// The dashboard receives data and video streams from the rover and sends 
/// commands to it. All networking is done via the UDP protocol. Compared to TCP, 
/// which is normally used by HTTP connections, UDP is faster and more efficient,
/// at the cost of being less reliable. Since the rover and dashboard will be 
/// constantly sending data and commands every second, a few dropped packets here
/// and there are okay, and should not hold up the connection, as TCP would.
/// 
/// This class uses `dart:io`'s [RawDatagramSocket] to open a UDP connection. Call
/// [init] before using any methods, and call [dispose] when finished to close the 
/// socket. Override [onData] to handle the incoming data, in the form of raw bytes.
/// 
/// See the [Network Address Assignments](https://docs.google.com/document/d/1U6GxcYGpqUpSgtXFbiOTlMihNqcg6RbCqQmewx7cXJE) document for IP address and ports. 
abstract class UdpServer extends Service {
	/// The port to listen on. 
	/// 
	/// This must be a field since the dashboard can have multiple connections open
	/// at once while sharing the same backend. Each connection has its own port. 
	final int port;

	/// The UDP socket to listen on. Backed by `dart:io`.
	/// 
	/// This socket must be closed in [dispose]. 
	late final RawDatagramSocket _socket;

	/// The subscription that listens to [_socket]. 
	/// 
	/// This must be cancelled when the socket is closed, or else memory will leak
	/// and the dashboard may not terminate properly. This happens in [dispose]. 
	late final StreamSubscription _subscription;

	/// Opens a UDP server on the given port. 
	UdpServer({required this.port});

	@override
	Future<void> init() async {
		_socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, port);
		_subscription = _socket.listenForData(onData);
	}

	@override
	Future<void> dispose() async {
		await _subscription.cancel();
		_socket.close();
	}

	/// Runs when new data is received.
	/// 
	/// Override this to do something with the incoming bytes. Typically you'd want to
	/// parse them into some other useful format, such as Protobuf messages. 
	/// 
	/// According to the documentation for [RawDatagramSocket.receive], the maximum size
	/// of a packet is 65503 bytes, just shy of 2^16 bytes.
	void onData(List<int> data);
}
