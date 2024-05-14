import "package:flutter/material.dart";
import "dart:async";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// The view model for the electrical analysis page.
class PositionModel with ChangeNotifier {
  /// The [Metrics] model for position data.
	PositionMetrics get position => models.rover.metrics.position;

  /// The [Metrics] model for drive data.
  DriveMetrics get drive => models.rover.metrics.drive;

  /// Value for the three left wheels -- throttle * left
  double throttle = 0;
  
  /// Value for the three left wheels -- throttle * left
  double leftWheels = 0;

  /// Value for the three right wheels -- throttle * right
  double rightWheels = 0;

  /// The timer that grabs new data for these graphs.
  Timer? timer;

  /// Listens to all the [ScienceTestBuilder]s in the UI.
	PositionModel() {
    position.addListener(_updatePositionData);
    drive.addListener(_updateDriveData);
	}

  /// Updates the UI with the latest data from [position].
	void _updatePositionData() {
		notifyListeners();
	}

  /// Updates the UI with the latest data from [drive].
	void _updateDriveData() {
    final data = drive.data;
    if(data.hasThrottle()) throttle = data.throttle;
    if(data.hasRight()) rightWheels = throttle * data.right;
    if(data.hasLeft()) leftWheels = throttle * data.left;
		notifyListeners();
	}

  @override
	void dispose() {
		position.removeListener(_updatePositionData);
    drive.removeListener(_updateDriveData);
		super.dispose();
	}
}
