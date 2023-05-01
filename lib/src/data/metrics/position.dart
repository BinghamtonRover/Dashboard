import "package:rover_dashboard/data.dart";

/// Metrics about the rover's position and orientation.
/// 
/// For simplicity, these metrics also track the first recorded GPS position as the base station.
class PositionMetrics extends Metrics<RoverPosition> {
  /// A collection of metrics relevant for monitoring the rover's GPS location.
  PositionMetrics() : super(RoverPosition());

	@override
	String get name => "Position";

	@override
	List<String> get allMetrics => [  
    "Latitude: ${data.gps.latitude}",
		"Longitude: ${data.gps.longitude}",
		"Altitude: ${data.gps.altitude}",
		"Orientation: ${data.orientation.y}",
    "Distance to base stattion: ${data.gps.distanceTo(data.baseStation)}",
	];
}
