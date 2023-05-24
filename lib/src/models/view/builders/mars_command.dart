import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

class MarsCommandBuilder extends ValueBuilder<MarsCommand> {
	final baseLatitude = NumberBuilder<double>(0);
	final baseLongitude = NumberBuilder<double>(0);
	final baseAltitude = NumberBuilder<double>(0);
	final roverLatitude = NumberBuilder<double>(0);
	final roverLongitude = NumberBuilder<double>(0);
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

	Future<void> send() async {
		models.sockets.mars.sendMessage(value);
		models.home.setMessage(severity: Severity.info, text: "Message sent");
		models.rover.metrics.position.update(RoverPosition(gps: value.rover));
	}
}
