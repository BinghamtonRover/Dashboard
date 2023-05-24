import "dart:math";
import "dart:ui";
import "package:flutter/foundation.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

class MarsModel with ChangeNotifier {
	RoverMetrics get metrics => models.rover.metrics;
	GpsCoordinates get rover => metrics.position.data.gps;
	GpsCoordinates get baseStation => metrics.mars.data.coordinates;

	MarsModel() {
		metrics.position.addListener(update);
		metrics.mars.addListener(update);
	}

	@override
	void dispose() {
		metrics.mars.removeListener(update);
		metrics.position.removeListener(update);
		super.dispose();
	}

	Offset roverOffset = Offset.zero;
	Offset actualOffset = Offset.zero;

	void update() {
		// Update [roverX] and [roverY]
		final x = rover.longitude - baseStation.longitude;
		final y = rover.latitude - baseStation.latitude;
		final maxDistance = max(x.abs(), y.abs());
		if (maxDistance == 0) return;
		roverOffset = Offset(x / maxDistance.abs(), y / maxDistance.abs());

		// Update [actualX] and [actualY]
		final angle = metrics.mars.data.swivel;
		actualOffset = Offset(cos(angle), -sin(angle));

		notifyListeners();
	}
}
