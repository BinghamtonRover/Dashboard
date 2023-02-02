import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/services.dart";

final data = ElectricalData(batteryVoltage: 12);

void main() async {
	final client = MessageSender();
	await client.init();
	client.sendMessage(data, address: InternetAddress("192.168.1.20"), port: 8001);
}
