import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";

/// The amount of time to wait between sending a request and receiving a confirmation.
const confirmationDelay = Duration(milliseconds: 100);

/// Updates sensitive settings on the rover.
/// 
/// Certain settings need confirmation that they were actually changed. Due to the nature of UDP, 
/// we have no way to actually guarantee this, so we simply ask that the rover send the exact same
/// message in response (see [UpdateSetting]). If we do not get the response after waiting for a
/// confirmationDelay], we conclude that the rover didn't receive our request, similar to heartbeat.
class RoverSettings extends Model {
	/// The settings we will send to the rover.
	UpdateSetting settings = UpdateSetting(status: RoverStatus.MANUAL);

	/// The last received confirmation
	UpdateSetting? _confirmation;

	@override
	Future<void> init() async {
		services.dataSocket.registerHandler<UpdateSetting>(
			name: UpdateSetting().messageName,
			decoder: UpdateSetting.fromBuffer,
			handler: (settings) => _confirmation = settings,
		);
	}

	/// Sends an [UpdateSetting] and awaits a response.
	/// 
	/// The response must be an echo of the data sent, to ensure the rover acknowledges the data.
	Future<bool> tryChangeSettings(UpdateSetting value) async {
		services.dataSocket.sendMessage(value);
		await Future<void>.delayed(confirmationDelay);
		return value == _confirmation;
	}

	/// Sets the status of the rover.
	/// 
	/// See [RoverStatus] for details.
	Future<void> setStatus(RoverStatus value) async {
		final message = UpdateSetting(status: value);
		if (await tryChangeSettings(message)) {
			models.home.setMessage(severity: Severity.info, text: "Set mode to ${value.humanName}");
			settings.status = value;
			notifyListeners();
		} else { 
			models.home.setMessage(severity: Severity.error, text: "Failed to set status"); 
		}
	} 

	/// Changes the color of the rover's LED strip.
	Future<bool> setColor(double red, double green, double blue) async {
		final value = ProtoColor(red: red, green: green, blue: blue);
		final message = UpdateSetting(color: value);
		if (await tryChangeSettings(message)) {
			models.home.setMessage(severity: Severity.info, text: "Changed color to ($red, $green, $blue)");
			settings.color = value;
			notifyListeners();
			return true;
		} else { 
			models.home.setMessage(severity: Severity.error, text: "Failed to set color"); 
			return false;
		}
	}
}
