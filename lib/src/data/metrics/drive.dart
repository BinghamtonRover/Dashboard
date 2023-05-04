import "package:rover_dashboard/data.dart";

/// Metrics reported by the drive subsystem.
/// 
/// In the future, the drive Teensy will have a GPS and IMU to read [RoverPosition] data. For now,
/// this information is sent separately and is represented by its own [RoverMetrics] object because
/// they are collected on the Pi. In the future, when they are moved to the Drive subsystem, this
/// data should still be kept separate so as to make it easier to show in the UI and send to MARS.
class DriveMetrics extends Metrics<DriveData> {
	/// A collection of metrics relevant for monitoring the rover's electrical status.
	DriveMetrics() : super(DriveData());

	@override
	String get name => "Drive";

	@override
	List<String> get allMetrics => [  
		"Throttle: ${data.throttle}",
		"Left: ${data.left}",
		"Right: ${data.right}",
	];
}
