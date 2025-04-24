
import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";

/// A [CustomPainter] that can efficiently render [Bad Apple](https://www.youtube.com/watch?v=MVrNn5TuMkY).
///
/// This class is not responsible for loading the data, only for the final render of the frames.
class BadApplePainter extends CustomPainter {
  /// The current frame this painter is rendering.
  final int frameNumber;

  /// The list of "obstacles" to render, in the shape of the current frame.
  final List<GpsCoordinates> obstacles;

  /// Creates a painter that renders the given frame of Bad Apple.
  BadApplePainter({required this.frameNumber, required this.obstacles});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTRB(0, 0, size.width, size.height),
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );
    drawGrid(canvas, size);
    drawPixels(canvas, size);
  }

  /// Draws an empty grid for this frame.
  void drawGrid(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.butt;

    final borderPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke;

    // Columns
    for (var i = 1; i <= 49; i++) {
      canvas.drawLine(
        Offset(i * size.width / 50, 0),
        Offset(i * size.width / 50, size.height),
        linePaint,
      );
    }

    // Rows
    for (var i = 1; i <= 49; i++) {
      canvas.drawLine(
        Offset(0, i * size.height / 50),
        Offset(size.width, i * size.height / 50),
        linePaint,
      );
    }

    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(size.width, size.height) / 2,
        width: size.width - 1,
        height: size.height - 1,
      ),
      borderPaint,
    );
  }

  /// Draws pixels on the grid according to [obstacles].
  void drawPixels(Canvas canvas, Size size) {
    final boxWidth = size.width / 50;
    final boxHeight = size.height / 50;

    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    for (final coordinates in obstacles) {
      final rect = Rect.fromLTWH(
        size.width - (coordinates.longitude + 1) * boxHeight,
        size.height - coordinates.latitude * boxWidth,
        boxWidth,
        boxHeight,
      );
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(BadApplePainter oldDelegate) =>
    frameNumber != oldDelegate.frameNumber;
}
