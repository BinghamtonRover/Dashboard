import "dart:async";

import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// View model for the arm inverse kinematics page
/// 
/// This view model gets its data from [RoverMetrics.arm] and [RoverMetrics.position].
class ArmModel with ChangeNotifier{
  /// The [Metrics] model for arm data.
  ArmData get arm => models.rover.metrics.arm.data;
  /// The [Metrics] model for gripper data.
  GripperData get gripper => models.rover.metrics.gripper.data;

  /// The timer that updates this page.
  Timer? timer;

  /// Whether or not laser is on
  bool laser = false;

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
    final command = GripperCommand(laserState: laser ? BoolState.ON : BoolState.OFF);
    models.messages.sendMessage(command);
  }

  /// updates the state of [laser]
  void switchLaser(){
    laser = !laser;
  }
}
