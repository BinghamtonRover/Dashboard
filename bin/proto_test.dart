// ignore_for_file: avoid_print

import "dart:io";
import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/services.dart";

final address = InternetAddress.loopbackIPv4;

Future<void> main() async {
	final server = ProtoSocket(
		listenPort: 8000, 
		destination: SocketConfig(InternetAddress.loopbackIPv4, 8001)
	);

	final client = ProtoSocket(
		listenPort: 8001, 
		destination: SocketConfig(address, 8000)
	);

	await server.init();
	await client.init();

	server.registerHandler<Connect>(
		name: Connect().messageName,
		decoder: Connect.fromBuffer,
		handler: (data) {
			print("Received a connect message from ${data.sender}");
			server.sendMessage(Connect(sender: data.receiver, receiver: data.sender));
		}
	);

	client.registerHandler<Connect>(
		name: Connect().messageName,
		decoder: Connect.fromBuffer,
		handler: (data) {
			print("Received a response from ${data.sender}");
		}
	);

	client.sendMessage(Connect(sender: Device.DASHBOARD, receiver: Device.SUBSYSTEMS));

	await Future.delayed(const Duration(milliseconds: 500));
	await server.dispose();
	await client.dispose();
}
