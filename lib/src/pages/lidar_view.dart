import "dart:math";
import "dart:ui";

import "package:flutter/material.dart";
import "package:rover_dashboard/src/models/view/lidar.dart";
import "package:rover_dashboard/widgets.dart";
import "package:burt_network/burt_network.dart";

/// A page displaying data from the Lidar
/// 
/// Listens to changes from a [LidarViewModel], and displays the cartesian coordinates
/// in a grid representing each point's location relative to the Lidar sensor.
class LidarView extends ReactiveWidget<LidarViewModel> {
  /// The index of this view
  final int index;

  /// Const constructor for LidarView, initializes the index of the page
  const LidarView({required this.index, super.key});

  @override
  LidarViewModel createModel() => LidarViewModel();

  @override
  Widget build(BuildContext context, LidarViewModel model) => Column(
    children: [
      Material(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              const SizedBox(width: 8),
              Text("Lidar", style: context.textTheme.headlineMedium), 
              const Spacer(),
              ViewsSelector(index: index),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
      const SizedBox(height: 10),
      Flexible(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final minSide = min(constraints.maxWidth, constraints.maxHeight);
            return FittedBox(
              child: SizedBox(
                width: minSide,
                height: minSide,
                child: CustomPaint(
                    size: Size(minSide, minSide),
                    painter: LidarViewPainter(
                      coordinates: model.coordinates,
                      pointColor: context.colorScheme.onSurface,
                    ),
                    willChange: true,
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}

/// A custom painter for the Lidar view
/// 
/// Draws the points and bounding area indicators
class LidarViewPainter extends CustomPainter {
  /// The maximum view range of the lidar
  static const double maxRange = 2;
  /// List of all the lidar points to draw
  final List<LidarCartesianPoint>? coordinates;
  /// The color to draw the points and box in
  final Color pointColor;

  /// Const constructor for LidarViewPainter
  /// 
  /// Initializes the required coordinates and point color fields
  const LidarViewPainter({
    required this.coordinates,
    required this.pointColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final pointPaint = Paint()
      ..color = pointColor
      ..strokeWidth = 3.0
      ..style = PaintingStyle.fill;

    final hiddenPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.fill;

    final axisPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    final circlePaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final boxBorder = Paint()
      ..color = pointColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final vertices = Vertices(
      VertexMode.triangles,
      <Offset>[
        Offset(0, size.height), // Vertex 1
        Offset(size.width, size.height), // Vertex 2
        Offset(size.width / 2, size.height / 2), // Vertex 3
      ],
    );

    final points = coordinates ?? []; 
    final pointsToPlot = [
      for (final point in points)
        Offset(
          (-point.y + maxRange) * size.width / (maxRange * 2),
          (-point.x + maxRange) * size.height / (maxRange * 2),
        ),
    ];

    final center = Offset(size.width / 2, size.height / 2);

    final pixelsPerMeter = (2 / maxRange) * size.width / 4;

    // 2 meter circle
    canvas.drawCircle(center, 2 * pixelsPerMeter, circlePaint);

    // 1 meter circle
    canvas.drawCircle(center, pixelsPerMeter, circlePaint);

    // Draw the black out points
    canvas.drawVertices(vertices, BlendMode.src, hiddenPaint);

    // Draw x axis
    canvas.drawLine(
      Offset(0, size.height / 2),  
      Offset(size.width, size.height / 2),     
      axisPaint,
    );

    // Draw y axis
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height / 2),
      axisPaint,
    );

    // Plot the points
    canvas.drawPoints(PointMode.points, pointsToPlot, pointPaint);

    // Draw the border box
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), boxBorder);
  }

  @override
  bool shouldRepaint(LidarViewPainter oldDelegate) =>
      coordinates != oldDelegate.coordinates ||
      pointColor != oldDelegate.pointColor;
}
