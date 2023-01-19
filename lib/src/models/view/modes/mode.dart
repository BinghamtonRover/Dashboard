import "package:flutter/foundation.dart";

import "package:rover_dashboard/data.dart";

/// A view model for a specific [OperatingMode].
abstract class OperatingModeModel with ChangeNotifier {
	/// The list of controls for this mode.
	List<String> get controls => [  // TODO: replace with actual backend
		"Start dig sequence: START",
		"Change operation mode: BACK",
		"Move Auger: D-pad Up/Down",
		"...",
	];
}
