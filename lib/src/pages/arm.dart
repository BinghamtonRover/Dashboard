import "dart:ui";

import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";

import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/pages.dart";
import "package:rover_dashboard/src/models/view/arm.dart";
import "package:rover_dashboard/widgets.dart";

/// CustomPainter to represent arm IK
class ArmPainter extends CustomPainter {
  // pass data from the arm model to the painter
  // band lengths (defined by the rover's physical design)
  final double shoulderToElbowLength;
  final double elbowToWristLength;
  final double wristToGripLength;
  // joint angles (variable)
  final double? shoulderPitchAngle;
  final double? shoulderYawAngle;
  final double? elbowPitchAngle;
  final double? wristRollAngle;
  final double? wristPitchAngle;


  const ArmPainter({
    required this.shoulderToElbowLength,
    required this.elbowToWristLength,
    required this.wristToGripLength,
    this.shoulderPitchAngle,
    this.shoulderYawAngle,
    this.elbowPitchAngle,
    this.wristRollAngle,
    this.wristPitchAngle,
    });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color.fromARGB(255, 59, 42, 88)
      ..strokeWidth = 20;

    // Side view x, y joint locations
    final shoulderJoint = Offset(0,size.height);
    final elbowJoint = Offset(shoulderJoint.dx+shoulderToElbowLength, size.height/1.5);
    final wristJoint = Offset(elbowJoint.dx+elbowToWristLength, size.height/1.7);
    final gripLocation = Offset(wristJoint.dx+wristToGripLength, size.height/1.7+ 40);

    final points = [
      shoulderJoint,
      elbowJoint,
      wristJoint,
      gripLocation,
    ];

    final lineColors = [
      Colors.red,
      Colors.green,
      Colors.blue,
    ];
    
    final firstCirclePaint = Paint()
      ..color = Colors.red 
      ..style = PaintingStyle.fill;

    canvas.drawCircle(points[0], 25, firstCirclePaint);

    for (var i = 0; i < points.length - 1; i++) {
      final paint = Paint()
        ..color = lineColors[i] 
        ..strokeWidth = 15;
      canvas.drawLine(points[i], points[i + 1], paint);
    }

    for (var i = 0; i < points.length - 1; i++) {
      final circlePaint = Paint()
        ..color = lineColors[i] 
        ..style = PaintingStyle.fill;
      canvas.drawCircle(points[i+1], 15, circlePaint); 
    }
  
    // canvas.drawPoints(PointMode.polygon, points, paint);
    // canvas.drawLine(shoulderJoint, elbowJoint, paint);
    // canvas.drawLine(elbowJoint, wristJoint, paint);
    // canvas.drawLine(wristJoint, gripLocation, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// The view model for the arm inverse kinematics analysis page.
/// Based off of the eletrical page
class ArmPage extends ReactiveWidget<ArmModel> {
  @override
  ArmModel createModel() => ArmModel();

  @override
  Widget build(BuildContext context, ArmModel model) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Row(children: [  // The header at the top
        const SizedBox(width: 8),
        Text("Arm Inverse Kinematics", style: context.textTheme.headlineMedium), 
        const SizedBox(width: 12),
        const Spacer(),
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
      const SizedBox(height: 10,),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(right: 16, left: 16, bottom: 16),
          child: Container(
            color: Color.fromARGB(204, 112, 108, 108),
            child: const CustomPaint(
            painter: ArmPainter(
              shoulderToElbowLength: 350,
              elbowToWristLength: 300,
              wristToGripLength: 140,
              ),
            ), 
          ),
        ),
      ),
    ],
  );
}


