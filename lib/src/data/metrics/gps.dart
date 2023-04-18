import "dart:math";
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
	];
  
  /// Calculate Euclidean distance between current coordinates and another set of coordinates
  double distanceTo(GpsCoordinates other) => pow(pow(data.latitude - other.latitude, 2) + pow(data.longitude - other.longitude, 2) + pow(data.altitude - other.altitude, 2), 0.5).toDouble();
}