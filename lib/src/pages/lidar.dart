import "dart:math";
import "dart:ui";
import "dart:ui" as ui;

import "package:flutter/material.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/widgets.dart";
import "package:burt_network/protobuf.dart";

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
      PageHeader(
        pageIndex: index,
        children: [
          const SizedBox(width: 8),
          Text("Lidar", style: context.textTheme.headlineMedium),
          const Spacer(),
        ],
      ),
      const SizedBox(height: 10),
      Flexible(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final minSide = min(constraints.maxWidth, constraints.maxHeight);
            return Center(
              child: SizedBox(
                width: minSide,
                height: minSide,
                child: CustomPaint(
                  willChange: true,
                  painter: LidarViewPainter(
                    coordinates: model.coordinates,
                    pointColor: context.colorScheme.onSurface,
                  ),
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
  LidarViewPainter({
    required this.coordinates,
    required this.pointColor,
  });

  /// The paint to use on the individually plotted points.
  late final pointPaint = Paint()
    ..color = pointColor
    ..strokeWidth = 3.0
    ..style = PaintingStyle.fill;

  /// The paint to use in the area that the lidar cannot see.
  final hiddenPaint = Paint()
    ..color = Colors.grey
    ..style = PaintingStyle.fill;

  /// The paint to use on the axis.
  final axisPaint = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.stroke
    ..strokeWidth = 0.5;

  /// The paint to use on the surrounding circle.
  final circlePaint = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0;

  /// The paint to use on the border around the lidar view.
  late final boxBorder = Paint()
    ..color = pointColor
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0;

  @override
  void paint(Canvas canvas, Size size) {
    final hiddenArea = Vertices(
      VertexMode.triangles,
      [
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

    /// Create the labels "1 meter" and "2 meters".
    final height = (size.height / 20).clamp(10, 18).toDouble();
    final style = ParagraphStyle(fontSize: height, textAlign: TextAlign.start, fontWeight: FontWeight.bold);
    final textStyle = ui.TextStyle(color: pointColor);
    final par1Builder = ParagraphBuilder(style)
      ..pushStyle(textStyle)
      ..addText("1 meter");
    final par2Builder = ParagraphBuilder(style)
      ..pushStyle(textStyle)
      ..addText("2 meters");
    const constraints = ParagraphConstraints(width: double.infinity);
    final par1 = par1Builder.build()..layout(constraints);
    final par2 = par2Builder.build()..layout(constraints);

    // Draw circles to indicate 1 and 2 meters away from the rover.
    canvas.drawParagraph(par1, center - Offset(par1.maxIntrinsicWidth / 2, pixelsPerMeter - 5));
    canvas.drawParagraph(par2, center - Offset(par2.maxIntrinsicWidth / 2, 2 * pixelsPerMeter - 5));
    canvas.drawCircle(center, pixelsPerMeter, circlePaint);
    canvas.drawCircle(center, 2 * pixelsPerMeter, circlePaint);

    // Draw the hidden area
    canvas.drawVertices(hiddenArea, BlendMode.src, hiddenPaint);

    // Draw the X-axis
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      axisPaint,
    );

    // Draw the Y-axis
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
