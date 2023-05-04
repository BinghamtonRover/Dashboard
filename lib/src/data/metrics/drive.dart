import "package:rover_dashboard/data.dart";

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
