import 'package:rover_dashboard/data.dart';

import "model.dart";
import "package:rover_dashboard/services.dart";

/// Handles incoming data about the vitals of the rover, like voltage, power and temperature.
class Vitals extends Model {
	/// The temperature of the rover, in degrees F.
	int temperature = 0;
  ElectricalMetrics? metrics;

	@override
	Future<void> init() async {
		// Subscribe to ElectricalMessages using the MessageReceiver service. 
		// When a new message arrives, update the relevant fields and call [notifyListeners].
    services.messageReceiver.registerHandler(name: ElectricalData().messageName, decoder: ElectricalData.fromBuffer, handler: messageHandler);
	}

  void messageHandler(ElectricalData data) {
    metrics = ElectricalMetrics(data);
    notifyListeners();
  }

	@override 
	Future<void> dispose() async {
		// Cancel the subscription.
    // TODO: services.messageReceiver.removeListener
		super.dispose();
	}
}
