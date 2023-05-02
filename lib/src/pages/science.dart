import "package:flutter/material.dart";
import "package:flutter/gestures.dart";
import "package:fl_chart/fl_chart.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/pages.dart";
import "package:rover_dashboard/widgets.dart";

/// Allows desktop users to scroll with their mouse or other device.
class DesktopScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => { 
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
    PointerDeviceKind.trackpad,
  };
}

/// A row of scrollable or non-scrollable widgets.
class ScrollingRow extends StatelessWidget {
	/// The widgets to display.
	final List<Widget> children;

	/// The height of this row.
	final double height;

	/// Renders a row of widgets.
	const ScrollingRow({required this.children, this.height = 300});

	@override
	Widget build(BuildContext context) => ProviderConsumer<SettingsModel>.value(
		value: models.settings,
		builder: (model) => SizedBox(height: height, child: model.science.scrollableGraphs
			? ScrollConfiguration(
			  behavior: DesktopScrollBehavior(),
				child: ListView(
					scrollDirection: Axis.horizontal, 
					children: [for (final child in children) SizedBox(width: 400, child: child)],
				)
			)
			: Row(
				children: [for (final child in children) Expanded(child: child)]
			)
		)
	);
}

/// A [ScrollingRow] of charts, using [builder] on each [ScienceAnalysis] in [analyses].
class ChartsRow extends StatelessWidget {
	/// The title of these charts.
	final String title;

	/// The height of this row.
	final double height;

	/// The data for these charts. 
	final List<ScienceAnalysis> analyses;

	/// The chart to show for each piece of data.
	final Widget Function(ScienceAnalysis) builder;

	/// A const constructor.
	const ChartsRow({
		required this.title, 
		required this.analyses, 
		required this.builder, 
		this.height = 300
	});

	@override
	Widget build(BuildContext context) => Column(children: [
		const SizedBox(height: 24),
		Text(title, style: context.textTheme.titleLarge),
		const SizedBox(height: 12),
		ScrollingRow(height: height, children: [
			for (final analysis in analyses) Column(children: [
				Text(analysis.sensor.name, textAlign: TextAlign.center, style: context.textTheme.labelLarge),
				SizedBox(height: 8),
				Expanded(child: builder(analysis)),
			])
		]),
	]);
}

/// Gets titles for a graph.
GetTitleWidgetFunction getTitles(List<String> titles) => 
	(double value, TitleMeta meta) => SideTitleWidget(
		axisSide: AxisSide.bottom,
		space: 2,
		child: Text(titles[value.toInt()])
	);

/// The science analysis page.
class SciencePage extends StatelessWidget {
	/// Red, used as the color for the first sample.
	static final red = HSVColor.fromColor(Colors.red);
	/// Purple, used as the color for the last sample.
	static final purple = HSVColor.fromColor(Colors.purple);
	/// Gets a color between red and purple 
	///
	/// [value] must be between 0.0 and 1.0. 
	Color getColor(double value) => HSVColor.lerp(red, purple, value)!.toColor();

	/// The `package:fl_chart` helper class for the details charts.
	LineChartData getDetailsData(ScienceAnalysis analysis, Color color) => LineChartData(
		lineBarsData: [
			LineChartBarData(
				spots: [
					for (final reading in analysis.data.readings) 
						FlSpot(reading.time, reading.value)
				], 
				color: color,
				preventCurveOverShooting: true,
				isCurved: true,
			),
		], 
		titlesData: FlTitlesData(
			show: true, 
			topTitles: AxisTitles(), 
			bottomTitles: AxisTitles(
				sideTitles: SideTitles(
					showTitles: true, 
					getTitlesWidget: (double value, TitleMeta meta) => SideTitleWidget(
						axisSide: AxisSide.bottom,
						space: 3,
						child: Text(value.toString())
					)
				)
			)
		),
		extraLinesData: ExtraLinesData(horizontalLines: [HorizontalLine(y: 0)], verticalLines: [VerticalLine(x: 0)]),
		minX: 0, minY: 0,
	);

