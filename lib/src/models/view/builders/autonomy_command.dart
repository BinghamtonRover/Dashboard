import "dart:async";

import "package:flutter/foundation.dart";
import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// A [ValueBuilder] to modify and send an [AutonomyCommand].
class AutonomyCommandBuilder extends ValueBuilder<AutonomyCommand> {
	/// The type of task the rover should complete.
	AutonomyTask task = AutonomyTask.GPS_ONLY;

	/// The view model to edit the [AutonomyCommand.destination].
	final gps = GpsBuilder();

	/// Whether the dashboard is awaiting a response from the rover.
	bool isLoading = false;

  /// A constructor for AutonomyCommandBuilder
	AutonomyCommandBuilder();

  @override
  List<ChangeNotifier> get otherBuilders => [models.rover.status];

	@override
	bool get isValid => gps.isValid;

	@override
	AutonomyCommand get value => AutonomyCommand(
		destination: gps.value,
		task: task,
	);

	/// Updates the type of task being performed.
	void updateTask(AutonomyTask input) {
		task = input;
		notifyListeners();
	}

	/// Sends this command to the rover using [Sockets.autonomy].
	Future<void> submit() async {
		isLoading = true;
		notifyListeners();
		models.sockets.autonomy.sendMessage(value);
		models.home.setMessage(severity: Severity.info, text: "Submitting autonomy command...");
		await Future<void>.delayed(const Duration(seconds: 1));
    if (await models.sockets.autonomy.tryHandshake(
      message: value,
      timeout: const Duration(seconds: 1),
      constructor: AutonomyCommand.fromBuffer,
    )) {
			models.home.setMessage(severity: Severity.info, text: "Command received");
		} else {
			models.home.setMessage(severity: Severity.error, text: "Command not received");
		}
		isLoading = false;
		notifyListeners();
	}

	/// Forces the rover to go back to the previous waypoint.
	Future<void> abort() async {
		isLoading = true;
		notifyListeners();
		final message = AutonomyCommand(abort: true);
		// x3 just in case
		models.sockets.autonomy.sendMessage(message);
		models.sockets.autonomy.sendMessage(message);
		models.home.setMessage(severity: Severity.info, text: "Aborting...");
    if (await models.sockets.autonomy.tryHandshake(
      message: message,
      timeout: const Duration(seconds: 1),
      constructor: AutonomyCommand.fromBuffer,
    )) {
			models.home.setMessage(severity: Severity.info, text: "Command received");
		} else {
			models.home.setMessage(severity: Severity.critical, text: "Command not received");
		}
		isLoading = false;
		notifyListeners();
	}
}
