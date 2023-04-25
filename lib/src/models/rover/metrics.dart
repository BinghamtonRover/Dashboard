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
  final gps = GpsMetrics();

	/// A list of all the metrics to iterate over.
	///
	/// NOTE: Keep this as a getter, NOT a field. If this is made a field, then it won't update
	/// when new data is received. As a getter, every time it is called it will use new data.
	List<Metrics> get allMetrics => [electrical, science, gps];

	/// Returns a function that updates a [Metrics] object and reloads the UI.
	void Function(T) update<T extends Message>(Metrics<T> metrics) => (T data) {
		metrics.update(data);
		notifyListeners();
    services.files.logData(data);
	};

	@override
	Future<void> init() async {
    Timer.periodic(
      const Duration(seconds: 2), 
      (refresh) {
        //smth
      }
    );
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
    services.dataSocket.registerHandler<GpsCoordinates>(
			name: GpsCoordinates().messageName,
			decoder: GpsCoordinates.fromBuffer,
			handler: update(gps),
		);
	}
}
