import "dart:async";
import "dart:io";

import "package:rover_dashboard/data.dart";
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

/// A UDP client that sends data to a server. 
/// 
/// The dashboard uses a Local Area Network (LAN) to interface with the rover. 
/// The dashboard receives data and video streams from the rover and sends 
/// commands to it. All networking is done via the UDP protocol. Compared to TCP, 
/// which is normally used by HTTP connections, UDP is faster and more efficient,
/// at the cost of being less reliable. Since the rover and dashboard will be 
/// constantly sending data and commands every second, a few dropped packets here
/// and there are okay, and should not hold up the connection, as TCP would.
/// 
/// This class uses `dart:io`'s [RawDatagramSocket] to open a UDP connection.
/// 
/// - Call [init] before using any methods, and call [dispose] when finished
/// - Use [sendBytes] to send raw data to a server. 
/// - Override [onData] to handle incoming data 
/// - Override this class to define custom methods, like `sendMessage` or `sendFrame`
/// 
/// See the [Network Address Assignments](https://docs.google.com/document/d/1U6GxcYGpqUpSgtXFbiOTlMihNqcg6RbCqQmewx7cXJE) document for IP address and ports. 
abstract class UdpSocket extends Service {
	/// The port to listen on and send to.
	/// 
	/// Each program gets its own port, so the dashboard socket that listens for autonomy data
	/// uses the same port as the actual autonomy program running on the server.
	final int listenPort;

	/// The UDP socket backed by `dart:io`.
	/// 
	/// This socket must be closed in [dispose].
	late RawDatagramSocket _socket;

	/// The subscription that listens for incoming data.
	/// 
	/// This must be cancelled in [dispose].
	late StreamSubscription _subscription;

	/// The socket to send to.
	SocketConfig? destination;

	/// Opens a UDP socket on the given port.
	UdpSocket({required this.listenPort, this.destination});

	@override
	Future<void> init() async {
		_socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, listenPort);
		_subscription = _socket.listenForData(onData);
	}

	@override
	Future<void> dispose() async {
		await _subscription.cancel();
		_socket.close();
	}

	/// Resets the socket in case of an unrecoverable error.
	Future<void> reset() async {
		await dispose();
		await init();
	}

	/// Runs when new data is received.
	/// 
	/// Override this to do something with the incoming bytes. Typically you'd want to
	/// parse them into some other useful format, such as Protobuf messages. 
	/// 
	/// According to the documentation for [RawDatagramSocket.receive], the maximum size
	/// of a packet is 65503 bytes, just shy of 2^16 bytes.
	void onData(List<int> data);

	/// Sends [bytes] to the [destination].
	void sendBytes(List<int> bytes) {
		// [!]: The [destination] field is updated in the Sockets model.
		_socket.send(bytes, destination!.address, destination!.port);
	}
}
