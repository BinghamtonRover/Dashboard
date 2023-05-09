import "dart:async";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

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

	/// Changes the sockets on the rover.
	final sockets = Sockets();

	/// Listens for inputs on the first connected gamepad.
	final controller1 = Controller(0, DriveControls());

	/// Listens for inputs on the second connected gamepad.
	final controller2 = Controller(1, ArmControls());

	/// Whether the rover is connected.
	bool get isConnected => heartbeats.connectionStrength > 0;

	/// The current status of the rover.
	/// 
	/// Since the rover obviously cannot tell us if it's disconnected,
	/// this function checks the connection strength first.
	RoverStatus get status => isConnected ? settings.settings.status : RoverStatus.DISCONNECTED; 

	@override
	Future<void> init() async { 
		await heartbeats.init();
		await metrics.init();
		await controller1.init();
		await controller2.init();
		await settings.init();
		await sockets.init();

		heartbeats.addListener(notifyListeners);
		metrics.addListener(notifyListeners);
		settings.addListener(notifyListeners);
		sockets.addListener(notifyListeners);
	}

	@override
	void dispose() {
		heartbeats.removeListener(notifyListeners);
		metrics.removeListener(notifyListeners);
		settings.removeListener(notifyListeners);
		sockets.removeListener(notifyListeners);

		heartbeats.dispose();
		metrics.dispose();
		controller1.dispose();
		controller2.dispose();
		settings.dispose();
		sockets.dispose();
		super.dispose();
	}
}
