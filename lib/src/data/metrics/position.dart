import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// Metrics about the rover's position and orientation.
/// 
/// For simplicity, these metrics also track the first recorded GPS position as the base station.
class PositionMetrics extends Metrics<RoverPosition> {
  /// A collection of metrics relevant for monitoring the rover's GPS location.
  PositionMetrics() : super(RoverPosition());

	@override
	String get name => "Position";

	/// A helper for [baseStation].
	GpsCoordinates? _baseStation;

	/// The position of the base station. Setting this value updates the UI.
	/// 
	/// Defaults to [RoverPosition.gps] until the MARS subsystem comes online (see [MarsData.coordinates]).
	GpsCoordinates get baseStation => _baseStation ?? data.gps;
	set baseStation(GpsCoordinates value) { 
		_baseStation = value;
		notifyListeners();
	}

	@override
	List<String> get allMetrics => [  
    "GPS: ",
    "  Latitude: ${data.gps.latitude.toStringAsFixed(2)}°",
		"  Longitude: ${data.gps.longitude.toStringAsFixed(2)}°",
		"  Altitude: ${data.gps.altitude.toStringAsFixed(2)} m",
		"Orientation: ${data.orientation.y.toStringAsFixed(2)} ° of N",
    "Distance: ${data.gps.distanceTo(baseStation).toStringAsFixed(2)} m",
	];

	@override
	void update(RoverPosition value) {
		super.update(value);
		models.sockets.mars.sendMessage(MarsCommand(rover: value.gps));
	}
}
