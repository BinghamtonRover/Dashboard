import "dart:io";

import "service.dart";

export "dart:io" show InternetAddress;

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
/// This class uses `dart:io`'s [RawDatagramSocket] to open a UDP connection. Call
/// [init] before using any methods, and call [dispose] when finished to close the 
/// socket. Use [sendBytes] to send raw data to a server. Override this class to 
/// define more custom methods, like `sendMessage` or `sendFrame`. 
/// 
/// See the [Network Address Assignments](https://docs.google.com/document/d/1U6GxcYGpqUpSgtXFbiOTlMihNqcg6RbCqQmewx7cXJE) document for IP address and ports. 
class UdpClient extends Service {
	/// The port to send through.
	final int listenPort;

	/// The `dart:io` backing for this socket.
	/// 
	/// This socket must be closed in [dispose]. 
	late final RawDatagramSocket _socket;

	/// Opens a UDP socket that listens to the given port.
	UdpClient({required this.listenPort});

	@override
	Future<void> init() async {
		_socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, listenPort);
	}

	@override
	Future<void> dispose() async {
		_socket.close();
	}

	/// Resets the connection by closing and reopening the socket.
	Future<void> reset() async {
		await dispose();
		await init();
	}

	/// Sends [bytes] to the given [address] at [port]. 
	void sendBytes({
		required InternetAddress address, 
		required int port, 
		required List<int> bytes
	}) => _socket.send(bytes, address, port);
}
