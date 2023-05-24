import "dart:math";
import "dart:ui";
import "package:flutter/foundation.dart";

import "package:rover_dashboard/models.dart";

/// A view model for the MARS page.
/// 
/// This model tracks the rover's position on-screen and the orientation of the MARS antenna. This
/// view model gets its data from [RoverMetrics.mars] and [RoverMetrics.position].
class MarsModel with ChangeNotifier {
	/// A shorthand for accessing [Rover.metrics].
	RoverMetrics get metrics => models.rover.metrics;

	/// Listens for updates to the rover's position or the MARS antenna's orientation.
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

	/// The position of the rover on-screen.
	Offset roverOffset = Offset.zero;

	/// The position of the base station on-screen.
	Offset actualOffset = Offset.zero;

	/// Updates [roverOffset] and [actualOffset] based on new data.
	void update() {
		final rover = metrics.position.data.gps;
		final baseStation = metrics.mars.data.coordinates;
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
