import "dart:async";

import "package:rover_dashboard/models.dart";

import "../model.dart";
import "controller.dart";

/// The model to control the entire rover.
/// 
/// Find more specific functionality in this class's fields.
class Rover extends Model {
	/// Monitors the connection to the rover.
	final core = RoverCore();

	late Controller controller;

	/// Whether the rover is connected.
	bool get isConnected => core.connectionStrength > 0;

	@override
	Future<void> init() async { 
		controller = Controller.forMode(models.home.mode);
		await controller.init();
		await core.init();

		core.addListener(notifyListeners);
	}

	@override
	void dispose() {
		core.dispose();

		core.removeListener(notifyListeners);
		super.dispose();
	}

	Future<void> updateMode(OperatingMode mode) async {
		controller.dispose();
		controller = Controller.forMode(mode);
		await controller.init();
		notifyListeners();
	}
}
