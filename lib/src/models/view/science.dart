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

/// A sensor on the science chamber.
class ScienceSensor {
	/// The name of this sensor.
	final String name;

	/// The test for life based on this sensor's values.
	final ScienceTest test;

	/// A sensor on the science chamber and its test for life.
	ScienceSensor(this.name, this.test);

	/// The individual data points for this sensor.
	LineChartData details = LineChartData(
		lineBarsData: [
			LineChartBarData(spots: const [FlSpot(0, 0), FlSpot(1, 1), FlSpot(2, 3)], preventCurveOverShooting: true, isCurved: true),
			LineChartBarData(spots: const [FlSpot(0, 0), FlSpot(1, 1), FlSpot(2, 1)], preventCurveOverShooting: true, isCurved: true),
			LineChartBarData(spots: const [FlSpot(0, 0), FlSpot(1, 1), FlSpot(2, 2)], preventCurveOverShooting: true, isCurved: true),
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
		titlesData: FlTitlesData(show: true, bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: getTitles(["1", "2", "3"])))),
	);
}

/// The view model for the science analysis page.
class ScienceModel with ChangeNotifier {
	/// The being analyzed. Each sample gets its own list.
	List<List<ScienceData>> data = [];

	/// The different sensors.
	List<ScienceSensor> sensors = [
		ScienceSensor("Temperature", ScienceTest(
			value1Name: "Average",
			value1: 1.5,
			test: ({required value1, value2}) => ScienceResult.extinct,
		)),
		ScienceSensor("Humidity", ScienceTest(
			value1Name: "Average",
			value1: 1.5,
			test: ({required value1, value2}) => ScienceResult.extant,
		)),
		ScienceSensor("pH", ScienceTest(
			value1Name: "Average",
			value1: 1.5,
			test: ({required value1, value2}) => ScienceResult.notPresent,
		)),
		ScienceSensor("CO2", ScienceTest(
			value1Name: "Average",
			value1: 1.5,
			test: ({required value1, value2}) => ScienceResult.inconclusive,
		)),
		ScienceSensor("Methane", ScienceTest(
			value1Name: "Min",
			value1: 0,
			value2: 2,
			value2Name: "Max",
			test: ({required value1, value2}) => ScienceResult.loading,
		)),
	];

	/// Whether the page is currently loading.
	bool isLoading = false;

	/// Upload a CSV file using [addData].
	void uploadLogs() { }

	/// Adds one piece of data to the model.
	void addData(ScienceData row) { }
}
