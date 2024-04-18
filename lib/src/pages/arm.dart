import "dart:math";

import "package:flutter/material.dart";

import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/pages.dart";
import "package:rover_dashboard/src/models/view/arm.dart";
import "package:rover_dashboard/widgets.dart";

/// CustomPainter to represent arm IK top view
class ArmPainterTop extends CustomPainter {
  // Pass data from the arm model to the painter
  /// Band lengths are in mm (actual) represented in pixels 
  // shoulder to elbow: 530mm
  // elbow to wrist: 440mm
  // wrist to grip: 310mm 

  /// The multiplied value is arbitrary - the ratios are the important things
  /// Length of the arm band from the shoulder to elbow joints
  /// L1 (constant) : physical measurement 530mm
  final double shoulderToElbow = 1;
  /// Length of the arm band  from the elbow to wrist joints
  /// L2 = .8302 * L1 : physical measurement 440mm
  final double elbowToWrist = .83027;
  /// Length of the wrist to the tip of the gripper
  /// L3 = .7045 * L2 : physical measurement 310mm
  final double wristToGrip = .7045;

  /// Angle of the base/swivel joint
  final double swivelAngle;
  /// Constructor for ArmPainterTop, takes in 1 angle
  ArmPainterTop({required this.swivelAngle});

  @override
  void paint(Canvas canvas, Size size){
    final screen = min(size.width, size.height);
    double toAbsolute(double relative) =>  // relative is [-1, 1]
      relative / 2 * screen;

    final paint = Paint()
      ..color = Colors.purple
      ..strokeWidth = screen / 50
      ..strokeCap = StrokeCap.round;

    const shoulderX = 0.0;
    const shoulderY = 0.0;

    final elbowX = shoulderToElbow * cos(swivelAngle+pi/2);
    final elbowY = shoulderToElbow * sin(swivelAngle+pi/2);

    final shoulderJoint = Offset(toAbsolute(shoulderX) + size.width/2, -toAbsolute(shoulderY)+size.height/2);
    final elbowJoint = Offset(toAbsolute(elbowX) + size.width/2, -toAbsolute(elbowY)+size.height/2);

    final points = [
      shoulderJoint,
      elbowJoint,
    ];
    canvas.drawLine(shoulderJoint, elbowJoint, paint);
    canvas.drawCircle(points[0], screen / 40, paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}


/// CustomPainter to represent arm IK side view
class ArmPainterSide extends CustomPainter {
  /// The multiplied value is arbitrary - the ratios are the important things
  /// Length of the arm band from the shoulder to elbow joints
  /// L1 (constant) : physical measurement 530mm
  static const shoulderToElbow = 1;
  /// Length of the arm band  from the elbow to wrist joints
  /// L2 = .8302 * L1 : physical measurement 440mm
  static const elbowToWrist = 1;
  /// Length of the wrist to the tip of the gripper
  /// L3 = .7045 * L2 : physical measurement 310mm
  static const wristToGrip = 1;

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
    // need to figure this stuff out: 
    // I think relative should be [0 , 1] in the Desmos graph, but I'm not sure
    // (If the arm is )
    final screen = min(size.width, size.height);
    double toAbsolute(double relative) =>  // relative is [-1, 1]
      relative / 3 * (screen - 12);  // 12px of padding
    
    // Side view x, y joint positions
    // shoulder is anchor joint at (0,0) 
    const shoulderX = 0.0;
    const shoulderY = 0.0;

    // limit the elbow angle to 0 to pi
    /// calculate the x and y positions of the elbow, wrist, and gripper joints 
    /// most of this is straight from the desmos graph
    /// a2 messes stuff up, my guess is that its related to canvas since mathematically it should work
    final elbowX = shoulderToElbow * cos(shoulderAngle);
    final elbowY = shoulderToElbow * sin(shoulderAngle);
    final a2 = shoulderAngle - pi + elbowAngle;
    final a3 = a2 + liftAngle - pi;
    final wristX = elbowToWrist * cos(a2) + elbowX;
    final wristY = elbowToWrist * sin(a2) + elbowY;
    final gripperX = wristToGrip * cos(a3) + wristX;
    final gripperY = wristToGrip * sin(a3) + wristY;

    final shoulderJoint = Offset(toAbsolute(shoulderX) + size.width/2, -toAbsolute(shoulderY)+size.height);
    final elbowJoint = Offset(toAbsolute(elbowX) + size.width/2, -toAbsolute(elbowY)+size.height);
    final wristJoint = Offset(toAbsolute(wristX) + size.width/2, -toAbsolute(wristY)+size.height);
    final gripLocation = Offset(toAbsolute(gripperX) + size.width/2, -toAbsolute(gripperY)+size.height);

    // Debug stuff
    // print("shoulderAngle $shoulderAngle, elbowX $elbowX, elbowY: $elbowY");
    // print("elbowAngle $elbowAngle, wristX $wristX, wristY: $wristY");
    // print("wristAngle $liftAngle, gripperX $gripperX, gripperY: $gripperY");

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

    canvas.drawCircle(points[0], screen / 40, firstCirclePaint);

    // Draw lines based off joint position
    for (var i = 0; i < points.length - 1; i++) {
      final paint = Paint()
        ..color = lineColors[i] 
        ..strokeWidth = screen / 50;
      canvas.drawLine(points[i], points[i + 1], paint);
    }

    // Draw circles on each joint
    for (var i = 0; i < points.length - 1; i++) {
      final circlePaint = Paint()
        ..color = lineColors[i] 
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
          child: ColoredBox(
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
      const SizedBox(height: 10,),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(right: 16, left: 16, bottom: 16),
          child: ColoredBox(
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
