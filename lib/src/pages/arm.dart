import "dart:math";

import "package:flutter/material.dart";

import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/pages.dart";
import "package:rover_dashboard/src/models/view/arm.dart";
import "package:rover_dashboard/widgets.dart";

/// A widget to paint the top-down view of the arm.
/// 
/// This is simple, just shows a line pointing in the same direction as the arm's base. For a
/// more complex side view, see [ArmPainterSide].
class ArmPainterTop extends CustomPainter {
  /// The swivel angle of the arm.
  final double swivelAngle;
  /// Paints a top-down view of the arm.
  ArmPainterTop({required this.swivelAngle});

  /// The size of the smaller dimension of the screen.
  late double screen;
  /// Converts relative coordinates from [-1, 1] to screen coordinates.
  double toAbsolute(double relative) => relative / 2 * screen;

  /// Gets the location of the shoulder joint.
  Offset getShoulder(Size size) {
    const shoulderX = 0.0;
    const shoulderY = 0.0;
    return Offset(toAbsolute(shoulderX) + size.width / 2, -toAbsolute(shoulderY) + size.height / 2);
  }

  /// Gets the location of the elbow joint.
  Offset getElbow(Size size) {
    final elbowX = cos(swivelAngle+pi/2);
    final elbowY = sin(swivelAngle+pi/2);
    return Offset(toAbsolute(elbowX) + size.width / 2, -toAbsolute(elbowY) + size.height / 2);
  }

