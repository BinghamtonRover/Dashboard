import "package:rover_dashboard/data.dart";

/// Metrics reported by the electrical control board. 
/// 
/// These metrics represent the vitals of the rover: basics like voltage, current, and temperature
/// of the various electrical components. These values aren't useful for the missions, but should
/// be monitored to catch problems before they cause damage to the rover. 
class ElectricalMetrics extends Metrics<ElectricalData> {
	/// A collection of metrics relevant for monitoring the rover's electrical status.
	ElectricalMetrics() : super(ElectricalData());

	@override
	String get name => "Electrical";

	@override
	List<String> get allMetrics => [  
		"Battery: ${data.batteryVoltage.toStringAsPrecision(2)}V, ${data.batteryCurrent.toStringAsPrecision(2)}A, ${data.batteryTemperature}°F",
	];

  /// The voltage of the battery.
  double get batteryVoltage => data.batteryVoltage;
  /// The charge of the battery, as a percentage.
  double get batteryPercentage => (batteryVoltage - 24) / 6;  // 24-30 as a percentage
}
