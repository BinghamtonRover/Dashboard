// ignore_for_file: avoid_print

import "package:rover_dashboard/services.dart";

const int receivePort = 8001;
const int sendPort = 8002;
final address = InternetAddress("192.168.1.20");

void main() async {
	final client = UdpClient(listenPort: sendPort);
	await client.init();

	print("Sending");
	int bytes = 0;
	bytes += client.sendBytes(address: address, port: receivePort, bytes: [1, 2, 3]);
	await Future.delayed(const Duration(milliseconds: 200));
	bytes += client.sendBytes(address: address, port: receivePort, bytes: [4, 5, 6]);
	await Future.delayed(const Duration(milliseconds: 200));
	bytes += client.sendBytes(address: address, port: receivePort, bytes: [7, 8, 9]);
	print("Sent $bytes bytes");
	
	await client.dispose();
	print("Done");
}
