import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/services.dart";

Future<void> main(List<String> args) async {
	final sender = MessageSender();
	await sender.init();

	final double voltage = args.isEmpty ? 24 : (double.tryParse(args.first) ?? 12);
	final data = ElectricalData(batteryVoltage: voltage);
	await sender.send(data);
}
