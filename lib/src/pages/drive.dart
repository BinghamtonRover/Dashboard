import "dart:math";

import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";

import "package:rover_dashboard/models.dart";
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
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            final color = rod.gradient?.colors.first ?? rod.color;
            final textStyle = TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            );
            return BarTooltipItem(rod.toY.toStringAsFixed(4), textStyle);
          },
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
          color: Colors.blue,
          fromY: 0,
          toY: values[0],
          width: 30,
          borderRadius: BorderRadius.circular(0),
        ),
      ],
    ),
    BarChartGroupData(
      x: 1,
      groupVertically: true,
      barRods: [
        BarChartRodData(
          color: Colors.blue,
          fromY: 0,
          toY: values[1],
          width: 30,
          borderRadius: BorderRadius.circular(0),
        ),
      ],
    ),
  ];
}
class _WheelRPM extends StatelessWidget{
  final double rpm;
  final Color color;

  const _WheelRPM({
    required this.rpm,
    required this.color, 
  });

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      alignment: Alignment.center,
      width: 50, 
      height: 70,
      color: color,
      child: Text(
        rpm.toStringAsFixed(1),
        style: const TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ), 
    ),
  );
}
class _Wheels extends StatelessWidget{
  final List<double> wheels;
  final List<Color> colors;

  const _Wheels({
    required this.colors,
    required this.wheels, 
  });

  @override
  Widget build(BuildContext context) => Column(
    children: [
      const Text(
        "Wheel RPMs", 
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      Expanded(child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _WheelRPM(rpm: wheels[0], color: colors[0]),
              const SizedBox(height: 8,),
              _WheelRPM(rpm: wheels[1], color: colors[1]),
              const SizedBox(height: 8,),
              _WheelRPM(rpm: wheels[2], color: colors[2]),
              const SizedBox(height: 8,),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _WheelRPM(rpm: wheels[3], color: colors[3]),
              const SizedBox(height: 8,),
              _WheelRPM(rpm: wheels[4], color: colors[4]),
              const SizedBox(height: 8,),
              _WheelRPM(rpm: wheels[5], color: colors[5]),
              const SizedBox(height: 8,),
            ],
          ),
        ],
      ),),
    ],
  );
}

/// The UI for the drive analysis.
class DrivePage extends ReactiveWidget<PositionModel> {
  /// The index of this view.
  final int index;
  /// A const constructor.
  const DrivePage({required this.index});
  
  @override
  PositionModel createModel() => PositionModel();

  @override
	Widget build(BuildContext context, PositionModel model) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      PageHeader(
        pageIndex: index,
        children: [
          // The header at the top
          const SizedBox(width: 8),
          Text("Drive", style: context.textTheme.headlineMedium),
          const Spacer(),
        ],
      ),
      const SizedBox(height: 4),
      Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Column(children: [
                const Text(
                  "Front View", 
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(child: Transform.rotate(
		     
		     angle: model.position.roll * (pi/180),
                     child: Image.asset("assets/rover_front.png"), 
                ),),
              ],),
            ),
            Expanded(
              child: Column(children: [
                const Text(
                  "Side View", 
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
            Expanded(child: _Wheels(wheels: model.wheelsRPM, colors: model.wheelColors)),
            Expanded(child: _BarChart(values: [model.leftWheels, -model.rightWheels])),
          ],
        ),
      ),
    ],
  ); 
}
