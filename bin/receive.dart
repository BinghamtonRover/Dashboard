import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/services.dart";

void electricalHandler(ElectricalData data) => print("The battery is ${data.batteryVoltage}V");

Future<void> main() async {
	final receiver = MessageReceiver();
	await receiver.init();
	print("Listening on ${port}");

	receiver.registerHandler<ElectricalData>(
		name: "ElectricalData",
		decoder: ElectricalData.fromBuffer,
		handler: electricalHandler,
	);
}
