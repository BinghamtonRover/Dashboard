import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/src/data/metrics/gripper.dart";

/// View model for the arm inverse kinematics page
/// 
/// This view model gets its data from [RoverMetrics.arm] and [RoverMetrics.position].
class ArmModel extends ChangeNotifier{
  /// The [Metrics] model for arm data.
  ArmMetrics get arm => models.rover.metrics.arm;
  /// The [Metrics] model for gripper data.
  GripperMetrics get gripper => models.rover.metrics.gripper;

 /// Listens for updates to the arm's position (base)
  ArmModel() {
    arm.addListener(update);
    gripper.addListener(update);
    print("\nArm Metrics:\n");
    arm.allMetrics.forEach(print);
    print("\nGripper Metrics:\n");
    gripper.allMetrics.forEach(print);
  }

	@override
	void dispose() {
		arm.removeListener(update);
		gripper.removeListener(update);
		super.dispose();
	}

	/// Updates the IK graph using [addMessage] with the latest data from arm [metrics].
	void update() {
		addMessage(arm.data.wrap());
		addMessage(gripper.data.wrap());
		notifyListeners();
	}
  
  /// Adds a [WrappedMessage] containing a [ArmData] to the UI.
  void addMessage(WrappedMessage wrapper) {
    // if (wrapper.name != ArmData().messageName || wrapper.name != GripperData().messageName) throw ArgumentError("Incorrect log type: ${wrapper.name}");
  }
}
