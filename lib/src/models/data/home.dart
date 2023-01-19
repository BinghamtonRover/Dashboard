import "package:rover_dashboard/data.dart";

import "model.dart";

/// The view model for the main page. 
class HomeModel extends Model {
	/// The current operating mode.
	OperatingMode mode = OperatingMode.science;

	@override
	Future<void> init() async { } 

	/// The list of controls for this mode.
	List<String> get controls => [  // TODO: replace with actual backend
		"Start dig sequence: START",
		"Change operation mode: BACK",
		"Move Auger: D-pad Up/Down",
		"...",
	];

	/// Changes the mode based on an index.  
	void changeMode(int index) {
		mode = OperatingMode.values[index];
		notifyListeners();
	}
}
