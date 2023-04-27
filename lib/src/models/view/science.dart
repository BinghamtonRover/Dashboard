import "package:flutter/material.dart";
import "package:fl_chart/fl_chart.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

enum ScienceResult {
	extinct, extant, notPresent, inconclusive, loading,
}

GetTitleWidgetFunction getTitles(List<String> titles) => 
	(double value, TitleMeta meta) => SideTitleWidget(
		axisSide: AxisSide.bottom,
		space: 2,
		child: Text(titles[value.toInt()])
	);

class ScienceTest {
	final String valueName1;
	final String? valueName2;
	final ScienceResult result;
	final double value1;
	final double? value2;

	final NumberBuilder<double> value1Builder;
	final NumberBuilder<double> value2Builder;

	ScienceTest({
		required this.result, 
		required this.valueName1,
		required this.value1,
		this.value2,
		this.valueName2,
	}) : value1Builder = NumberBuilder(value1),
		value2Builder = NumberBuilder(value2 ?? 0);
}

class ScienceSensor {
	final String name;
	final ScienceTest test;
	ScienceSensor(this.name, this.test);

	LineChartData details = LineChartData(
		lineBarsData: [
			LineChartBarData(spots: const [FlSpot(0, 0), FlSpot(1, 1), FlSpot(2, 3)], preventCurveOverShooting: true, isCurved: true),
			LineChartBarData(spots: const [FlSpot(0, 0), FlSpot(1, 1), FlSpot(2, 1)], preventCurveOverShooting: true, isCurved: true),
			LineChartBarData(spots: const [FlSpot(0, 0), FlSpot(1, 1), FlSpot(2, 2)], preventCurveOverShooting: true, isCurved: true),
		], 
		extraLinesData: ExtraLinesData(horizontalLines: [HorizontalLine(y: 0)], verticalLines: [VerticalLine(x: 0)]),
		minX: 0, minY: 0,
	);

	BarChartData summary = BarChartData(
		barGroups: [
			BarChartGroupData(x: 0, barRods: [BarChartRodData(fromY: 0, toY: 15)]),
			BarChartGroupData(x: 1, barRods: [BarChartRodData(fromY: 0, toY: 10)]),
			BarChartGroupData(x: 2, barRods: [BarChartRodData(fromY: 0, toY: 20)]),
		],
		titlesData: FlTitlesData(show: true, bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: getTitles(["1", "2", "3"])))),
	);
}

class ScienceModel with ChangeNotifier {
	List<List<ScienceData>> data = [];
	List<ScienceSensor> sensors = [
		ScienceSensor("Temperature", ScienceTest(
			valueName1: "Average",
			value1: 1.5,
			result: ScienceResult.extinct,
		)),
		ScienceSensor("Humidity", ScienceTest(
			valueName1: "Average",
			value1: 1.5,
			result: ScienceResult.extant,
		)),
		ScienceSensor("pH", ScienceTest(
			valueName1: "Average",
			value1: 1.5,
			result: ScienceResult.notPresent,
		)),
		ScienceSensor("CO2", ScienceTest(
			valueName1: "Average",
			value1: 1.5,
			result: ScienceResult.inconclusive,
		)),
		ScienceSensor("Methane", ScienceTest(
			valueName1: "Min",
			value1: 0,
			value2: 2,
			valueName2: "Max",
			result: ScienceResult.loading,
		)),
	];

	bool isLoading = false;

	void uploadLogs() { }

	void addRow(ScienceData row) { }
}
