// ignore_for_file: avoid_print

import "dart:io";
import "package:rover_dashboard/services.dart";

const int remotePort = 8001;
const int localPort = 8002;
final address = InternetAddress("192.168.1.20");

class TestSocket extends UdpSocket {
	TestSocket({required super.port});

	@override
	void onData(List<int> data) => print(data);
}

void main() async {
	final client = TestSocket(port: localPort);
	await client.init();

	client.sendBytes(address: address, port: remotePort, bytes: [1, 2, 3]);
	await Future.delayed(const Duration(milliseconds: 200));
	client.sendBytes(address: address, port: remotePort, bytes: [4, 5, 6]);
	await Future.delayed(const Duration(milliseconds: 200));
	client.sendBytes(address: address, port: remotePort, bytes: [7, 8, 9]);
	
	await client.dispose();
	print("Done");
}
