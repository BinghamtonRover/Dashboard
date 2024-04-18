import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/pages.dart";
import "package:rover_dashboard/widgets.dart";

class _LineChart extends StatelessWidget {
  final List<Iterable<SensorReading>> readings;
  final List<Color> colors;
  final String bottomUnitName;
  final String sideUnitName;
  final String title;
  final double? minY;
  final double? maxY;
  
  const _LineChart({
    required this.readings,
    required this.colors,
    required this.bottomUnitName,
    required this.sideUnitName,
    required this.title,
    this.minY,
    this.maxY,
  });

  @override
  Widget build(BuildContext context) => LineChart(
      LineChartData(
        lineBarsData: [
          for(int i = 0; i < readings.length; i++)
            LineChartBarData(
              color: colors[i],
              spots: [
                for (final reading in readings[i])
                  if(reading.time > 0) FlSpot(reading.time / 1000, reading.value),
              ],
            ),
        ],
        titlesData: FlTitlesData(
          topTitles: AxisTitles(
            axisNameSize: 30,
            axisNameWidget: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ), 
          leftTitles: AxisTitles(
            axisNameWidget: Text(
              sideUnitName,
              style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
            sideTitles: const SideTitles(showTitles: true, reservedSize: 35),
          ),
          bottomTitles: AxisTitles(
            axisNameWidget: Text(bottomUnitName),
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
        minY: minY, maxY: maxY,
        clipData: const FlClipData.all(),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            fitInsideVertically: true, 
            fitInsideHorizontally: true,
            getTooltipItems:(touchedSpots) => [
              for(final spot in touchedSpots)
                LineTooltipItem("${spot.y.toStringAsFixed(2)} $sideUnitName", const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
      duration: const Duration(milliseconds: 10),
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
        Text("Electrical", style: context.textTheme.headlineMedium), 
        const SizedBox(width: 12),
        const Spacer(),
        Text(model.axis ? "Horizontal" : "Vertical", style: context.textTheme.labelLarge),
        const SizedBox(width: 12),
        Switch(
          value: model.axis,
          onChanged: (bool value) => model.changeDirection(),
        ),
        const SizedBox(width: 8),
        ElevatedButton.icon(icon: const Icon(Icons.clear), label: const Text("Clear all"), onPressed: model.clear),
        const SizedBox(width: 8),
        const ViewsSelector(currentView: Routes.electrical),
      ],),
      if (model.axis) Expanded(child:
        Row(children: [
          for (final graph in _getGraphs(model))
            Expanded(child: graph),
        ],),
      ) 
      else
        for (final graph in _getGraphs(model))
          Expanded(child: graph),
      const SizedBox(height: 8),
    ],
  );

  List<Widget> _getGraphs(ElectricalModel model) => [
    _LineChart(
      readings: [model.voltageReadings], 
      colors: const [Colors.blue],
      bottomUnitName: "Time",
      sideUnitName: "V",
      title: "Voltage Graph",
      minY: 23, 
      maxY: 35,
    ),
    _LineChart(
      readings: [model.currentReadings],
      colors: const [Colors.blue],
      bottomUnitName: "Time",
      sideUnitName: "A",
      title: "Current Graph",
      minY: 0,
    ),
    _LineChart(
      readings: [model.rightSpeeds, model.leftSpeeds], 
      colors: const [Colors.red, Colors.blue],
      bottomUnitName: "Time", 
      sideUnitName: "RPM", 
      title: "Speeds",
      minY: -1,
      maxY: 1,
    ),
  ];
}
