import "package:rover_dashboard/data.dart";

typedef ScienceTest = ScienceResult Function(SampleData);

/// The result of a science test.
enum ScienceResult {
	/// There was never life in this ecosystem.
	extinct, 

	/// There is currently life in this ecosystem.
	extant, 

	/// There used to be life in this ecosystem, but not anymore.
	notPresent, 

	/// This test cannot determine the precense of life.
	inconclusive, 

	/// This test is awaiting more data.
	loading,
}

class SensorReading {
	final double time;
	final double value;

	const SensorReading({required this.time, required this.value});
}

class ScienceSensor {
	final String name;
	final ScienceTest test;
	final String testDescription;
	const ScienceSensor({
		required this.name, 
		required this.test,
		required this.testDescription
	});
}

/// Stores all the readings of one sensor for one sample.
class SampleData {
	final List<SensorReading> readings = [];
	Timestamp? firstTimestamp;
	double? min, average, max;
	double sum = 0;
	int count = 0;

	void addReading(Timestamp timestamp, double value) {
		firstTimestamp ??= timestamp;
		readings.add(SensorReading(time: timestamp - firstTimestamp!, value: value));
		if (min == null || value < min!) min = value;
		if (max == null || value > max!) max = value;
		sum += value;
		count++;
		average = sum / count;
	}

	void clear() {
		readings.clear();
		firstTimestamp = null;
		min = average = max = null;
	}
}

extension on Timestamp {
	double operator -(Timestamp other) => (seconds - other.seconds).toDouble();
}

ScienceResult temperatureTest(SampleData data) => (data.average! > -15 && data.average! < 122)
	? ScienceResult.extinct : ScienceResult.inconclusive;

ScienceResult humidityTest(SampleData data) => ScienceResult.inconclusive;

ScienceResult pHTest(SampleData data) => (data.average! > 3 && data.average! < 12) 
	? ScienceResult.extant : ScienceResult.inconclusive;

ScienceResult co2Test(SampleData data) => (data.max! > 409.9) 
	? ScienceResult.extant : ScienceResult.inconclusive;

ScienceResult methaneTest(SampleData data) => (data.max! > 0) 
	? ScienceResult.extant : ScienceResult.inconclusive;

const temperature = ScienceSensor(
	name: "Temperature", 
	test: temperatureTest,
	testDescription: "Average temperature between -15°C and 122°C: Extinct",
);
const humidity = ScienceSensor(
	name: "Humidity", 
	test: humidityTest,
	testDescription: "No test available",
);
const pH = ScienceSensor(
	name: "pH", 
	test: pHTest,
	testDescription: "Average between 3 and 12 -> Extant",
);
const co2 = ScienceSensor(
	name: "CO2", 
	test: co2Test,
	testDescription: "CO2 above 409.8: Extant",
);
const methane = ScienceSensor(
	name: "Methane", 
	test: methaneTest,
	testDescription: "Any methane: Extant",
);
const sensors = [temperature, humidity, pH, co2, methane];
