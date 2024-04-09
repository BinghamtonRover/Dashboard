import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// Metrics reported by the MARS subsystem.
/// 
/// The MARS subsystem tracks the rover's position and orients the unidirectional antenna to face
/// the rover for a better signal. These metrics are used to track the subsystem's accuracy and
/// visualize its movements. 
class MarsMetrics extends Metrics<MarsData> {
	/// A collection of metrics relevant for monitoring the MARS subsystem.
	MarsMetrics() : super(MarsData());

	@override
	String get name => "MARS";

	@override
	List<MetricLine> get allMetrics => [
		MetricLine("Swivel: ${data.swivel}", severity: Severity.error,),
		MetricLine("Tilt: ${data.tilt}", severity: Severity.error,),
		MetricLine("Teensy: ${data.status.humanName}", severity: Severity.error,),
		// "GPS:",
		MetricLine("  Latitude: ${data.coordinates.latitude}", severity: Severity.error,),
		MetricLine("  Longitude: ${data.coordinates.longitude}", severity: Severity.error,),
		MetricLine("  Altitude: ${data.coordinates.altitude}", severity: Severity.error,),
	];

	/// Clears [MarsData.status], because the Teensy cannot be observed when the Pi is disconnected.
	void clearStatus() {
		data.clearStatus();
		notifyListeners();
	}

	@override
	void update(MarsData value) {
		super.update(value);
		models.rover.metrics.position.baseStation = data.coordinates;
	}
}
