import "package:rover_dashboard/data.dart";

/// The current power status of the rover.
enum RoverStatus {
	/// The rover is not connected, or is in some other unknown state.
	disconnected, 

	/// The rover is in standby mode and is not accepting new commands.
	standby, 

	/// The rover is in active mode and can operate normally.
	active
}

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
		"Battery: ${data.batteryVoltage}V, ${data.batteryCurrent}A, ${data.batteryTemperature}°F",
		"12V supply: ${data.v12Voltage}V, ${data.v12Current}A, ${data.v12Temperature}°F",
		"5V supply: ${data.v5Voltage}V, ${data.v5Current}A, ${data.v5Temperature}°F",
	];

	/// Shorthand for accessing the battery.
	double get battery => data.batteryVoltage;

	/// The state of the rover. 
	RoverStatus get status {
		switch (PowerMode.ACTIVE) {  // TODO: replace with actual mode
			case PowerMode.POWER_MODE_UNDEFINED: return RoverStatus.disconnected;
			case PowerMode.IDLE: return RoverStatus.standby;
			case PowerMode.ACTIVE: return RoverStatus.active;
			default: throw ArgumentError("Unrecognized power mode");  // TODO: Use actual value
		}
	}
}
