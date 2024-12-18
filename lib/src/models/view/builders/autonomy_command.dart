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

	/// The handshake as received by the rover after [submit] is called.
	AutonomyCommand? _handshake;

	/// Whether the dashboard is awaiting a response from the rover.
	bool isLoading = false;

  /// A constructor to call [init] when created.
	AutonomyCommandBuilder() { init(); }

  @override
  List<ChangeNotifier> get otherBuilders => [models.rover.status];

  StreamSubscription<AutonomyCommand>? _subscription;

	/// Listens for incoming confirmations from the rover that it received the command.
  Future<void> init() async {
    await Future<void>.delayed(const Duration(seconds: 1));
		_subscription = models.messages.stream.onMessage(
			name: AutonomyCommand().messageName,
			constructor: AutonomyCommand.fromBuffer,
			callback: (data) => _handshake = data,
		);
	}

	@override
	void dispose() {
    _subscription?.cancel();
		super.dispose();
	}

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
	Future<void> submit(AutonomyCommand value) async {
		_handshake = null;
		isLoading = true;
		notifyListeners();
		models.sockets.autonomy.sendMessage(value);
		models.home.setMessage(severity: Severity.info, text: "Submitting autonomy command...");
		await Future<void>.delayed(const Duration(seconds: 1));
		if (_handshake != null) {
			models.home.setMessage(severity: Severity.info, text: "Command received");
		} else {
			models.home.setMessage(severity: Severity.error, text: "Command not received");
		}
		isLoading = false;
		notifyListeners();
	}

	/// Forces the rover to go back to the previous waypoint.
	Future<void> abort() async {
		_handshake = null;
		isLoading = true;
		notifyListeners();
		final message = AutonomyCommand(abort: true);
		// x3 just in case
		models.sockets.autonomy.sendMessage(message);
		models.sockets.autonomy.sendMessage(message);
		models.sockets.autonomy.sendMessage(message);
		models.home.setMessage(severity: Severity.info, text: "Aborting...");
		await Future<void>.delayed(const Duration(seconds: 1));
		if (_handshake != null) {
			models.home.setMessage(severity: Severity.info, text: "Command received");
		} else {
			models.home.setMessage(severity: Severity.critical, text: "Command not received");
		}
		isLoading = false;
		notifyListeners();
	}
}
