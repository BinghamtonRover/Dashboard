import "package:rover_dashboard/data.dart";

/// Metrics reported by the science subsystem. 
/// 
/// These metrics represent analysis of dirt samples extracted by the science subsystem. They need
/// to not only be recorded but logged as well so the science team can generate charts out of it.
class ScienceMetrics extends Metrics<ScienceData> {
	/// A collection of metrics relevant for monitoring the rover's electrical status.
	ScienceMetrics() : super(ScienceData());

	@override
	String get name => "Science";

	@override
	List<String> get allMetrics => [  
		"Methane: ${data.methane.toStringAsFixed(3)}",
		"CO2: ${data.co2.toStringAsFixed(3)}",
		"Temperature: ${data.temperature.toStringAsFixed(3)}",
		"Humidity: ${data.humidity.toStringAsFixed(3)}",
		"pH: ${data.pH.toStringAsFixed(3)}"
	];

	@override
	void update(ScienceData data){
		if(data.state == ScienceState.STOP_COLLECTING){
			return;
		}
		super.update(data);
	}
}
