import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// A [ValueBuilder] to modify and send an [AutonomyCommand].
class ScienceCommandBuilder extends ValueBuilder<ScienceCommand> {
	final sample = NumberBuilder<int>(0);

	ScienceState state = ScienceState.STOP_COLLECTING;

	bool isLoading = false;

	@override
	bool get isValid => sample.isValid;

	@override
	ScienceCommand get value => ScienceCommand(
		sample: sample.value,
		state: state,
	);

	void updateState(ScienceState input) {
		state = input;
		notifyListeners();
	}

	Future<void> send() async {
		// models.sockets.data.sendMessage(value);
		models.rover.controller1.sendMessage(value);
		models.home.setMessage(severity: Severity.info, text: "Science command submitted. Check the video feed to confirm");
	}
}
