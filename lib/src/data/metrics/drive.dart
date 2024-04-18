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
	List<MetricLine> get allMetrics => [  
		MetricLine("Throttle: ${data.throttle.toStringAsFixed(2)}"),
		MetricLine("Left: ${data.left.toStringAsFixed(2)}"),
		MetricLine("Right: ${data.right.toStringAsFixed(2)}"),
    MetricLine("Battery: ${data.batteryVoltage.toStringAsFixed(2)}V, ${data.batteryCurrent.toStringAsFixed(2)}A, ${data.batteryTemperature.toStringAsFixed(2)}°F"),

	];

	@override
	void update(DriveData value) {
		// Since the newValues are often zero, [Metrics.merge] won't work.
		if (value.setLeft) data.left = value.left;
		if (value.setRight) data.right = value.right;
		if (value.setThrottle) data.throttle = value.throttle;
    if (value.hasBatteryCurrent()) data.batteryCurrent = value.batteryCurrent;
    if (value.hasBatteryVoltage()) data.batteryVoltage = value.batteryVoltage;
    if (value.hasBatteryTemperature()) data.batteryTemperature = value.batteryTemperature;
		notifyListeners();
	}

  /// The battery voltage.
  double get battery => data.batteryVoltage;
}
