import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// A [ValueBuilder] to modify and send an [AutonomyCommand].
class AutonomyCommandBuilder extends ValueBuilder<AutonomyCommand> {
	/// The type of task the rover should complete.
	AutonomyTask task = AutonomyTask.GPS_ONLY;
	/// The latitude of the destination.
	final latitude = NumberBuilder<double>(0);
	/// The longitude of the destination.
	final longitude = NumberBuilder<double>(0);

	/// The handshake as received by the rover after [submit] is called.
	AutonomyCommand? _handshake;
	/// Whether the dashboard is awaiting a response from the rover.
	bool isLoading = false;

	/// Listens for incoming confirmations from the rover that it received the command.
	AutonomyCommandBuilder() {
		models.sockets.autonomy.registerHandler<AutonomyCommand>(
			name: AutonomyCommand().messageName,
			decoder: AutonomyCommand.fromBuffer,
			handler: (data) => _handshake = data,
		);
	}

	@override
	void dispose() {
		models.sockets.autonomy.removeHandler(AutonomyCommand().messageName);
		super.dispose();
	}

	@override
	bool get isValid => latitude.isValid && longitude.isValid;

	@override
	AutonomyCommand get value => AutonomyCommand(
		destination: GpsCoordinates(latitude: latitude.value, longitude: longitude.value),
		task: task,
	);

	/// Updates the type of task being performed.
	void updateTask(AutonomyTask input) {
		task = input;
		notifyListeners();
	}

	/// Sends this command to the rover using [Sockets.autonomy].
	Future<void> submit() async {
		_handshake = null;
		isLoading = true;
		notifyListeners();
		models.sockets.autonomy.sendMessage(value);
		models.home.setMessage(severity: Severity.info, text: "Submitting autonomy command...");
		await Future<void>.delayed(const Duration(seconds: 1));
		if (_handshake != null) {
			models.home.setMessage(severity: Severity.info, text: "Command received");
		} else {
			models.home.setMessage(severity: Severity.error, text: "The rover did not receive that command");
		}
		isLoading = false;
		notifyListeners();
	}
}
