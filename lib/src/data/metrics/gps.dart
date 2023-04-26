import "package:rover_dashboard/data.dart";


/// Metrics reported by the GPS.
/// 
/// These metrics represent the location of the rover: latitude, longitude, and altitude.
/// These values are used for navigation and positioning the rover.
class GpsMetrics extends Metrics<GpsCoordinates> {
  /// A collection of metrics relevant for monitoring the rover's GPS location.
  GpsMetrics() : super(GpsCoordinates());

	@override
	String get name => "GPS";

	@override
	List<String> get allMetrics => [  
    "Latitude: ${data.latitude}",
		"Longitude: ${data.longitude}",
		"Altitude: ${data.altitude}",
    // "Distance to base stattion: ${distanceTo(data.baseStation)}",
	];
}
