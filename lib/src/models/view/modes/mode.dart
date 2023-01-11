import "package:flutter/foundation.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// A view model for a specific [OperatingMode].
abstract class OperatingModeModel with ChangeNotifier {
	/// The mode this model controls.
	OperatingMode get mode;

	/// The list of controls for this mode.
	List<String> get controls => [  // TODO: replace with actual backend
		"Start dig sequence: START",
		"Change operation mode: BACK",
		"Move Auger: D-pad Up/Down",
		"...",
	];

	/// The camera feeds for this mode.
	List<CameraFeed> get feeds => models.video.getFeedsForPage(mode);
}
