import "dart:async";

import "../model.dart";
import "core.dart";

/// The model to control the entire rover.
/// 
/// Find more specific functionality in this class's fields.
class Rover extends Model {
	/// Monitors the connection to the rover.
	final core = RoverCore();

	/// Whether the rover is connected.
	bool get isConnected => core.connectionStrength > 0;

	@override
	Future<void> init() async { 
		await core.init();

		core.addListener(notifyListeners);
	}

	@override
	void dispose() {
		core.dispose();

		core.removeListener(notifyListeners);
		super.dispose();
	}
}
