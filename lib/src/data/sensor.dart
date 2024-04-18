/// A sensor reading with a timestamp.
class SensorReading {
	/// The time this reading was taken, relative to the first reading.
	final double time;

	/// The value from the sensor.
	final double value;

	/// A const constructor.
	const SensorReading({required this.time, required this.value});
}
