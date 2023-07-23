import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// A [ValueBuilder] to modify and send an [AutonomyCommand].
class ScienceCommandBuilder extends ValueBuilder<ScienceCommand> {
	/// The sample number being tested.
	final sample = NumberBuilder<int>(1, min: 1, max: 3);

	/// Whether the science program should collect data.
	ScienceState state = ScienceState.STOP_COLLECTING;

	/// Listens to changes in the sample number.
	@override
	List<ValueBuilder<dynamic>> get otherBuilders => [sample];

	@override
	bool get isValid => sample.isValid;

	@override
	ScienceCommand get value => ScienceCommand(
		sample: sample.value,
		state: state,
	);

	/// Updates the state and refreshes the UI.
	void updateState(ScienceState input) {
		state = input;
		notifyListeners();
	}

	/// Sends the command to the science subsystem.
	Future<void> send() async {
		models.messages.sendMessage(value);
		models.home.setMessage(severity: Severity.info, text: "Science command submitted. Check the video feed to confirm");
	}
}
