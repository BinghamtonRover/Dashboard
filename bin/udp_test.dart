// ignore_for_file: avoid_print

import "package:rover_dashboard/services.dart";

const int receivePort = 8001;
const int sendPort = 8002;

class RawServer extends UdpServer {
	RawServer() : super(port: receivePort);

	@override
	void onData(List<int> bytes) => print("Received: $bytes");
}

void main() async {
	final server = RawServer();
	final client = UdpClient(listenPort: sendPort);
	await server.init();
	await client.init();

	client.sendBytes(address: InternetAddress.loopbackIPv4, port: receivePort, bytes: [1, 2, 3]);

	await Future.delayed(const Duration(milliseconds: 500));

	await server.dispose();
	await client.dispose();
	print("Done");
}
