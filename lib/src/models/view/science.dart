import "package:flutter/material.dart";
import "package:fl_chart/fl_chart.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

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

extension on Timestamp {
	double operator -(Timestamp other) => (seconds - other.seconds).toDouble();
}

/// Gets titles for a graph.
GetTitleWidgetFunction getTitles(List<String> titles) => 
	(double value, TitleMeta meta) => SideTitleWidget(
		axisSide: AxisSide.bottom,
		space: 2,
		child: Text(titles[value.toInt()])
	);

/// A science test.
/// 
/// Consists of reading values off a graph and making a decision.
class ScienceTest {
	/// The first value used.
	final double value1;
	/// The name of the first value used.
	final String value1Name;

	/// The name of the second value used, if any.
	final String? value2Name;

	/// The second value used, if any.
	final double? value2;

	/// A function that determines the result of this test.
	final ScienceResult Function({required double value1, double? value2}) test;

	/// Provides a manual override for [value1].
	final NumberBuilder<double> value1Builder;
	/// Provides a manual override for [value2].
	final NumberBuilder<double> value2Builder;

	/// Creates a science test.
	ScienceTest({
		required this.test,
		required this.value1Name,
		required this.value1,
		this.value2,
		this.value2Name,
	}) : 
		value1Builder = NumberBuilder(value1),
		value2Builder = NumberBuilder(value2 ?? 0);
}

class SensorReading {
	final double time;
	final double value;

	const SensorReading(this.value, Timestamp timestamp, Timestamp firstTimestamp) : 
		time = timestamp - firstTimestamp;
}

/// A sensor on the science chamber.
class ScienceSensor {
	static const numSamples = 3;

	final String name;

	Timestamp? firstTimestamp;

	final List<List<SensorReading>> samples = [
		for (int i = 0; i < numSamples; i++) []
	];

	/// The test for life based on this sensor's values.
	final ScienceTest test;

	/// A sensor on the science chamber and its test for life.
	ScienceSensor({required this.name, required this.test});

	void add(Timestamp timestamp, double value, int sample) {
		firstTimestamp ??= firstTimestamp = timestamp;
		samples[sample].add(SensorReading(value, timestamp, firstTimestamp!));
	}

	final List<Color> colors = [Colors.red, Colors.green, Colors.blue];
	final List<bool> shouldShowSample = [
		for (int i = 0; i < numSamples; i++) true
	];

	/// The individual data points for this sensor.
	LineChartData get details => LineChartData(
		lineBarsData: [
			LineChartBarData(
				spots: [
					for (final SensorReading reading in samples[sample]) FlSpot(reading.time, reading.value)
				], 
				color: colors[sample],
				preventCurveOverShooting: true,
				isCurved: true,
			),
		], 
		extraLinesData: ExtraLinesData(horizontalLines: [HorizontalLine(y: 0)], verticalLines: [VerticalLine(x: 0)]),
		minX: 0, minY: 0,
	);

	/// A comparison of important data points across all the samples.
	BarChartData summary = BarChartData(
		barGroups: [
			BarChartGroupData(x: 0, barRods: [BarChartRodData(fromY: 0, toY: 15)]),
			BarChartGroupData(x: 1, barRods: [BarChartRodData(fromY: 0, toY: 10)]),
			BarChartGroupData(x: 2, barRods: [BarChartRodData(fromY: 0, toY: 20)]),
		],
		titlesData: FlTitlesData(show: true, bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: getTitles(["Min", "Average", "Max"])))),
	);

	int sample = 0;

	void clear() { 
		for (final sample in samples) { sample.clear(); }
		firstTimestamp = null;
	}
}

/// The view model for the science analysis page.
class ScienceModel with ChangeNotifier {
	final temperature = ScienceSensor(
		name: "Temperature", 
		test: ScienceTest(
			value1Name: "Average",
			value1: 1.5,
			test: ({required value1, value2}) => ScienceResult.extinct,
		)
	);
	final humidity = ScienceSensor(
		name: "Humidity", 
		test: ScienceTest(
			value1Name: "Average",
			value1: 1.5,
			test: ({required value1, value2}) => ScienceResult.extant,
		)
	);
	final pH = ScienceSensor(
		name: "pH", 
		test: ScienceTest(
			value1Name: "Average",
			value1: 1.5,
			test: ({required value1, value2}) => ScienceResult.notPresent,
		)
	);
	final co2 = ScienceSensor(
		name: "CO2", 
		test: ScienceTest(
			value1Name: "Average",
			value1: 1.5,
			test: ({required value1, value2}) => ScienceResult.inconclusive,
		)
	);
	final methane = ScienceSensor(
		name: "Methane", 
		test: ScienceTest(
			value1Name: "Min",
			value1: 0,
			value2: 2,
			value2Name: "Max",
		test: ({required value1, value2}) => ScienceResult.loading,
	));

	late final List<ScienceSensor> sensors = [temperature, humidity, pH, co2, methane];

	/// The sample whose stats are being displayed.
	int sample = 0;

	int numSamples = 3;

	void updateSample(int? input) {
		if (input == null) return;
		sample = input;
		for (final sensor in sensors) { sensor.sample = input; }
		notifyListeners();
	}

	/// Whether the page is currently loading.
	bool isLoading = false;

	String? errorText;

	/// Adds one piece of data to the model.
	void addData(ScienceData row) { }

	void addMessage(WrappedMessage wrapper) {
		final data = wrapper.decode(ScienceData.fromBuffer);
		if (data.methane != 0) methane.add(wrapper.timestamp, data.methane, data.sample); 
		if (data.co2 != 0) co2.add(wrapper.timestamp, data.co2, data.sample); 
		if (data.humidity != 0) humidity.add(wrapper.timestamp, data.humidity, data.sample); 
		if (data.temperature != 0) temperature.add(wrapper.timestamp, data.temperature, data.sample); 
		if (data.pH != 0) pH.add(wrapper.timestamp, data.pH, data.sample); 
	}

	/// Calls [addMessage] for each message in the picked file.
	Future<void> loadFile() async {
		// Pick a file
		final result = await FilePicker.platform.pickFiles(
			dialogTitle: "Choose science logs",
			initialDirectory: services.files.loggingDir.path,
			type: FileType.custom,
			allowedExtensions: ["log"],
		);
		if (result == null || result.count == 0) return;
		final file = File(result.paths.first!);

		// Read the file
		isLoading = true;
		notifyListeners();
		try {
			for (final sensor in sensors) { sensor.clear(); }
			final messages = await services.files.readLogs(file);
			messages.forEach(addMessage);
			errorText = null;
		} catch (error) {
			errorText = error.toString();
		}
		isLoading = false;
		notifyListeners();
	}
}
