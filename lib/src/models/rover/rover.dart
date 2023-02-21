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

	/// Monitors metrics coming from the rover.
	final metrics = RoverMetrics();

	/// The [Controller] for the current mode.
	late Controller controller;

	/// Whether the rover is connected.
	bool get isConnected => core.connectionStrength > 0;

	@override
	Future<void> init() async { 
		controller = Controller.forMode(models.home.mode);
		await core.init();
		await metrics.init();
		await controller.init();

		core.addListener(notifyListeners);
		metrics.addListener(notifyListeners);
	}

	@override
	void dispose() {
		core.removeListener(notifyListeners);
		metrics.removeListener(notifyListeners);

		core.dispose();
		metrics.dispose();
		controller.dispose();
		super.dispose();
	}

	/// Disposes the old [controller] and chooses a new one based on [mode].
	Future<void> updateMode(OperatingMode mode) async {
		controller.dispose();
		controller = Controller.forMode(mode);
		await controller.init();
		notifyListeners();
	}
}
