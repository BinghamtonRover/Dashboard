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
	List<MetricLine> get allMetrics => [  
		MetricLine("Methane: ${data.methane.toStringAsFixed(3)}",
    severity: Severity.error,),
		MetricLine("CO2: ${data.co2.toStringAsFixed(3)}",
    severity: Severity.error,),
		MetricLine("Temperature: ${data.temperature.toStringAsFixed(3)}", severity: Severity.error,),
		MetricLine("Humidity: ${data.humidity.toStringAsFixed(3)}",
    severity: Severity.error,),
		MetricLine("pH: ${data.pH.toStringAsFixed(3)}",
    severity: Severity.error,),
	];

	@override
	void update(ScienceData value){
		if (value.state == ScienceState.STOP_COLLECTING) return;
		super.update(value);
	}
}
