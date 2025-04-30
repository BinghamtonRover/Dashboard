import "dart:math";

import "package:flutter/material.dart";
import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/src/models/view/base_station.dart";
import "package:rover_dashboard/src/widgets/atomic/antenna_command.dart";
import "package:rover_dashboard/widgets.dart";

/// The UI for the base station
///
/// Shows a diagram of where the antenna is pointing, where the rover is relative to it,
/// and its target angle
class BaseStationPage extends ReactiveWidget<BaseStationModel> {
  /// The index of this view
  final int index;

  /// Const constructor for BaseStationPage
  const BaseStationPage({required this.index, super.key});

  @override
  BaseStationModel createModel() => BaseStationModel();

  @override
  Widget build(BuildContext context, BaseStationModel model) => Column(
    children: [
      PageHeader(
        pageIndex: index,
        children: [
          const SizedBox(width: 8),
          Text("Base Station", style: context.textTheme.headlineMedium),
          const Spacer(),
        ],
      ),
      Flexible(
        child: LayoutBuilder(
          builder:
              (context, constraints) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(flex: 3, child: _AntennaDisplay(model: model)),
                  if (constraints.maxWidth > 780)
                    Flexible(
                      flex: 2,
                      child: Card(
                        elevation: 15,
                        child: AntennaCommandEditor(model.commandBuilder),
                      ),
                    ),
                ],
              ),
        ),
      ),
    ],
  );
}

class _AntennaDisplay extends StatelessWidget {
  final BaseStationModel model;
  const _AntennaDisplay({required this.model});

  @override
  Widget build(BuildContext context) => AspectRatio(
    aspectRatio: 1,
    child: Card(
      elevation: 15,
      child: LayoutBuilder(
        builder:
            (context, constraints) => Stack(
              alignment: Alignment.center,
              children: [
                Transform.rotate(
                  angle: -model.data.antenna.swivel.currentAngle,
                  child: Icon(
                    Icons.settings_input_antenna,
                    size: constraints.maxWidth / 10,
                  ),
                ),
                CustomPaint(
                  size: Size(
                    min(constraints.maxWidth, constraints.maxHeight),
                    min(constraints.maxWidth, constraints.maxHeight),
                  ),
                  painter: _BaseStationPainter(
                    roverCoordinates: model.roverPosition,
                    stationCoordinates: model.stationPosition,
                    outlineColor: context.colorScheme.onSurface,
                    antennaAngle: model.data.antenna.swivel.currentAngle,
                    angleTolerance: models.settings.baseStation.angleTolerance,
                    targetAngle:
                        (model.data.antenna.swivel.hasTargetAngle())
                            ? model.data.antenna.swivel.targetAngle
                            : null,
                  ),
                ),
              ],
            ),
      ),
    ),
  );
}

class _BaseStationPainter extends CustomPainter {
  final GpsCoordinates roverCoordinates;
  final GpsCoordinates stationCoordinates;
  final Color outlineColor;
  final double antennaAngle;
  final double angleTolerance;
  double? targetAngle;

  _BaseStationPainter({
    required this.roverCoordinates,
    required this.stationCoordinates,
    required this.outlineColor,
    required this.antennaAngle,
    required this.angleTolerance,
    this.targetAngle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
      Offset(size.width, size.height) / 2,
      size.width / 2 * 0.9,
      Paint()
        ..color = outlineColor
        ..style = PaintingStyle.stroke,
    );
    drawRover(canvas, size);
  }

  void drawRover(Canvas canvas, Size size) {
    // The antenna angle adjusted to fit in the same rotational
    // origin as the rest of the angles for the widget
    // (0 degrees is facing to the right)
    final adjustedAntennaAngle = antennaAngle + pi / 2;

    final delta = roverCoordinates.toUTM() - stationCoordinates.toUTM();
    final deltaAngle = atan2(delta.y, delta.x);
    final uiTargetAngle =
        targetAngle != null ? targetAngle! + pi / 2 : deltaAngle;

    final roverPaint = Paint()..color = Colors.blue;

    final radius = (size.width / 2) * 0.9;
    final center = Offset(size.width, size.height) / 2;

    final roverPosition =
        center + Offset(cos(deltaAngle), -sin(deltaAngle)) * radius;

    canvas.drawCircle(roverPosition, size.width / 50, roverPaint);

    final antennaPosition =
        center +
        Offset(cos(adjustedAntennaAngle), -sin(adjustedAntennaAngle)) * radius;

    final minTolerance = uiTargetAngle - (angleTolerance / 2) * pi / 180;
    final maxTolerance = uiTargetAngle + (angleTolerance / 2) * pi / 180;

    final inRange =
        _wrapAngle(adjustedAntennaAngle - minTolerance) >= 0 &&
        _wrapAngle(adjustedAntennaAngle - maxTolerance) <= 0;

    final antennaPaint =
        Paint()
          ..color = inRange ? Colors.green : Colors.red
          ..strokeWidth = 4;
    final rangePaint =
        Paint()
          ..color = Colors.green
          ..strokeWidth = 2;

    canvas.drawLine(center, antennaPosition, antennaPaint);

    drawDashedLine(
      canvas: canvas,
      p1: center,
      p2: center + Offset(cos(minTolerance), -sin(minTolerance)) * radius * 1.1,
      dashWidth: 5,
      dashSpace: 5,
      paint: rangePaint,
    );

    drawDashedLine(
      canvas: canvas,
      p1: center,
      p2: center + Offset(cos(maxTolerance), -sin(maxTolerance)) * radius * 1.1,
      dashWidth: 5,
      dashSpace: 5,
      paint: rangePaint,
    );
  }

  void drawDashedLine({
    required Canvas canvas,
    required Offset p1,
    required Offset p2,
    required int dashWidth,
    required int dashSpace,
    required Paint paint,
  }) {
    // Get normalized distance vector from p1 to p2
    var dx = p2.dx - p1.dx;
    var dy = p2.dy - p1.dy;
    final magnitude = sqrt(dx * dx + dy * dy);
    dx = dx / magnitude;
    dy = dy / magnitude;

    // Compute number of dash segments
    final steps = magnitude ~/ (dashWidth + dashSpace);

    var startX = p1.dx;
    var startY = p1.dy;

    for (var i = 0; i < steps; i++) {
      final endX = startX + dx * dashWidth;
      final endY = startY + dy * dashWidth;
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
      startX += dx * (dashWidth + dashSpace);
      startY += dy * (dashWidth + dashSpace);
    }
  }

  double _wrapAngle(double angle) => atan2(sin(angle), cos(angle));

  @override
  bool shouldRepaint(_BaseStationPainter oldDelegate) =>
      antennaAngle != oldDelegate.antennaAngle ||
      angleTolerance != oldDelegate.angleTolerance ||
      targetAngle != oldDelegate.targetAngle ||
      outlineColor != oldDelegate.outlineColor ||
      roverCoordinates != oldDelegate.roverCoordinates ||
      stationCoordinates != oldDelegate.stationCoordinates;
}