	/// The `package:fl_chart` helper class for the summary charts.
	BarChartData getBarChartData(ScienceAnalysis analysis, Color color) => BarChartData(
		barGroups: [
			BarChartGroupData(x: 0, barRods: [BarChartRodData(color: color, fromY: 0, toY: analysis.data.min ?? 0)]),
			BarChartGroupData(x: 1, barRods: [BarChartRodData(color: color, fromY: 0, toY: analysis.data.average ?? 0)]),
			BarChartGroupData(x: 2, barRods: [BarChartRodData(color: color, fromY: 0, toY: analysis.data.max ?? 0)]),
		],
		titlesData: FlTitlesData(
			show: true, 
			topTitles: AxisTitles(), 
			bottomTitles: AxisTitles(
				sideTitles: SideTitles(
					showTitles: true, 
					getTitlesWidget: (double value, TitleMeta meta) => SideTitleWidget(
						axisSide: AxisSide.bottom,
						space: 3,
						child: Text(["Min", "Avg", "Max"][value.toInt()]),
					)
				)
			)
		),
	);

	@override
	Widget build(BuildContext context) => ProviderConsumer<ScienceModel>(
		create: ScienceModel.new,
		builder: (model) => Stack(children: [
			ListView(  // The main content of the page
				padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 32),
				children: [
					if (model.errorText != null) ...[
						const SizedBox(height: 48),
						Text("Error analyzing the logs", textAlign: TextAlign.center, style: context.textTheme.headlineLarge),
						const SizedBox(height: 24),
						Text("Here is the error:", textAlign: TextAlign.center, style: context.textTheme.titleLarge),
						const SizedBox(height: 12),
						Text(model.errorText!, textAlign: TextAlign.center, style: context.textTheme.titleMedium),
					] else if (!model.isLoading) ...[
						ChartsRow(
							title: "Details",
							analyses: model.analysesForSample,
							builder: (analysis) => LineChart(getDetailsData(analysis, getColor(model.sample / model.numSamples))),
						),
						ChartsRow(
							title: "Summary",
							analyses: model.analysesForSample,
							builder: (analysis) => BarChart(getBarChartData(analysis, getColor(model.sample / model.numSamples))),
						),
						ChartsRow(
							title: "Results",
							height: 425,
							analyses: model.analysesForSample,
							builder: ResultsBox.new,
						)
					]
				],
			),
			Container(
				color: context.colorScheme.surface, 
				height: 48, 
				child: Row(children: [  // The header at the top
					const SizedBox(width: 8),
					Text("Science Analysis", style: context.textTheme.headlineMedium), 
					const SizedBox(width: 12),
					if (model.isLoading) const SizedBox(height: 20, width: 20, child: CircularProgressIndicator()),
					const Spacer(),
					DropdownButton(
						value: model.sample,
						onChanged: model.updateSample,
						items: [
							for (int i = 0; i < model.numSamples; i++) DropdownMenuItem(
								value: i,
								child: Text("Sample ${i + 1}"),
							)
						],
					),
					IconButton(
						icon: const Icon(Icons.upload_file),
						onPressed: model.loadFile,
					),
					const ViewsSelector(currentView: Routes.science),
				]),
			)
		])
	);
}

/// A box to display the final results for each sensor.
class ResultsBox extends StatelessWidget {
	/// The sensor being tested.
	final ScienceAnalysis analysis;

	/// Creates a widget to display the results of a science test.
	const ResultsBox(this.analysis);

	/// The color to render this box.
	Color? get color {
		switch(analysis.testResult) {
			case ScienceResult.extinct: return Colors.red;
			case ScienceResult.extant: return Colors.green;
			case ScienceResult.notPresent: return Colors.orange;
			case ScienceResult.inconclusive: return Colors.blueGrey;
			case ScienceResult.loading: return null;
		}
	}

	/// The text to display in this box.
	String get text {
		switch(analysis.testResult) {
			case ScienceResult.extinct: return "Extinct";
			case ScienceResult.extant: return "Extant";
			case ScienceResult.notPresent: return "Not Present";
			case ScienceResult.inconclusive: return "Inconclusive";
			case ScienceResult.loading: return "Collecting data...";
		}
	}

	@override
	Widget build(BuildContext context) => Column(children: [
		Expanded(child: Container(
			margin: const EdgeInsets.all(8),
			padding: const EdgeInsets.all(8),
			width: double.infinity,
			color: color ?? context.colorScheme.surface,
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Text(analysis.sensor.testDescription),
					const Spacer(),
					Center(child: Text(text, textAlign: TextAlign.center, style: context.textTheme.headlineLarge)),
					const Spacer(),
				]
			)
		)),
		NumberEditor(
			name: "Min",
			model: analysis.testBuilder.min,
			titleFlex: 1,
		),
		NumberEditor(
			name: "Average",
			model: analysis.testBuilder.average,
			titleFlex: 1,
		),
		NumberEditor(
			name: "Max",
			model: analysis.testBuilder.max,
			titleFlex: 1,
		),
	]);
}
