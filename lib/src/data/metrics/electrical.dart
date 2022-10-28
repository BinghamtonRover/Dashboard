import "package:rover_dashboard/data.dart";

/// Metrics reported by the electrical control board. 
/// 
/// These metrics represent the vitals of the rover: basics like voltage, current, and temperature
/// of the various electrical components. These values aren't useful for the missions, but should
/// be monitored to catch problems before they cause damage to the rover. 
class ElectricalMetrics extends Metrics<ElectricalData> {
	/// A collection of metrics relevant for monitoring the rover's electrical status.
	const ElectricalMetrics(super.data);

	@override
	String get name => "Electrical";

	// TODO: implement this
	@override
	List<String> get allMetrics => [  
		"Battery: ${data.batteryVoltage} V, ${data.batteryCurrent} A",
		"12V supply: ${data.v12SupplyVoltage} V, ${data.v12SupplyCurrent} A, ${data.v12SupplyTemperature} °F",
		"5V supply: ${data.v5SupplyVoltage} V, ${data.v5SupplyCurrent} A, ${data.v5SupplyTemperature} °F",
		"ODrives: ${data.odrive0Current} A, ${data.odrive1Current} A, ${data.odrive2Current} A",
	];
}
