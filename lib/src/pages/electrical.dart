import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";

import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/pages.dart";
import "package:rover_dashboard/src/models/view/electrical.dart";
import "package:rover_dashboard/widgets.dart";


class _LineChart extends StatelessWidget {
  const _LineChart({required this.coordinates});

  final Map<DateTime, double> coordinates;

  @override
  Widget build(BuildContext context) => LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: [
              for(final entry in coordinates.entries)
                FlSpot(entry.key.difference(DateTime.now()).inMilliseconds.toDouble() , entry.value),
            ],
            color: Colors.blue,
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
      ),
      duration: const Duration(milliseconds: 250),
    );
}



/// The UI for the electrical subsystem.
/// 
/// Displays a bird's-eye view of the rover and its path to the goal.
class ElectricalPage extends ReactiveWidget<ElectricalModel> {
  @override
  ElectricalModel createModel() => ElectricalModel();

	@override
	Widget build(BuildContext context, ElectricalModel model) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Row(children: [  // The header at the top
        const SizedBox(width: 8),
        Text("Electrical Analytics", style: context.textTheme.headlineMedium), 
        const SizedBox(width: 12),
        if (model.isLoading) const SizedBox(height: 20, width: 20, child: CircularProgressIndicator()),
        const Spacer(),
        ElevatedButton.icon(icon: const Icon(Icons.clear), label: const Text("Clear all"), onPressed: model.clear),
        const SizedBox(width: 8),
        const ViewsSelector(currentView: Routes.electrical),
      ],),
      const SizedBox(height: 10,),
      const Text(
        "Voltage Graph", 
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.blue,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
      const SizedBox(height: 10,),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(right: 16, left: 6),
          child: _LineChart(coordinates: model.voltageData),
        ),
      ),
      const SizedBox(height: 10,),
      const Text(
        "Current Graph", 
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.blue,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
      const SizedBox(height: 10,),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(right: 16, left: 6),
          child: _LineChart(coordinates: model.currentData),
        ),
      ),
  ],);
}
