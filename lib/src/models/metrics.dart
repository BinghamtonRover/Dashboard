import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/services.dart";

import "model.dart";

/// A data model that listens for updated data and provides [Metrics] to the UI.
class MetricsModel extends Model {
	/// Electrical data.
	ElectricalMetrics? electrical;

	/// A list of all the metrics to iterate over. 
	/// 
	/// NOTE: Keep this as a getter, NOT a field. If this is made a field, then it won't update
	/// when new data is received. As a getter, every time it is called it will use new data.
	List<Metrics?> get allMetrics => [electrical];

	@override
	Future<void> init() async {
		services.messageReceiver.registerHandler<ElectricalData>(
			name: ElectricalData().messageName, 
			decoder: ElectricalData.fromBuffer,
			handler: (data) { electrical = ElectricalMetrics(data); notifyListeners(); }
		);

		electrical = ElectricalMetrics(ElectricalData(
			batteryVoltage: 25, 
			batteryCurrent: 3
		));
		notifyListeners();
	}
}
