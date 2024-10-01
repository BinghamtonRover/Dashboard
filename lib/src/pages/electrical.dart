import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/widgets.dart";
import "package:syncfusion_flutter_charts/charts.dart";

class _LineChart extends StatelessWidget {
  final List<Iterable<SensorReading>> readings;
  final List<Color> colors;
  final String bottomUnitName;
  final String sideUnitName;
  final String title;
  final double? minY;
  final double? maxY;
  final bool vertical;

  const _LineChart({
    required this.readings,
    required this.colors,
    required this.bottomUnitName,
    required this.sideUnitName,
    required this.title,
    this.minY,
    this.maxY,
    this.vertical = false,
  });

  List<CartesianSeries<SensorReading, double>> getChartSeries() {
    final result = <CartesianSeries<SensorReading, double>>[];
    for (int i = 0; i < readings.length; i++) {
      result.add(
        LineSeries(
          animationDuration: 0,
          dataLabelMapper: (datum, index) => "${datum.value}$sideUnitName",
          color: colors[i],
          xValueMapper: (datum, index) => datum.time / 1000,
          yValueMapper: (datum, index) => datum.value,
          dataSource: readings[i].toList(),
          width: 2.5,
        ),
      );
    }
    return result;
  }

  @override
  Widget build(BuildContext context) => SfCartesianChart(
      title: ChartTitle(text: title),
      isTransposed: vertical,
      primaryXAxis: NumericAxis(
        name: bottomUnitName,
        decimalPlaces: 0,
        minimum: (readings.firstOrNull?.firstOrNull?.time ?? 0) / 1000,
        maximum: (readings.firstOrNull?.firstOrNull?.time ?? 0) / 1000 + 5,
      ),
      primaryYAxis: NumericAxis(
        name: sideUnitName,
        minimum: minY,
        maximum: maxY,
        labelFormat: "{value}$sideUnitName",
      ),
      series: getChartSeries(),
      tooltipBehavior: TooltipBehavior(enable: true, animationDuration: 0),
    );
}

/// The UI for the electrical subsystem.
class ElectricalPage extends ReactiveWidget<ElectricalModel> {
  /// The index of this view.
  final int index;

  /// A const constructor.
  const ElectricalPage({required this.index});

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
        ViewsSelector(index: index),
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
      vertical: model.axis,
    ),
    _LineChart(
      readings: [model.currentReadings],
      colors: const [Colors.blue],
      bottomUnitName: "Time",
      sideUnitName: "A",
      title: "Current Graph",
      minY: 0,
      vertical: model.axis,
    ),
    _LineChart(
      readings: [model.rightSpeeds, model.leftSpeeds], 
      colors: const [Colors.red, Colors.blue],
      bottomUnitName: "Time", 
      sideUnitName: "RPM", 
      title: "Speeds",
      minY: -1,
      maxY: 1,
      vertical: model.axis,
    ),
  ];
}
