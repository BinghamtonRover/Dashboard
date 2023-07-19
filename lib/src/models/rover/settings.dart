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
	List<UpdateSetting?> _handshakes = [null, null, null, null];

	@override
	Future<void> init() async {
		models.sockets.data.registerHandler<UpdateSetting>(
			name: UpdateSetting().messageName,
			decoder: UpdateSetting.fromBuffer,
			handler: (settings) => _handshakes[0] = settings,
		);
		models.sockets.video.registerHandler<UpdateSetting>(
			name: UpdateSetting().messageName,
			decoder: UpdateSetting.fromBuffer,
			handler: (settings) => _handshakes[1] = settings,
		);
		models.sockets.autonomy.registerHandler<UpdateSetting>(
			name: UpdateSetting().messageName,
			decoder: UpdateSetting.fromBuffer,
			handler: (settings) => _handshakes[2] = settings,
		);
		models.sockets.mars.registerHandler<UpdateSetting>(
			name: UpdateSetting().messageName,
			decoder: UpdateSetting.fromBuffer,
			handler: (settings) => _handshakes[3] = settings,
		);
	}

	/// Sends an [UpdateSetting] and awaits a response.
	/// 
	/// The response must be an echo of the data sent, to ensure the rover acknowledges the data.
	/// Returns true if the handshake succeeds.
	Future<bool> tryChangeSettings(UpdateSetting value) async {
		_handshakes = [null, null, null, null];
		models.sockets.data.sendMessage(value);
		await Future<void>.delayed(confirmationDelay);
		for (var index = 0; index < models.sockets.sockets.length; index++) {
			if (_handshakes[index] != null) continue;
			final device = models.sockets.sockets[index].device;
			if (device == Device.MARS_SERVER) continue;  // <-- Until the MARS server is up and running
			models.home.setMessage(severity: Severity.error, text: "The ${device.humanName} did not respond");
			return false;
		}
		return true;
	}

	/// Sets the status of the rover.
	/// 
	/// See [RoverStatus] for details.
	Future<void> setStatus(RoverStatus value) async {
		final message = UpdateSetting(status: value);
		models.sockets.video.sendMessage(message);
		models.sockets.autonomy.sendMessage(message);
		models.sockets.mars.sendMessage(message);
		
		if (!await tryChangeSettings(message)) return;
		models.home.setMessage(severity: Severity.info, text: "Set mode to ${value.humanName}");
		settings.status = value;
		models.rover.status.value = value;
		notifyListeners();
	} 

	/// Changes the color of the rover's LED strip.
	Future<bool> setColor(ProtoColor color) async {
		final message = UpdateSetting(color: color);
		final result = await tryChangeSettings(message); 
		if (result) {
			models.home.setMessage(severity: Severity.info, text: "Successfully changed color");
			settings.color = color;
			notifyListeners();
		}
		return result;
	}
}
