import "dart:async";
import "package:flutter/foundation.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

import "settings.dart";

/// The model to control the entire rover.
/// 
/// Find more specific functionality in this class's fields.
class Rover extends Model {
	/// Monitors metrics coming from the rover.
	final metrics = RoverMetrics();

	/// A model to adjust settings on the rover.
	final settings = RoverSettings();

	/// Listens for inputs on the first connected gamepad.
	final controller1 = Controller(0, DriveControls());

	/// Listens for inputs on the second connected gamepad.
	final controller2 = Controller(1, ArmControls());

	/// Whether the rover is connected.
	bool get isConnected => models.sockets.data.isConnected;

	/// The current status of the rover.
	ValueNotifier<RoverStatus> status = ValueNotifier(RoverStatus.DISCONNECTED);

	@override
	Future<void> init() async { 
		await metrics.init();
		await controller1.init();
		await controller2.init();
		await settings.init();

		metrics.addListener(notifyListeners);
		settings.addListener(notifyListeners);
	}

	@override
	void dispose() {
		metrics.removeListener(notifyListeners);
		settings.removeListener(notifyListeners);

		metrics.dispose();
		controller1.dispose();
		controller2.dispose();
		settings.dispose();
		super.dispose();
	}
}
