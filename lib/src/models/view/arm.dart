import "dart:async";

import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// View model for the arm inverse kinematics page
/// 
/// This view model gets its data from [RoverMetrics.arm] and [RoverMetrics.position].
class ArmModel with ChangeNotifier{
  /// The [Metrics] model for arm data.
  ArmMetrics get arm => models.rover.metrics.arm;
  /// The [Metrics] model for gripper data.
  GripperMetrics get gripper => models.rover.metrics.gripper;

  Timer? timer;

  ArmModel() {
    timer = Timer.periodic(const Duration(milliseconds: 10), _update);
  }

	@override
	void dispose() {
    timer?.cancel();
		super.dispose();
	}

	void _update([_]) => notifyListeners();
}
