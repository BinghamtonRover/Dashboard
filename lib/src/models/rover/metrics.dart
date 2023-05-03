import "dart:async";
import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/services.dart";

import "../model.dart";

/// A data model that listens for updated data and provides [Metrics] to the UI.
class RoverMetrics extends Model {
	/// Data about the rover's core vitals.
	final electrical = ElectricalMetrics();

	/// Data from the science subsystem.
	final science = ScienceMetrics();

  /// Data from the GPS.
  final position = PositionMetrics();

	/// A list of all the metrics to iterate over.
	///
	/// NOTE: Keep this as a getter, NOT a field. If this is made a field, then it won't update
	/// when new data is received. As a getter, every time it is called it will use new data.
	List<Metrics> get allMetrics => [electrical, science, position];

	/// Returns a function that updates a [Metrics] object and reloads the UI.
	void Function(T) update<T extends Message>(Metrics<T> metrics, {bool sendToMars = false}) => (data) {
		metrics.update(data);
		notifyListeners();
    services.files.logData(data);
    if (sendToMars) services.marsSocket.sendMessage(data);
	};

	@override
	Future<void> init() async {
		services.dataSocket.registerHandler<ElectricalData>(
			name: ElectricalData().messageName,
			decoder: ElectricalData.fromBuffer,
			handler: update(electrical),
		);
		services.dataSocket.registerHandler<ScienceData>(
			name: ScienceData().messageName,
			decoder: ScienceData.fromBuffer,
			handler: update(science),
		);
    services.dataSocket.registerHandler<RoverPosition>(
			name: RoverPosition().messageName,
			decoder: RoverPosition.fromBuffer,
			handler: update(position, sendToMars: true),
		);
	}
}
