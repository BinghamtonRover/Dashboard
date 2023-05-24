import "package:rover_dashboard/data.dart";

class MarsMetrics extends Metrics<MarsData> {
	MarsMetrics() : super(MarsData());

	@override
	String get name => "MARS";

	@override
	List<String> get allMetrics => [
		"Swivel: ${data.swivel}",
		"Tilt: ${data.tilt}",
		"GPS:",
		"  Latitude: ${data.coordinates.latitude}",
		"  Longitude: ${data.coordinates.longitude}",
		"  Altitude: ${data.coordinates.altitude}",
	];
}
