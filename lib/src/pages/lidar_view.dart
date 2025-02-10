import "dart:math";
import "dart:ui";

import "package:flutter/gestures.dart";
import "package:flutter/material.dart";

class LidarView extends StatefulWidget {
  const LidarView({super.key});

  @override
  State<LidarView> createState() => _LidarViewState();
}

class _LidarViewState extends State<LidarView> {
  double scale = 1.0;
  Offset offset = Offset.zero;

  bool isPanning = false;
  Offset? lastPanPoint;

  void _onPointerDown(PointerDownEvent event) {
    isPanning = true;
    lastPanPoint = event.localPosition;
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (!isPanning) return;
    
    if (lastPanPoint != null) {
      setState(() {
        final delta = event.localPosition - lastPanPoint!;
        offset += delta;
        lastPanPoint = event.localPosition;
      });
    }
  }

  void _onPointerUp(PointerUpEvent event) {
    isPanning = false;
    lastPanPoint = null;
  }

  void _onPointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent) {
      setState(() {
        final newScale = scale * (event.scrollDelta.dy < 0 ? 0.9 : 1.1);
        scale = newScale;
      });
    }
  }

  @override
  Widget build(BuildContext context) => Listener(
    onPointerSignal: _onPointerSignal,
    onPointerDown: _onPointerDown,
    onPointerMove: _onPointerMove,
    onPointerUp: _onPointerUp,
      child: CustomPaint(
        size: Size.infinite,
        painter: LidarViewPainter(
          scale: scale,
          offset: offset,
          fov: 271,
        ),
      ),
    );
}

class LidarViewPainter extends CustomPainter {
  // Origin offset, origin (0,0) is at the center by default.
  final Offset offset;
  final double scale;
  final double fov;
  final double domain;
  LidarViewPainter({required this.offset, required this.scale, required this.fov}) : 
    domain = scale * 2;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3.0
      ..style = PaintingStyle.fill;

    canvas.translate(size.width / 2, size.height / 2);
    canvas.translate(offset.dx, offset.dy);

    final axisPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.0;

    // TODO! test
    final List<double> points = [
      -0.247, -0.247, -0.238, -0.246, -0.233, -0.249, -0.228, -0.253, -0.221, -0.254, -0.213, -0.254, -0.332, -0.410, -0.403, -0.515, -0.401, -0.532, -0.387, -0.533, -0.376, -0.537, -0.369, -0.547, -0.359, -0.553, -0.351, -0.562, -0.341, -0.568, -0.337, -0.584, -0.327, -0.589, -0.316, -0.595, -0.308, -0.604, -0.297, -0.608, -0.289, -0.620, -0.279, -0.628, -0.270, -0.636, -0.261, -0.647, -0.252, -0.657, -0.248, -0.682, -0.237, -0.689, -0.228, -0.702, -0.216, -0.706, -0.206, -0.718, -0.194, -0.724, -0.176, -0.707, -0.163, -0.704, -0.151, -0.711, -0.140, -0.721, -0.130, -0.735, -0.118, -0.744, -0.105, -0.750, -0.093, -0.758, -0.081, -0.773, -0.069, -0.783, -0.055, -0.792, -0.042, -0.811, -0.028, -0.816, -0.014, -0.824, -0.000, -0.834, 0.015, -0.852, 0.031, -0.875, 0.046, -0.879, 0.063, -0.895, 0.077, -0.884, 0.050, -0.473, 0.050, -0.410, 0.057, -0.408, 0.063, -0.396, 0.067, -0.381, 0.075, -0.386, 0.079, -0.372, 0.086, -0.372, 0.091, -0.364, 0.093, -0.349, 0.100, -0.347, 0.104, -0.340, 0.109, -0.336, 0.113, -0.327, 0.117, -0.320, 0.116, -0.302, 0.123, -0.304, 0.125, -0.295, 0.631, -1.417, 0.000, 0.000, 0.694, -1.424, 0.749, -1.470, 0.806, -1.515, 0.869, -1.567, 0.945, -1.637, 0.251, -0.418, 1.012, -1.619, 0.347, -0.534, 1.073, -1.532, 0.320, -0.425, 1.131, -1.448, 1.152, -1.423, 1.172, -1.397, 1.196, -1.376, 1.218, -1.353, 1.236, -1.325, 1.259, -1.303, 1.275, -1.275, 1.292, -1.248, 1.310, -1.221, 1.332, -1.199, 1.350, -1.174, 1.390, -1.167, 1.420, -1.150, 1.429, -1.117, 0.002, -0.001, 0.002, -0.001, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.685, 0.222, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 1.758, 0.820, 1.718, 0.838, 1.696, 0.864, 1.722, 1.118, 1.707, 1.151, 1.661, 1.163, 1.653, 1.201, 1.751, 1.319, 1.828, 1.428, 1.688, 1.367, 1.622, 1.361, 1.598, 1.390, 1.258, 1.173, 1.241, 1.198, 1.218, 1.218, 1.186, 1.229, 1.163, 1.248, 1.145, 1.272, 1.082, 1.245, 1.063, 1.267, 1.041, 1.285, 1.017, 1.302, 1.009, 1.339, 1.068, 1.470, 1.126, 1.669, 0.943, 1.453, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.001, 0.002, 0.000, 0.000, 0.000, 0.000, -0.024, 0.699, -0.035, 0.673, -0.045, 0.648, -0.055, 0.627, -0.064, 0.606, -0.073, 0.593, -0.082, 0.581, -0.090, 0.568, -0.099, 0.560, -0.101, 0.521, -0.083, 0.390, -0.085, 0.367, -0.093, 0.372, -0.096, 0.359, -0.103, 0.360, -0.108, 0.353, -0.112, 0.343, -0.120, 0.349, -0.122, 0.335, -0.128, 0.333, -0.131, 0.325, -0.136, 0.321, -0.147, 0.330, -0.150, 0.323, -0.159, 0.326, -0.163, 0.321, -0.168, 0.316, -0.176, 0.317, -0.197, 0.340, -0.220, 0.367, -0.298, 0.477, -0.346, 0.533, -0.690, 1.023, -0.722, 1.030, -0.744, 1.023, -0.476, 0.609, -0.482, 0.595, -0.480, 0.571, -0.487, 0.560, -0.499, 0.554, -0.508, 0.545, -0.518, 0.537, -0.535, 0.535, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000
    ];

    final List<Offset> offsets = points
    .asMap()
    .entries
    .where((entry) => entry.key.isEven && entry.key < points.length - 1)
    .map((entry) => Offset(
      // normalize to scale to cavnas
      points[entry.key] * (size.width/2) / domain, 
      -points[entry.key + 1] * (size.height / 2) / domain       
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