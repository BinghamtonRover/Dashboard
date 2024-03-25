import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// View model for the arm inverse kinematics page
/// 
/// This view model gets its data from [RoverMetrics.arm] and [RoverMetrics.position].
class ArmModel extends ChangeNotifier{
  /// The [Metrics] model for arm data.
  ArmMetrics get metrics => models.rover.metrics.arm;
  // q: add gripper eventually?

  /// Data from the arm
  ArmData? data;

 /// Listens for updates to the arm's position (base)
  ArmModel() {
    metrics.addListener(update);
  }

	@override
	void dispose() {
		metrics.removeListener(update);
		super.dispose();
	}

	/// Updates the IK graph using [addMessage] with the latest data from arm [metrics].
	void update() {
		addMessage(metrics.data.wrap());
		notifyListeners();
	}
  
  /// Adds a [WrappedMessage] containing a [ArmData] to the UI.
  void addMessage(WrappedMessage wrapper) {
    if (wrapper.name != ArmData().messageName) throw ArgumentError("Incorrect log type: ${wrapper.name}");
    data = wrapper.decode(ArmData.fromBuffer);
  }
}
