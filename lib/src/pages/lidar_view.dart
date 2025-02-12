import "dart:math";
import "dart:ui";

import "package:flutter/material.dart";
import "package:rover_dashboard/src/models/view/lidar.dart";
import "package:rover_dashboard/widgets.dart";
import "package:burt_network/burt_network.dart";

class LidarView extends ReactiveWidget<LidarModel> {
  /// The index of this view
  final int index;

  LidarView({required this.index, super.key});

  @override
  LidarModel createModel() => LidarModel();

  @override
  Widget build(BuildContext context, LidarModel model) => Column(
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

class LidarViewPainter extends CustomPainter {
  /// Origin offset, origin (0,0) is at the center by default.
  final List<LidarCartesianPoint>? coordinates;
  /// The color to draw the points and box in
  final Color pointColor;

  const LidarViewPainter({
    required this.coordinates,
    required this.pointColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = pointColor
      ..strokeWidth = 3.0
      ..style = PaintingStyle.fill;

    final vertices = Vertices(
      VertexMode.triangles,
      <Offset>[
        Offset(0, size.height), // Vertex 1
        Offset(size.width, size.height), // Vertex 2
        Offset(size.width / 2, size.height / 2), // Vertex 3
      ],
    );

    final hiddenPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.fill;

    final axisPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final boxBorder = Paint()
      ..color = pointColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final points = coordinates ?? []; 
    final pointsToPlot = [
      for (final point in points)
        Offset(
          (-point.y + 2) * size.width / 4,
          (-point.x + 2) * size.height / 4,
        ),
    ];

    // 2 meter circle
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 2, axisPaint);

    // 1 meter circle
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 4, axisPaint);

    // Draw the black out points
    canvas.drawVertices(vertices, BlendMode.src, hiddenPaint);

    // Plot the points
    canvas.drawPoints(PointMode.points, pointsToPlot, paint);

    // Draw x - axis
    canvas.drawLine(
      Offset(0, size.height / 2),  
      Offset(size.width, size.height / 2),     
      axisPaint,
    );

    // Draw y - axis
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height / 2),
      axisPaint,
    );

    // Draw the border box
    canvas.drawRect(Rect.fromPoints(Offset.zero, Offset(size.width, size.height)), boxBorder);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
