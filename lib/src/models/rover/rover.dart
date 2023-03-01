import "dart:async";

import "package:rover_dashboard/models.dart";

import "controllers/controller.dart";
import "settings.dart";

/// The model to control the entire rover.
/// 
/// Find more specific functionality in this class's fields.
class Rover extends Model {
	/// Monitors the connection to the rover.
	final heartbeats = RoverHeartbeats();

	/// Monitors metrics coming from the rover.
	final metrics = RoverMetrics();

	/// A model to adjust settings on the rover.
	final settings = RoverSettings();

	/// The [Controller] for the current mode.
	late Controller controller;

	/// Whether the rover is connected.
	bool get isConnected => heartbeats.connectionStrength > 0;

	/// The current status of the rover.
	/// 
	/// Since the rover obviously cannot tell us if it's disconnected,
	/// this function checks the connection strength first.
	RoverStatus get status => isConnected ? settings.status : RoverStatus.DISCONNECTED; 

	@override
	Future<void> init() async { 
		controller = Controller.forMode(models.home.mode);
		await heartbeats.init();
		await metrics.init();
		await controller.init();
		await settings.init();

		heartbeats.addListener(notifyListeners);
		metrics.addListener(notifyListeners);
		settings.addListener(notifyListeners);
	}

	@override
	void dispose() {
		heartbeats.removeListener(notifyListeners);
		metrics.removeListener(notifyListeners);
		settings.removeListener(notifyListeners);

		heartbeats.dispose();
		metrics.dispose();
		controller.dispose();
		settings.dispose();
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
