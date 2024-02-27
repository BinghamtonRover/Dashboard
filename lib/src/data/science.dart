import "package:rover_dashboard/data.dart";

/// A function that determines the presence of life based on sensor data.
typedef ScienceTest = ScienceResult Function(SampleData);

/// The result of a science test.
enum ScienceResult {
	/// There was never life in this ecosystem.
	extinct, 

	/// There is currently life in this ecosystem.
	extant, 

	/// There used to be life in this ecosystem, but not anymore.
	notPresent, 

	/// This test cannot determine the presence of life.
	inconclusive, 

	/// This test is awaiting more data.
	loading,
}

/// A sensor reading with a timestamp.
class SensorReading {
	/// The time this reading was taken, relative to the first reading.
	final double time;

	/// The value from the sensor.
	final double value;

	/// A const constructor.
	const SensorReading({required this.time, required this.value});
}

/// A sensor in the science subsystem.
class ScienceSensor {
	/// The name of this sensor.
	final String name;

	/// The test to determine the presence of life based on data from this sensor.
	final ScienceTest test;

	/// A human-readable description of [test]s.
	final String testDescription;

	/// A const constructor.
	const ScienceSensor({
		required this.name, 
		required this.test,
		required this.testDescription,
	});
}

/// Stores all the readings of one sensor for one sample.
class SampleData {
	/// A list of the readings for this sample and sensor.
	final List<SensorReading> readings = [];

	/// The [Timestamp] of the first reading.
	/// 
	/// All other [SensorReading.time]s are relative to this.
	Timestamp? firstTimestamp;

	/// The minimum value of [readings].
	double? min;

	/// The average value of [readings].
	/// 
	/// Because there may be many readings, this is updated efficiently in [addReading].
	double? average;

	/// The maximum value of [readings].
	double? max;

	/// The sum total of all the [readings]. Used to update [average].
	double sum = 0;

	/// Adds a new [SensorReading] with [timestamp] relative to [firstTimestamp].
	/// 
	/// [min], [max], and [average] are updated here.
	void addReading(Timestamp timestamp, double value) {
		firstTimestamp ??= timestamp;
		readings.add(SensorReading(time: timestamp - firstTimestamp!, value: value));
		if (min == null || value < min!) min = value;
		if (max == null || value > max!) max = value;
		sum += value;
		average = sum / readings.length;
	}

	/// Clears all readings.
	void clear() {
		readings.clear();
		firstTimestamp = null;
		min = average = max = null;
		sum = 0;
	}
}

extension on Timestamp {
	double operator -(Timestamp other) => (seconds - other.seconds).toDouble();
}

/// The test to determine the presence of life based on temperature data.
ScienceResult temperatureTest(SampleData data) => (data.average! > -15 && data.average! < 122)
	? ScienceResult.extant : ScienceResult.notPresent;

/// The test to determine the presence of life based on humidity data.
ScienceResult humidityTest(SampleData data) => (data.average! > 20) 
	? ScienceResult.extant : ScienceResult.notPresent;

/// The test to determine the presence of life based on CO2 data.
/// The max has to be greater than 10% greater than min for life to exist
ScienceResult co2Test(SampleData data) => (data.max! >= (data.min! * 1.1)) 
	? ScienceResult.extant : ScienceResult.notPresent;

/// The temperature sensor.
const temperature = ScienceSensor(
	name: "Temperature", 
	test: temperatureTest,
	testDescription: "Average between -15°C and 122°C: Extinct",
);

/// The humidity sensor.
const humidity = ScienceSensor(
	name: "Humidity", 
	test: humidityTest,
	testDescription: "Average above 20%: Extant",
);

/// The co2 sensor.
const co2 = ScienceSensor(
	name: "CO2", 
	test: co2Test,
	testDescription: "Max CO2 greater than 10% of Min CO2: Extant",
);

/// A list of all the sensors on the Science subsystem.
const sensors = [temperature, humidity, co2];
