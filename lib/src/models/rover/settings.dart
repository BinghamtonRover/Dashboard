import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

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

	/// A shorthand for accessing [UpdateSetting.status].
	RoverStatus get status => settings.status;

	/// The last received confirmation from each socket.
	int _handshakes = 0;

	@override
	Future<void> init() async {
		models.messages.registerHandler<UpdateSetting>(
			name: UpdateSetting().messageName,
			decoder: UpdateSetting.fromBuffer,
			handler: (settings) => _handshakes++,
		);
	}

	/// Sends an [UpdateSetting] and awaits a response.
	/// 
	/// The response must be an echo of the data sent, to ensure the rover acknowledges the data.
	/// Returns true if the handshake succeeds.
	Future<bool> tryChangeSettings(UpdateSetting value) async {
		_handshakes = 0;
		models.sockets.data.sendMessage(value);
		await Future<void>.delayed(confirmationDelay);
		if (_handshakes != 3) {
			models.home.setMessage(severity: Severity.error, text: "Could not update settings");
			return false;
		}
		return true;
	}

	/// Sets the status of the rover.
	/// 
	/// See [RoverStatus] for details.
	Future<void> setStatus(RoverStatus value) async {
    if (!models.rover.isConnected) return;
    if (value == RoverStatus.AUTONOMOUS || value == RoverStatus.IDLE) {
      for (final controller in models.rover.controllers) {
        controller.setMode(OperatingMode.none);
      }
    } else if (value == RoverStatus.MANUAL) { 
      models.rover.setDefaultControls();
    } else {
      final message = UpdateSetting(status: value);
      models.sockets.video.sendMessage(message);
      models.sockets.autonomy.sendMessage(message);
      if (!await tryChangeSettings(message)) return;
    }

    models.home.setMessage(severity: Severity.info, text: "Set mode to ${value.humanName}");
		settings.status = value;
		models.rover.status.value = value;
		notifyListeners();
	} 

	/// Changes the color of the rover's LED strip.
	Future<bool> setColor(ProtoColor color) async {
		final message = DriveCommand(color: color);
    models.messages.sendMessage(message);
    return true;
	}
}
