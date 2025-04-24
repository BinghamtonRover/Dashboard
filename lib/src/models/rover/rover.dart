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

  /// Listens for inputs on the third connected gamepad.
	final controller3 = Controller(2, NoControls());

  /// Sets all the gamepads to their default controls.
  void setDefaultControls() {
    final settings = models.settings.dashboard;
    if (settings.preferTankControls) {
      controller1.setMode(OperatingMode.drive);
    } else {
      controller1.setMode(OperatingMode.modernDrive);
    }
    controller2.setMode(OperatingMode.none);
    controller3.setMode(OperatingMode.none);
  }

  /// All the controllers on the Dashboard.
  Iterable<Controller> get controllers => [controller1, controller2, controller3];

	/// Whether the rover is connected.
	bool get isConnected => models.sockets.sockets.any((socket) => socket.isConnected);

  /// A listener to listen to status changes in all the controllers.
  Listenable get controllersListener => Listenable.merge(controllers);

	/// The current status of the rover.
	ValueNotifier<RoverStatus> status = ValueNotifier(RoverStatus.DISCONNECTED);

	@override
	Future<void> init() async {
    setDefaultControls();
    await metrics.init();
		await controller1.init();
		await controller2.init();
    await controller3.init();
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
    controller3.dispose();
		settings.dispose();
		super.dispose();
	}
}
