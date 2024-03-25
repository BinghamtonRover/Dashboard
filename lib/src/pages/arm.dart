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
      ..strokeWidth = 30;

    // Side view x, y joint locations
    const shoulderJoint = Offset.zero;
    final elbowJoint = Offset(shoulderJoint.dx+shoulderToElbowLength, 5);
    final wristJoint = Offset(elbowJoint.dx+elbowToWristLength, 5);
    final gripLocation = Offset(wristJoint.dx+wristToGripLength, 5);

    canvas.drawLine(shoulderJoint, elbowJoint, paint);
    canvas.drawLine(elbowJoint, wristJoint, paint);
    canvas.drawLine(wristJoint, gripLocation, paint);
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
          padding: EdgeInsets.only(right: 16, left: 16),
          child: Container(
            color: Color.fromARGB(204, 112, 108, 108),
            child: const CustomPaint(
            painter: ArmPainter(
              shoulderToElbowLength: 100,
              elbowToWristLength: 80,
              wristToGripLength: 40,
              ),
            ), 
          ),
        ),
      ),
    ],
  );
}


