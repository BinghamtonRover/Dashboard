import "package:protobuf/protobuf.dart";
import "package:rover_dashboard/data.dart";
/// A readout of metrics reported by one of the rover's subsystems. 
/// 
/// To use this class, create a subclass that extends this class with [T] as the generated 
/// Protobuf class. For example, to create metrics for the science subsystem, use:
/// ```dart
/// class ScienceMetrics extends Metrics<ScienceMessage> { }
/// ```
abstract class Metrics<T extends GeneratedMessage> {
	/// The underlying data used to get these metrics.
	final T data;

	/// A const constructor for metrics.
	const Metrics(this.data);

	/// A collective name for this group of metrics (usually the name of the subsystem).
	String get name;

	/// A list of user-friendly explanations for each of the metrics.
	/// 
	/// Be sure to store the actual values as fields. This property should be a list of one 
	/// user-friendly explanation per metric. 
	List<String> get allMetrics;
}

/// Metrics reported by the electrical control board. 
/// 
/// These metrics represent the vitals of the rover: basics like voltage, current, and temperature
/// of the various electrical components. These values aren't useful for the missions, but should
/// be monitored to catch problems before they cause damage to the rover. 
class ElectricalMetrics extends Metrics<Electrical> {
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

/// Metrics reported by the science subsystem. 
/// 
/// These metrics represent analysis of dirt samples extracted by the science subsystem. They need
/// to not only be recorded but logged as well so the science team can generate charts out of it.
// class ScienceMetrics extends Metrics<ScienceMessage> { }