import "dart:math";
import "package:burt_network/protobuf.dart";
import "package:flutter/material.dart";
import "package:rover_dashboard/models.dart";

/// A [CustomPainter] for the map to draw paths, markers, and
/// obstacles relative to the rover instead of snapping to a grid
class MapRelativePainter extends CustomPainter {
  /// The [AutonomyModel] to pull data from
  final AutonomyModel model;

  /// Default constructor for [MapRelativePainter]
  MapRelativePainter({required this.model, super.repaint});

  @override
  void paint(Canvas canvas, Size size) {
    final maxDistance = model.gridSize * models.settings.dashboard.mapBlockSize;
    final squaresPerMeter = min(size.width, size.height) / maxDistance;
    final gridScale = squaresPerMeter * models.settings.dashboard.mapBlockSize;
    final center = Offset(size.width, size.height) / 2;

    drawPath(canvas, center, squaresPerMeter, gridScale);
    drawObstacles(canvas, center, squaresPerMeter, gridScale);
    drawMarkers(canvas, center, squaresPerMeter, gridScale);
    drawDestination(canvas, center, squaresPerMeter, gridScale);
    drawRover(canvas, center, squaresPerMeter, gridScale);
  }

  /// Draw the path received from Autonomy onto the provided canvas
  void drawPath(
    Canvas canvas,
    Offset center,
    double squaresPerMeter,
    double gridScale,
  ) {
    final roverPosition = model.roverPosition.toUTM();
    final utmPoints = model.data.path.map((e) => e.toUTM());

    final pathPoints = utmPoints.map((e) {
      final roverRelative =
          Offset(e.x - roverPosition.x, roverPosition.y - e.y) *
          squaresPerMeter;
      return roverRelative;
    });

    if (pathPoints.isEmpty) {
      return;
    }
    final path = Path();
    path.moveTo(
      pathPoints.first.dx + center.dx,
      pathPoints.first.dy + center.dy,
    );

    for (final point in pathPoints) {
      path.lineTo(point.dx + center.dx, point.dy + center.dy);
    }

    final pathPaint = Paint()
      ..strokeWidth = gridScale * 0.3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..color = Colors.blueGrey;
    canvas.drawPath(path, pathPaint);

    final spotPaint = Paint()
      ..color = Colors.blueGrey.shade900
      ..strokeWidth = gridScale * 0.3;

    for (final point in pathPoints) {
      canvas.drawCircle(point + center, gridScale * 0.15, spotPaint);
    }
  }

  /// Draw the destination received from Autonomy onto the provided canvas
  void drawDestination(
    Canvas canvas,
    Offset center,
    double squaresPerMeter,
    double gridScale,
  ) {
    if (!model.data.hasDestination()) {
      return;
    }
    final roverPosition = model.roverPosition.toUTM();
    final destination = model.data.destination.toUTM();

    final point =
        Offset(
          destination.x - roverPosition.x,
          roverPosition.y - destination.y,
        ) *
        squaresPerMeter;

    final destinationPaint = Paint()
      ..color = Colors.green
      ..strokeCap = StrokeCap.round
      ..strokeWidth = gridScale * 0.25
      ..style = PaintingStyle.stroke;

    drawX(canvas, point + center, gridScale * 1, destinationPaint);
  }

  /// Draw the obstacles received from Autonomy onto the provided canvas
  void drawObstacles(
    Canvas canvas,
    Offset center,
    double squaresPerMeter,
    double gridScale,
  ) {
    final roverPosition = model.roverPosition.toUTM();

    final obstaclePoints = model.data.obstacles.map((e) {
      final coordinate = e.toUTM();
      final roverRelative =
          Offset(
            coordinate.x - roverPosition.x,
            roverPosition.y - coordinate.y,
          ) *
          squaresPerMeter;
      return roverRelative;
    });

    if (obstaclePoints.isEmpty) {
      return;
    }

    final obstaclePaint = Paint()..color = Colors.black;

    for (final point in obstaclePoints) {
      canvas.drawCircle(point + center, gridScale * 0.4, obstaclePaint);
    }
  }

  /// Draw the Rover at the center of the canvas
  void drawRover(
    Canvas canvas,
    Offset center,
    double squaresPerMeter,
    double gridScale,
  ) {
    final roverSize = gridScale * 1.5;
    final roverAngle = model.roverHeading * pi / 180;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-roverAngle);
    canvas.translate(-center.dx, -center.dy);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: center, width: roverSize, height: roverSize),
        Radius.circular(gridScale * 0.1),
      ),
      Paint()..color = Colors.blue.withValues(alpha: 0.75),
    );

    final arrowSize = roverSize * 0.25;

    final arrowPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = gridScale * 0.1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    final point1 = Offset(center.dx, center.dy + arrowSize);
    final point2 = Offset(center.dx, center.dy - arrowSize);
    drawArrow(point1, point2, canvas, arrowPaint, gridScale * 0.4);
    canvas.restore();
  }

  /// Draws an arrow from point a to point b, on [canvas], using [paint], with the head size of [arrowSize]
  void drawArrow(
    Offset a,
    Offset b,
    Canvas canvas,
    Paint paint,
    double arrowSize,
  ) {
    const arrowAngle = pi / 4;

    final dX = b.dx - a.dx;
    final dY = b.dy - a.dy;
    final angle = atan2(dY, dX);

    // Recalculate b such that it's the end of the line minus the arrow.
    final subtractedB = Offset(
      b.dx - (arrowSize / 5) * cos(angle),
      b.dy - (arrowSize / 5) * sin(angle),
    );

    canvas.drawLine(a, subtractedB, paint);
    final path = Path();

    path.moveTo(
      b.dx - arrowSize * cos(angle - arrowAngle),
      b.dy - arrowSize * sin(angle - arrowAngle),
    );
    path.lineTo(b.dx, b.dy);
    path.lineTo(
      b.dx - arrowSize * cos(angle + arrowAngle),
      b.dy - arrowSize * sin(angle + arrowAngle),
    );
    // path.close();
    canvas.drawPath(path, paint);
  }

  /// Draw the markers the user has placed onto the canvas
  void drawMarkers(
    Canvas canvas,
    Offset center,
    double squaresPerMeter,
    double gridScale,
  ) {
    final roverPosition = model.roverPosition.toUTM();

    final markerPoints = model.markers.map((e) {
      final coordinate = e.toUTM();
      final roverRelative =
          Offset(
            coordinate.x - roverPosition.x,
            roverPosition.y - coordinate.y,
          ) *
          squaresPerMeter;
      return roverRelative;
    });

    if (markerPoints.isEmpty) {
      return;
    }

    final markerPaint = Paint()
      ..color = Colors.red
      ..strokeCap = StrokeCap.round
      ..strokeWidth = gridScale * 0.15
      ..style = PaintingStyle.stroke;

    for (final point in markerPoints) {
      drawX(canvas, point + center, gridScale * 0.8, markerPaint);
    }
  }

  /// Draws an "X" on [canvas] centered at [offset]
  void drawX(Canvas canvas, Offset offset, double diameter, Paint xPaint) {
    canvas.drawLine(
      Offset(diameter / 2, diameter / 2) + offset,
      -Offset(diameter / 2, diameter / 2) + offset,
      xPaint,
    );
    canvas.drawLine(
      -Offset(-diameter / 2, diameter / 2) + offset,
      Offset(-diameter / 2, diameter / 2) + offset,
      xPaint,
    );
  }

  @override
  bool shouldRepaint(MapRelativePainter other) =>
      model != other.model || model.data != other.model.data;
}
