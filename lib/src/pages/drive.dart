import "dart:math";

import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";

import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/pages.dart";
import "package:rover_dashboard/widgets.dart";

/// Widget to display the speed of the each side of the rover as a bar graph
class _BarChart extends StatelessWidget {
  final List<double> values;

  const _BarChart({
    required this.values, 
  });

  @override
  Widget build(BuildContext context) => BarChart(
    BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          fitInsideVertically: true, 
          fitInsideHorizontally: true,
        ),
      ),
      minY: -1,
      maxY: 1,
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
      ),
      borderData: FlBorderData(show: true),
      gridData: const FlGridData(
        drawVerticalLine: false,
      ),
      barGroups: barGroups,
      extraLinesData: ExtraLinesData(horizontalLines: [HorizontalLine(y: 0)]),
    ),
  );

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.red,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = "Left";
      case 1:
        text = "Right";
      default:
        text = "";
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }
    
  List<BarChartGroupData> get barGroups => [
    BarChartGroupData(
      x: 0,
      groupVertically: true,
      barRods: [
        BarChartRodData(
          color: Colors.pink,
          fromY: 0,
          toY: values[0],
          width: 30,
          rodStackItems: [
            BarChartRodStackItem(0, values[0], Colors.blue),   
            BarChartRodStackItem(values[0], values[0] - 0.0001, Colors.pink),
          ],
        ),
      ],
    ),
    BarChartGroupData(
      x: 1,
      groupVertically: true,
      barRods: [
        BarChartRodData(
          color: Colors.pink,
          fromY: 0,
          toY: values[1],
          width: 30,
          rodStackItems: [
            BarChartRodStackItem(0, values[1], Colors.blue),   
            BarChartRodStackItem(values[1], values[1] - 0.0001, Colors.pink),
          ],
        ),
      ],
    ),
  ];

}

/// The UI for the drive analysis.
class DrivePage extends ReactiveWidget<PositionModel> {
  @override
  PositionModel createModel() => PositionModel();

  @override
	Widget build(BuildContext context, PositionModel model) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Row(children: [  // The header at the top
        const SizedBox(width: 8),
        Text("Drive", style: context.textTheme.headlineMedium), 
        const Spacer(),
        const ViewsSelector(currentView: Routes.drive),
      ],),
      Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Column(children: [
                const Text("Front View of the Rover"),
                Expanded(child: Transform.rotate(
                  angle: model.position.roll * (pi/180),
                  child: Image.asset("assets/rover_front.png"),
                ),),
              ],),
            ),
            Expanded(
              child: Column(children: [
                const Text("Side View of the Rover"),
                Expanded(child: Transform.rotate(
                  angle: model.position.pitch * (pi/180),
                  child: Image.asset("assets/rover_side.png", scale: 0.5),              
                ),),
              ],),
            ),
          ],
        ),
      ),
      Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // const Expanded(child: Text("6 rectangles for each wheel showing their rpm -- find the odd one out"),),
            const Expanded(child: Placeholder()),
            Expanded(child: _BarChart(values: [model.leftWheels, model.rightWheels])),
          ],
        ),
      ),
    ],
  );
      
}