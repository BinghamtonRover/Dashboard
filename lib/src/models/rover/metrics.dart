import "dart:async";
import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";

/// A data model that listens for updated data and provides [Metrics] to the UI.
class RoverMetrics extends Model {
	/// Data about the rover's core vitals.
	final electrical = ElectricalMetrics();

	/// Data from the science subsystem.
	final science = ScienceMetrics();

  /// Data from the GPS.
  final position = PositionMetrics();

  /// Data from the drive subsystem.
  final drive = DriveMetrics();

  final mars = MarsMetrics();

	/// A list of all the metrics to iterate over.
	///
	/// NOTE: Keep this as a getter, NOT a field. If this is made a field, then it won't update
	/// when new data is received. As a getter, every time it is called it will use new data.
	List<Metrics> get allMetrics => [position, mars, electrical, drive, science];

	/// Updates the [metrics] object, updates the UI, and saves [data] to a file.
	void update<T extends Message>(Metrics<T> metrics, T data) {
		metrics.update(data);
		services.files.logData(data);
	}

	@override
	Future<void> init() async {
		models.sockets.data.registerHandler<ElectricalData>(
			name: ElectricalData().messageName,
			decoder: ElectricalData.fromBuffer,
			handler: (data) => update(electrical, data),
		);
		models.sockets.data.registerHandler<DriveData>(
			name: DriveData().messageName,
			decoder: DriveData.fromBuffer,
			handler: (data) {
				// Since the values are often zero, [Metrics.merge] won't work.
				if (data.setLeft) drive.data.left = data.left;
				if (data.setRight) drive.data.right = data.right;
				if (data.setThrottle) drive.data.throttle = data.throttle;
				notifyListeners();
			},
		);
		models.sockets.data.registerHandler<ScienceData>(
			name: ScienceData().messageName,
			decoder: ScienceData.fromBuffer,
			handler: (data) => update(science, data),
		);
    models.sockets.data.registerHandler<RoverPosition>(
			name: RoverPosition().messageName,
			decoder: RoverPosition.fromBuffer,
			handler: (data) {
				update(position, data);
				models.sockets.mars.sendMessage(MarsCommand(rover: data.gps));
			},
		);
		models.sockets.data.registerHandler<MarsData>(
			name: MarsData().messageName,
			decoder: MarsData.fromBuffer,
			handler: (data) {
				update(mars, data);
				position.baseStation = data.coordinates;
			},
		);
	}
}
