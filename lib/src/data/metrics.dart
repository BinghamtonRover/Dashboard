abstract class Metrics {
	const Metrics();
	List<String> get allMetrics;
}

class PersistentMetrics extends Metrics {
	final double temp1, temp2;
	final double current1, current2;
	final double voltage1, voltage2;
	const PersistentMetrics(this.temp1, this.temp2, this.current1, this.current2, this.voltage1, this.voltage2);

	@override
	List<String> get allMetrics => [
		"Temperatures: $temp1 °F and $temp2 °F",
		"Currents: $current1 A and $current2 A",
		"Voltage: $voltage1 V and $voltage2 V",
	];
}

class ScienceMetrics extends Metrics {
	final double temperature;
	final double methaneConcentration;
	final double co2Concentration;
	final double ph;
	final double humidity;
	const ScienceMetrics(this.temperature, this.methaneConcentration, this.co2Concentration, this.ph, this.humidity);

	@override
	List<String> get allMetrics => [
		"Temperature: $temperature °F",
		"Methane concentration: $methaneConcentration ppb",
		"CO2 concentration: $co2Concentration ppm",
		"pH: $ph",
		"Relative humidity: $humidity%",
	];
}

const samplePMetrics = PersistentMetrics(91.2, 93.7, 12, 9, 12, 5.5);
const sampleSMetrics = ScienceMetrics(71.8, 15.3, 410, 6.5, 63);
