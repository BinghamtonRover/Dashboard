import "dart:async";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// View model for the arm inverse kinematics page
///
/// This view model gets its data from [RoverMetrics.arm] and [RoverMetrics.position].
class ArmModel with ChangeNotifier {
  /// The [Metrics] model for arm data.
  ArmData get arm => models.rover.metrics.arm.data;

  /// The [Metrics] model for gripper data.
  GripperData get gripper => models.rover.metrics.gripper.data;

  /// The timer that updates this page.
  Timer? timer;

  /// Starts a timer to refresh at 100 Hz.
  ArmModel() {
    timer = Timer.periodic(const Duration(milliseconds: 10), _update);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _update([_]) {
    notifyListeners();
  }

  /// Sets the laser on or off
  void setLaser({required bool laser}) {
    final command = GripperCommand(laserState: laser ? BoolState.ON : BoolState.OFF);
    models.messages.sendMessage(command);
  }

  /// The angles of the arm.
  ArmAngles get angles => (
        shoulder: arm.shoulder.angle,
        elbow: arm.elbow.angle,
        lift: gripper.lift.angle,
      );

  /// The position of the mouse, if it's in the box.
  Offset? mousePosition;

  /// The angles to send the arm to [mousePosition].
  ArmAngles? ikAngles;

  /// Updates the position of the mouse to [mousePosition].
  void onHover(PointerHoverEvent event) {
    mousePosition = event.localPosition;
    notifyListeners();
  }

  /// Clears [mousePosition].
  void cancelIK(_) {
    mousePosition = null;
    notifyListeners();
  }

  /// Sends a command to the arm to go to [ikAngles].
  void sendIK() {
    if (ikAngles == null) return;
    final shoulderCommand = MotorCommand(angle: ikAngles!.shoulder);
    final elbowCommand = MotorCommand(angle: ikAngles!.elbow);
    final liftCommand = MotorCommand(angle: ikAngles!.lift);
    final armCommand = ArmCommand(shoulder: shoulderCommand, elbow: elbowCommand);
    final gripperCommand = GripperCommand(lift: liftCommand);
    models.messages.sendMessage(armCommand);
    models.messages.sendMessage(gripperCommand);
  }
}

/// The three angles of the arm joints: shoulder, elbow, and lift. Swivel is not included.
typedef ArmAngles = ({double shoulder, double elbow, double lift});

/// The coordinates of each joint of the arm.
typedef ArmCoordinates = ({
  Offset shoulder,
  Offset elbow,
  Offset wrist,
  Offset fingers,
});
