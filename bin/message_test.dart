// ignore_for_file: avoid_print

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/services.dart";

Future<void> main(List<String> args) async {
	// Initialize client and server
	final sender = MessageSender();
	final receiver = MessageReceiver(port: 8001);
	await sender.init();
	await receiver.init();

	// Tell the receiver we want to listen for [ElectricalData] messages
	receiver.registerHandler<ElectricalData>(
		name: ElectricalData().messageName,
		decoder: ElectricalData.fromBuffer,
		handler: (data) => print("The battery is ${data.batteryVoltage}V"),
	);

	// Send a test message to localhost:8001
	final data = ElectricalData(batteryVoltage: 24);
	sender.sendMessage(data, address: InternetAddress.loopbackIPv4, port: 8001);
	await Future.delayed(const Duration(milliseconds: 500));  // small delay

	// Cleanup
	await sender.dispose();
	await receiver.dispose();
	print("Done");
}
