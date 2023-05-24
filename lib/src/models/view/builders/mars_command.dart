import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// A [ValueBuilder] to modify a [MarsCommand].
class MarsCommandBuilder extends ValueBuilder<MarsCommand> {
	/// The base station's latitude.
	final baseLatitude = NumberBuilder<double>(0);
	/// The base station's longitude.
	final baseLongitude = NumberBuilder<double>(0);
	/// The base station's altitude.
	final baseAltitude = NumberBuilder<double>(0);
	/// The rover's latitude.
	final roverLatitude = NumberBuilder<double>(0);
	/// The rover's longitude.
	final roverLongitude = NumberBuilder<double>(0);
	/// The rover's altitude.
	final roverAltitude = NumberBuilder<double>(0);

	@override
	bool get isValid => 
		baseLatitude.isValid && baseLongitude.isValid && baseAltitude.isValid
		&& roverLatitude.isValid && roverLongitude.isValid && roverAltitude.isValid;

	@override
	MarsCommand get value => MarsCommand(
		baseStationOverride: GpsCoordinates(latitude: baseLatitude.value, longitude: baseLongitude.value, altitude: baseAltitude.value),
		rover: GpsCoordinates(latitude: roverLatitude.value, longitude: roverLongitude.value, altitude: roverAltitude.value),
	);

	/// Sends a [MarsCommand] with the values in this model.
	Future<void> send() async {
		models.sockets.mars.sendMessage(value);
		models.home.setMessage(severity: Severity.info, text: "Message sent");
	}
}
