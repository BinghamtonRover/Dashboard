import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";

/// The amount of time to wait between sending a request and receiving a confirmation.
const confirmationDelay = Duration(seconds: 1);

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
	/// Returns true if the handshake succeeds.
	Future<bool> tryChangeSettings(UpdateSetting value) async {
		_confirmation = null;
		services.dataSocket.sendMessage(value);
		await Future<void>.delayed(confirmationDelay);
		return _confirmation != null;
	}

	/// Sets the status of the rover.
	/// 
	/// See [RoverStatus] for details.
	Future<void> setStatus(RoverStatus value) async {
		final message = UpdateSetting(status: value);
		services.videoSocket.sendMessage(message);
		services.autonomySocket.sendMessage(message);
		services.marsSocket.sendMessage(message);
		
		if (await tryChangeSettings(message)) {
			models.home.setMessage(severity: Severity.info, text: "Set mode to ${value.humanName}");
			settings.status = value;
			notifyListeners();
		} else { 
			models.home.setMessage(severity: Severity.error, text: "Failed to set status"); 
		}
	} 

	/// Changes the color of the rover's LED strip.
	Future<bool> setColor(ProtoColor color) async {
		final message = UpdateSetting(color: color);
		final result = await tryChangeSettings(message); 
		if (result) {
			models.home.setMessage(severity: Severity.info, text: "Successfully changed color");
			settings.color = color;
			notifyListeners();
			return true;
		} else { 
			models.home.setMessage(severity: Severity.error, text: "Failed to set color"); 
			return false;
		}
	}
}
