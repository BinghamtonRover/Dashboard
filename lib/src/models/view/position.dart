import "package:flutter/material.dart";
import "dart:collection"; 
import "dart:async";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// The view model for the electrical analysis page.
class PositionModel with ChangeNotifier {
  /// The [Metrics] model for electrical data.
	PositionMetrics get metrics => models.rover.metrics.position;

  /// Listens to all the [ScienceTestBuilder]s in the UI.
	PositionModel() {
    metrics.addListener(updateData);
	}

  /// Updates the graph using [addMessage] with the latest data from [metrics].
	void updateData() {
		addMessage(metrics.data.wrap());
		notifyListeners();
	}

  /// Adds a [WrappedMessage] containing a [//NOT SURE] to the UI.
	void addMessage(WrappedMessage wrapper) {
	}
}
