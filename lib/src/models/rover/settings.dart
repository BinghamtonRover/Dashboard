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
	/// The status of the rover.
	RoverStatus status = RoverStatus.MANUAL;

	/// The last received confirmation
	UpdateSetting? _confirmation;

	@override
	Future<void> init() async {
		services.messageReceiver.registerHandler<UpdateSetting>(
			name: UpdateSetting().messageName,
			decoder: UpdateSetting.fromBuffer,
			handler: (settings) => _confirmation = settings,
		);
	}

	/// Sets the status of the rover.
	/// 
	/// See [RoverStatus] for details.
	Future<void> setStatus(RoverStatus value) async {
		final message = UpdateSetting(status: value);
		services.messageSender.sendMessage(message);
		await Future.delayed(confirmationDelay);
		if (message == _confirmation) {
			models.home.setMessage(severity: Severity.info, text: "Set mode to ${value.humanName}");
			status = value;
			notifyListeners();
		} else { 
			models.home.setMessage(severity: Severity.error, text: "Failed to set status"); 
		}
	} 
}