  @override
  void paint(Canvas canvas, Size size){
    screen = min(size.width, size.height);
    final paint = Paint()
      ..color = Colors.orange
      ..strokeWidth = screen / 50
      ..strokeCap = StrokeCap.round;

    final shoulderJoint = getShoulder(size);
    final elbowJoint = getElbow(size);
    canvas.drawLine(shoulderJoint, elbowJoint, paint);
    canvas.drawCircle(shoulderJoint, screen / 40, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// A widget to show the profile view of the arm. 
/// 
/// This viewpoint shits as the arm swivels, so that it is always looking at the shoulder,
/// elbow, and wrist head-on. To visualize the swivel, see [ArmPainterTop].
class ArmPainterSide extends CustomPainter {
  /// The angles of the joints of the arm.
  final ArmAngles angles;

  /// The position of the mouse, if it's over this widget.
  final Offset? mousePosition;
  
  /// Constructor for the ArmPainterSide, takes in 3 angles
  ArmPainterSide({
    required this.angles,
    this.mousePosition,
  });

  /// The smaller screen dimension.
  late double screen;

  /// Converts from [-1, 1] relative coordinates to screen coordinates.
  double toAbsolute(double relative) => relative;

  /// The relative length of the shoulder-elbow segment.
  static const shoulderLength = 1;
  
  /// The relative length of the elbow-wrist segment.
  static const elbowLength = 0.5;
  
  /// The relative length of the gripper.
  static const gripperLength = 0.25;
  
  /// Performs forward kinematics to get the coordinates of each joint from the angles.
  ArmCoordinates getArmCoordinates(ArmAngles angles, Size size) {
    // See: https://www.desmos.com/calculator/i8grld5pdu
    const shoulderX = 0.0;
    const shoulderY = 0.0;
    final a2 = angles.shoulder - pi + angles.elbow;
    final a3 = a2 + angles.lift;
    final length = min(size.width / 4, size.height / 2);
    final elbowX = length * shoulderLength * cos(angles.shoulder);
    final elbowY = length * shoulderLength * sin(angles.shoulder);
    final wristX = length * elbowLength * cos(a2) + elbowX;
    final wristY = length * elbowLength * sin(a2) + elbowY;
    final gripperX = length * gripperLength * cos(a3) + wristX;
    final gripperY = length * gripperLength * sin(a3) + wristY;

    final shoulderJoint = Offset(toAbsolute(shoulderX) + size.width / 2, -toAbsolute(shoulderY) + size.height);
    final elbowJoint = Offset(toAbsolute(elbowX) + size.width / 2, -toAbsolute(elbowY) + size.height);
    final wristJoint = Offset(toAbsolute(wristX) + size.width / 2, -toAbsolute(wristY) + size.height);
    final gripLocation = Offset(toAbsolute(gripperX) + size.width / 2, -toAbsolute(gripperY) + size.height);
    return (shoulder: shoulderJoint, elbow: elbowJoint, wrist: wristJoint, fingers: gripLocation);
  }
    
  @override
  void paint(Canvas canvas, Size size) {
    screen = min(size.width, size.height);
    final coordinates = getArmCoordinates(angles, size);
    final length = min(size.width / 4, size.height / 2);
    paintArm(canvas, size, coordinates);
    if (mousePosition != null) {
      final cursorPaint = Paint()..color = Colors.black..style = PaintingStyle.fill;
      canvas.drawCircle(mousePosition!, screen / 50, cursorPaint);
      final ikAngles = ik(mousePosition!, size);
      final ikCoordinates = getArmCoordinates(ikAngles, size);
      paintArm(canvas, size, ikCoordinates, opacity: 0.5);
      final radiusPaint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      final radius1 = length * (shoulderLength + elbowLength);
      final radius2 = length * (shoulderLength - elbowLength);
      final rect1 = Rect.fromCircle(center: coordinates.shoulder, radius: radius1);
      final rect2 = Rect.fromCircle(center: coordinates.shoulder, radius: radius2);
      canvas.drawArc(rect1, 0, -pi, false, radiusPaint);
      canvas.drawArc(rect2, 0, -pi, false, radiusPaint);
    }
  }

  /// Performs inverse kinematics to get the angles of the arm from the desired position.
  ArmAngles ik(Offset position, Size size) {
    final length = min(size.width / 4, size.height / 2);
    const totalArmLength = shoulderLength + elbowLength;
    final radius = length * totalArmLength;
    final x = (position.dx - size.width / 2 - gripperLength) / radius;
    final y = (size.height - position.dy) / radius;
    const a = shoulderLength / totalArmLength;
    const b = elbowLength / totalArmLength;
    final c = sqrt(pow(y, 2) + pow(x, 2));
    final b1Numerator = pow(a, 2) - pow(b, 2) + pow(c, 2);
    final b1Denominator = 2 * a * c;
    final b1 = acos(b1Numerator / b1Denominator);
    final b2 = atan2(y, x);
    final shoulder = b1 + b2;
    final cNumerator = pow(a, 2) + pow(b, 2) - pow(c, 2);
    const cDenominator = 2 * a * b;
    final elbow = acos(cNumerator / cDenominator);
    if (shoulder.isNaN || elbow.isNaN) {
      return (shoulder: 0.0, elbow: pi, lift: 0);
    } else {
      return (shoulder: shoulder, elbow: elbow, lift: -1 * (shoulder + elbow) + pi);
    }
  }

  /// Paints the arm given its joint positions.
  void paintArm(Canvas canvas, Size size, ArmCoordinates coordinates, {double opacity = 1}) {
    final points = [
      coordinates.shoulder,
      coordinates.elbow,
      coordinates.wrist,
      coordinates.fingers,
    ];

    final lineColors = [
      Colors.red, 
      Colors.green, 
      Colors.blue,
    ];
    
    final firstCirclePaint = Paint()
      ..color = lineColors[0].withOpacity(opacity)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(points[0], screen / 40, firstCirclePaint);

    // Draw lines based off joint position
    for (var i = 0; i < points.length - 1; i++) {
      final paint = Paint()
        ..color = lineColors[i].withOpacity(opacity)
        ..strokeWidth = screen / 50;
      canvas.drawLine(points[i], points[i + 1], paint);
    }

    // Draw circles on each joint
    for (var i = 0; i < points.length - 1; i++) {
      final circlePaint = Paint()
        ..color = lineColors[i].withOpacity(opacity)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(points[i+1], screen / 50, circlePaint); 
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
  
/// The view model for the arm inverse kinematics analysis page.
class ArmPage extends ReactiveWidget<ArmModel> {
  @override
  ArmModel createModel() => ArmModel();

  @override
  Widget build(BuildContext context, ArmModel model) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Row(children: [  // The header at the top
        const SizedBox(width: 8),
        Text("Arm Graphs", style: context.textTheme.headlineMedium), 
        const SizedBox(width: 12),
        const Spacer(),
        const Text("Laser Light"),
        Switch(
          value: model.laser,
          activeColor: Colors.red,
          onChanged: (bool value) => model.switchLaser(),
        ),
        Text(model.laser ? "On" : "Off"),
        const SizedBox(width: 8),
        const ViewsSelector(currentView: Routes.arm),
      ],),
      const Text(
        "Side View", 
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.blue,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
      const SizedBox(height: 10),
      Expanded(
        child: Card(
          margin: const EdgeInsets.all(16),
          elevation: 16,
          color: context.colorScheme.surfaceContainerHighest,
          child: MouseRegion(
            onHover: model.onHover,
            onExit: model.cancelIK,
            cursor: SystemMouseCursors.precise,
            child: CustomPaint(
              painter: ArmPainterSide(
                angles: model.angles,
                mousePosition: model.mousePosition,
              ),
            ),
          ),
        ),
      ),
      const SizedBox(height: 8),
      // const Divider(),
      const SizedBox(height: 8),
      const Text(
        "Top View", 
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.blue,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
      Expanded(
        child: Card(
          margin: const EdgeInsets.all(16),
          elevation: 16,
          color: context.colorScheme.surfaceContainerHighest,
          child: CustomPaint(
            painter: ArmPainterTop(swivelAngle: model.arm.base.angle),
          ),
        ),
      ),
    ],
  );
}
