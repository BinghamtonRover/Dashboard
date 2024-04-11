import "package:rover_dashboard/data.dart";

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
	List<MetricLine> get allMetrics => [  
    MetricLine("GPS: "),
    MetricLine("  Latitude: ${data.gps.latitude.toStringAsFixed(6)}°",),
		MetricLine("  Longitude: ${data.gps.longitude.toStringAsFixed(6)}°",),
		MetricLine("  Altitude: ${data.gps.altitude.toStringAsFixed(2)} m"),
		MetricLine("Orientation:",),
		MetricLine("  X: ${data.orientation.x.toStringAsFixed(2)}°",),
		MetricLine("  Y: ${data.orientation.y.toStringAsFixed(2)}°",),
		MetricLine("  Z: ${data.orientation.z.toStringAsFixed(2)}°",),
    MetricLine("Distance: ${data.gps.distanceTo(baseStation).toStringAsFixed(2)} m",),
	];

	@override
	void update(RoverPosition value) {
		final oldOrientation = data.orientation.deepCopy();
		super.update(value);
		if(data.orientation.x > 360 || data.orientation.x < -360){
			data.orientation.x = oldOrientation.x;
			notifyListeners();
		}
		if(data.orientation.y > 360 || data.orientation.y < -360){
			data.orientation.y = oldOrientation.y;
			notifyListeners();
		}
		if(data.orientation.z > 360 || data.orientation.z < -360){
			data.orientation.z = oldOrientation.z;
			notifyListeners();
		}		
	}

	/// The angle to orient the rover on the top-down map.
	double get angle => data.orientation.z;
}
