import "package:rover_dashboard/data.dart";

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
	List<String> get allMetrics => [
		"Swivel: ${data.swivel}",
		"Tilt: ${data.tilt}",
		"Teensy: ${data.status.humanName}",
		"GPS:",
		"  Latitude: ${data.coordinates.latitude}",
		"  Longitude: ${data.coordinates.longitude}",
		"  Altitude: ${data.coordinates.altitude}",
	];

	void clearStatus() {
		data.clearStatus();
		notifyListeners();
	}
}
