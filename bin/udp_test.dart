// ignore_for_file: avoid_print

import "package:rover_dashboard/services.dart";

const int receivePort = 8001;
final address = InternetAddress("192.168.1.20");

class TestSocket extends UdpSocket {
	TestSocket({required super.port});

	@override
	void onData(List<int> bytes) => print("Received: $bytes");
}

void main() async {
	final socket = TestSocket(port: 8001);
	await socket.init();
	print("Listening on :$receivePort");

	print("Sending messages");
	socket.sendBytes(address: address, port: 8001, bytes: [1, 2, 3]);
	await Future.delayed(const Duration(milliseconds: 200));
	socket.sendBytes(address: address, port: 8001, bytes: [4, 5, 6]);
	await Future.delayed(const Duration(milliseconds: 200));
	socket.sendBytes(address: address, port: 8001, bytes: [7, 8, 9]);

	await Future.delayed(const Duration(seconds: 1));
	await socket.dispose();
}
