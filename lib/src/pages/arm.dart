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
  final double shoulderToElbowLength = 530/8;
  /// Length of the arm band  from the elbow to wrist joints
  final double elbowToWristLength = 440/8;
  /// Length of the wrist to the tip of the gripper
  final double wristToGripLength = 310/8;

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
  // shoulder to elbow: 530mm
  // elbow to wrist: 440mm
  // wrist to grip: 310mm 

  /// The multiplied value is arbitrary - the ratios are the important things
  /// Length of the arm band from the shoulder to elbow joints
  /// L1 (constant) : physical measurement 530mm
  final double shoulderToElbow = 1*200;
  /// Length of the arm band  from the elbow to wrist joints
  /// L2 = .8302 * L1 : physical measurement 440mm
  final double elbowToWrist = .8302*200;
  /// Length of the wrist to the tip of the gripper
  /// L3 = .7045 * L2 : physical measurement 310mm
  final double wristToGrip = .7045*200;


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

    // need to figure this stuff out: 
    // I think relative should be [0 , 1] in the desmos graph, but I'm not sure
    // (If the arm is )
    final r = min(size.width, size.height);
    double toAbsolute(double relative) =>  // relative is [-1, 1]
      (relative + 1) / 2 * r;
    
    // Side view x, y joint positions
    // shoulder is anchor joint at (0,0) 
    const shoulderX = 0.0;
    const shoulderY = 0.0;
    // limit the elbow angle to 0 to pi
    final a2 = shoulderAngle - pi + elbowAngle;
    /// calculate the x and y positions of the elbow, wrist, and gripper joints 
    /// most of this is straight from the desmos graph
    /// a2 messes stuff up, my guess is that its related to canvas since mathematically it should work
    final elbowX = shoulderToElbow * cos(shoulderAngle);
    final elbowY = shoulderToElbow * sin(shoulderAngle);
    final wristX = elbowToWrist * cos(elbowAngle) + elbowX;
    final wristY = elbowToWrist * sin(elbowAngle) + elbowY;
    final gripperX = wristToGrip * cos(liftAngle) + wristX;
    final gripperY = wristToGrip * sin(liftAngle) + wristY;

    const shoulderJoint = Offset(shoulderX, shoulderY);
    final elbowJoint = Offset(elbowX, elbowY );
    final wristJoint = Offset(wristX, wristY);
    final gripLocation = Offset(gripperX, gripperY);
    // final shoulderJoint = Offset(toAbsolute(shoulderX), toAbsolute(shoulderY));
    // final elbowJoint = Offset(toAbsolute(elbowX), toAbsolute(elbowY));
    // final wristJoint = Offset(toAbsolute(wristX), toAbsolute(wristY));
    // final gripLocation = Offset(toAbsolute(gripperX), toAbsolute(gripperY));

    /// UPDATE: 
    /// I need help converting x and y joint positions to the canvas


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

    canvas.drawCircle(points[0], 12, firstCirclePaint);

    // /// Draw lines based off joint position
    for (var i = 0; i < points.length - 1; i++) {
      final paint = Paint()
        ..color = lineColors[i] 
        ..strokeWidth = 10;
      canvas.drawLine(points[i], points[i + 1], paint);
    }

    // /// Draw circles on each joint
    for (var i = 0; i < points.length - 1; i++) {
      final circlePaint = Paint()
        ..color = lineColors[i] 
        ..style = PaintingStyle.fill;
      canvas.drawCircle(points[i+1], 10, circlePaint); 
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


