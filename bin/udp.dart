import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/services.dart";

void electricalHandler(ElectricalData data) { print(data.batteryVoltage); }

Future<void> main() async {
	final receiver = MessageReceiver();
	final sender = MessageSender();
	await receiver.init();
	await sender.init();

	receiver.registerHandler<ElectricalData>(
		name: "Electrical",
		decoder: ElectricalData.fromBuffer,
		handler: electricalHandler,
	);

	await sender.sendMessage(ElectricalData(
		batteryVoltage: 24,
	));
}
