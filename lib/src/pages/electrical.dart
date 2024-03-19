import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/pages.dart";
import "package:rover_dashboard/src/models/view/electrical.dart";
import "package:rover_dashboard/widgets.dart";

/// The UI for the electrical subsystem.
/// 
/// Displays a bird's-eye view of the rover and its path to the goal.
class ElectricalPage extends ReactiveWidget<ElectricalModel> {
  @override
  ElectricalModel createModel() => ElectricalModel();

  /// The `package:fl_chart` helper class for the details charts.
	LineChartData getDetailsData(Map<Timestamp, double> data, Color color) => LineChartData(
		lineBarsData: [
			LineChartBarData(
				spots: [
					for (final entry in data.entries) 
						FlSpot(entry.key.seconds.toDouble(), entry.value),
				], 
				color: color,
				preventCurveOverShooting: true,
				isCurved: true,
			),
		], 
		titlesData: FlTitlesData(
			topTitles: const AxisTitles(), 
			bottomTitles: AxisTitles(
				sideTitles: SideTitles(
					showTitles: true, 
					getTitlesWidget: (double value, TitleMeta meta) => SideTitleWidget(
						axisSide: AxisSide.bottom,
						space: 3,
						child: Text(value.toStringAsFixed(0)),
					),
				),
			),
		),
		extraLinesData: ExtraLinesData(horizontalLines: [HorizontalLine(y: 0)], verticalLines: [VerticalLine(x: 0)]),
		minX: 0, minY: 0,
		clipData: const FlClipData.all(),
		lineTouchData: const LineTouchData(touchTooltipData: LineTouchTooltipData(fitInsideVertically: true, fitInsideHorizontally: true)),
	);

	@override
	Widget build(BuildContext context, ElectricalModel model) => Column(children: [
    Row(children: [  // The header at the top
      const SizedBox(width: 8),
      Text("Electrical Analytics", style: context.textTheme.headlineMedium), 
      const SizedBox(width: 12),
      if (model.isLoading) const SizedBox(height: 20, width: 20, child: CircularProgressIndicator()),
      const Spacer(),
      const ViewsSelector(currentView: Routes.electrical),
    ],),
    Expanded(child: ListView(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      children: [
        const Text("YO PUSSY"),
        Text(model.metrics.allMetrics.toString()),
        Text(model.voltageData.toString()),
        LineChart(
          getDetailsData(model.voltageData, Colors.black)
        ),
      ],
    ),),
  ],);
}
