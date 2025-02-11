import "dart:math";
import "dart:ui";

import "package:flutter/material.dart";
import "package:rover_dashboard/src/models/view/lidar.dart";
import "package:rover_dashboard/widgets.dart";
import "package:burt_network/burt_network.dart";

class LidarView extends ReactiveWidget<LidarModel> {
  LidarView({super.key});

  @override
  LidarModel createModel() => LidarModel();

  // hardcode for now
  final double scale = 1.5;
  final Offset offset = Offset.zero;

  @override
  Widget build(BuildContext context, LidarModel model) =>CustomPaint(
      size: Size.infinite,
      painter: LidarViewPainter(
        scale: scale,
        offset: offset,
        fov: 271,
        coordinates: model.coordinates,
      ),
      willChange: true,
  );
}

class LidarViewPainter extends CustomPainter {
  // Origin offset, origin (0,0) is at the center by default.
  final Offset offset;
  final double scale;
  final double fov;
  final double domain;
  final List<LidarCartesianPoint>? coordinates;

  const LidarViewPainter({
    required this.offset, 
    required this.scale, 
    required this.fov,
    required this.coordinates
  }) : 
    domain = scale * 2;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3.0
      ..style = PaintingStyle.fill;

    canvas.translate(size.width / 2, size.height / 2);
    canvas.translate(offset.dx, offset.dy);

    final axisPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.0;

    final List<LidarCartesianPoint> points = coordinates == null ? List<LidarCartesianPoint>.empty() : coordinates!; 

    final List<Offset> offsets = points
    .map((p) => Offset(
      // normalize to scale to cavnas
      p.x * (size.width/2) / domain, 
      p.y * (size.height / 2) / domain    
    )).toList();

    canvas.drawPoints(PointMode.points, offsets, paint);

    // axes
    canvas.drawLine(
      Offset(-size.width / 2 - offset.dx, 0),
      Offset(size.width / 2 - offset.dx, 0), 
      axisPaint,
    );
    
    canvas.drawLine(
      Offset(0, -size.height / 2 - offset.dy),  
      Offset(0, size.height / 2 - offset.dy),     
      axisPaint,
    );

    final noFovAngle = (360 - fov) * pi / 180;
    final noVisionPaint = Paint()
      ..color = Colors.grey.withOpacity(0.6)  
      ..style = PaintingStyle.fill; 

    final r = size.width * 1.2;
    final x1 = r * cos(-noFovAngle/2);
    final y1 = r * sin(-noFovAngle/2);
    final x2 = r * cos(noFovAngle/2);
    final y2 = r * sin(noFovAngle/2);

    final conePath = Path();
  
    conePath.moveTo(0, 0);
    conePath.lineTo(x1, y1);   
    conePath.lineTo(x2, y2);  
    conePath.close();     
  
    canvas.save();  
    canvas.rotate(pi/2); 
    canvas.drawPath(conePath, noVisionPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}