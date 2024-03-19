import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/pages.dart";
import "package:rover_dashboard/widgets.dart";

class _LineChart extends StatelessWidget {
  final List<SensorReading> readings;
  final String unitName;
  final double minY;
  final double? maxY;
  const _LineChart({
    required this.readings,
    required this.unitName,
    this.minY = 0,
    this.maxY,
  });

  @override
  Widget build(BuildContext context) => LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            color: Colors.blue,
            spots: [
              for (final reading in readings)
                FlSpot(reading.time, reading.value),
            ],
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
        minX: 0, minY: minY, maxY: maxY,
        clipData: const FlClipData.all(),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            fitInsideVertically: true, 
            fitInsideHorizontally: true,
            getTooltipItems:(touchedSpots) => [LineTooltipItem("${touchedSpots.first.y.toStringAsFixed(2)} $unitName", const TextStyle(color: Colors.white))],
          ),
        ),
      ),
      duration: const Duration(milliseconds: 250),
    );
}

/// The UI for the electrical subsystem.
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
          child: _LineChart(
            readings: model.voltageReadings.toList(), 
            minY: 20, 
            maxY: 35,
            unitName: "V",
          ),
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
          child: _LineChart(
            readings: model.currentReadings.toList(),
            unitName: "A",
          ),
        ),
      ),
  ],);
}
