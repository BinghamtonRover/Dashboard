import "package:rover_dashboard/data.dart";

/// Metrics reported by the drive subsystem.
/// 
/// In the future, the drive Teensy will have a GPS and IMU to read [RoverPosition] data. For now,
/// this information is sent separately and is represented by its own [RoverPosition] object because
/// they are collected on the Pi. In the future, when they are moved to the Drive subsystem, this
/// data should still be kept separate so as to make it easier to show in the UI and send to MARS.
class DriveMetrics extends Metrics<DriveData> {
	/// A collection of metrics relevant for monitoring the rover's electrical status.
	DriveMetrics() : super(DriveData());

	@override
	String get name => "Drive";

	@override
	List<String> get allMetrics => [  
		"Throttle: ${data.throttle.toStringAsFixed(2)}",
		"Left: ${data.left.toStringAsFixed(2)}",
		"Right: ${data.right.toStringAsFixed(2)}",
		"Left sensor: ${data.leftSensorValue.toStringAsFixed(2)}",
		"Right sensor: ${data.rightSensorValue.toStringAsFixed(2)}",
	];

	@override
	void update(DriveData value) {
		// Since the newValues are often zero, [Metrics.merge] won't work.
		if (value.setLeft) data.left = value.left;
		if (value.setRight) data.right = value.right;
		if (value.setThrottle) data.throttle = value.throttle;
		if (value.leftSensorValue != 0) data.leftSensorValue = value.leftSensorValue;
		if (value.rightSensorValue!= 0) data.rightSensorValue = value.rightSensorValue;
		notifyListeners();
	}
}
