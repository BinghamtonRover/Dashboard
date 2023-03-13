// ignore_for_file: avoid_print

import "package:rover_dashboard/services.dart";

const int receivePort = 8001;
const int sendPort = 8002;

class TestSocket extends UdpSocket {
	TestSocket({required super.port});

	@override
	void onData(List<int> bytes) => print("Received: $bytes");
}

void main() async {
	final server = TestSocket(port: 8001);
	await server.init();
	print("Listening on :$receivePort");
}
