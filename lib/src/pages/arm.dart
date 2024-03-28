import "dart:ui";
import "dart:math";

import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:rover_dashboard/data.dart";

import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/pages.dart";
import "package:rover_dashboard/src/models/view/arm.dart";
import "package:rover_dashboard/widgets.dart";

/// CustomPainter to represent arm IK top view
class ArmPainterTop extends CustomPainter {
  /// Length of the arm band from the shoulder to elbow joints
  final double shoulderToElbowLength = 530;
  /// Length of the arm band  from the elbow to wrist joints
  final double elbowToWristLength = 440;
  /// Length of the wrist to the tip of the gripper
  final double wristToGripLength = 310;

  /// Angle of the base/swivel joint
  final double swivelAngle;
  /// Constructor for ArmPainterTop, takes in 1 angle
  ArmPainterTop({
    required this.swivelAngle
  });

  @override
  void paint(Canvas canvas, Size size){
    final paint = Paint()
      ..color = Color.fromARGB(255, 59, 42, 88)
      ..strokeWidth = 15;

  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// CustomPainter to represent arm IK side view
class ArmPainterSide extends CustomPainter {
  // pass data from the arm model to the painter
  // Band lengths (defined by the rover's physical design) 
  /// Band lengths are in mm (actual) represented in pixels 

  /// Length of the arm band from the shoulder to elbow joints
  final double shoulderToElbowLength = 1;
  /// Length of the arm band  from the elbow to wrist joints
  final double elbowToWristLength = 440/4;
  /// Length of the wrist to the tip of the gripper
  final double wristToGripLength = 310/4;


  // All angles are 2D - only 3 joints
  // Shoulder joint is the base (0,max_height) 
  // Elbow joint is the middle 
  // Wrist joint is the end 
  /// Angle between the shoulder and elbow joints
  final double shoulderAngle;
  /// Angle between the elbow and wrist joints
  final double elbowAngle;
  /// Angle between the wrist joint and tip of the gripper
  final double liftAngle;
  
  /// Constructor for the ArmPainterSide, takes in 3 angles
  ArmPainterSide({
    required this.shoulderAngle,
    required this.elbowAngle,
    required this.liftAngle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color.fromARGB(255, 59, 42, 88)
      ..strokeWidth = 15;

    final r = min(size.width, size.height);
    double toAbsolute(double relative) =>  // relative is [-1, 1]
      (relative + 1) / 2 * r;
    
    // Side view x, y joint locations
    // placeholders 
    final a2 = shoulderAngle - pi + elbowAngle;
    final shoulderLength = 1;
    final shoulderX = 0.0;
    final shoulderY = 0.0;
    final double elbowX = elbowToWristLength * cos(shoulderAngle);
    final double elbowY = elbowToWristLength * sin(shoulderAngle);
    final wristX = 0.5;
    final wristY = 0.5;
    final gripperX = 0.75;
    final gripperY = 0.75;
    final shoulderJoint = Offset(toAbsolute(shoulderX), toAbsolute(shoulderY));
    final elbowJoint = Offset(toAbsolute(elbowX), toAbsolute(elbowY));
    final wristJoint = Offset(toAbsolute(wristX), toAbsolute(wristY));
    final gripLocation = Offset(toAbsolute(gripperX), toAbsolute(gripperY));
    print("shoulderAngle $shoulderAngle, elbowX $elbowX, elbowY: $elbowY");

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

    canvas.drawCircle(points[0], 20, firstCirclePaint);

    // /// Draw lines based off joint position
    for (var i = 0; i < points.length - 1; i++) {
      final paint = Paint()
        ..color = lineColors[i] 
        ..strokeWidth = 15;
      canvas.drawLine(points[i], points[i + 1], paint);
    }

    // /// Draw circles on each joint
    for (var i = 0; i < points.length - 1; i++) {
      final circlePaint = Paint()
        ..color = lineColors[i] 
        ..style = PaintingStyle.fill;
      canvas.drawCircle(points[i+1], 15, circlePaint); 
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
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
            child: CustomPaint(
              painter: ArmPainterSide(
                shoulderAngle: model.arm.data.shoulder.angle,
                elbowAngle: model.arm.data.elbow.angle,
                liftAngle: model.gripper.data.lift.angle,
                ),
              ), 
          ),
        ),
      ),
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
      // OutlinedButton(
      //       style: OutlinedButton.styleFrom(
      //         side: const BorderSide(
      //           color: Colors.red,
      //         ),
      //       ),
      //       onPressed: model.animateArm,
      //       child: const Text("Animatation Test"),
      //     ),
      const SizedBox(height: 10,),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(right: 16, left: 16, bottom: 16),
          child: Container(
            color: Color.fromARGB(204, 112, 108, 108),
            child: CustomPaint(
            painter: ArmPainterTop(
              swivelAngle: model.arm.data.base.angle,
              ),
            ), 
          ),
        ),
      ),
    ],
  );
}


