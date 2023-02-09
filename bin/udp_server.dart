// ignore_for_file: avoid_print

import "package:rover_dashboard/services.dart";

const int receivePort = 8008;
const int sendPort = 8002;

class RawServer extends UdpServer {
	RawServer() : super(port: receivePort);

	@override
	void onData(List<int> bytes) => print("Received: $bytes");
}

void main() async {
	final server = RawServer();
	await server.init();
	print("Listening on :$receivePort");
}
