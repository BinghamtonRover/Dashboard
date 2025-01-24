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

	@override
	Future<void> init() async {}

	/// Sends an [UpdateSetting] and awaits a response.
	///
	/// The response must be an echo of the data sent, to ensure the rover acknowledges the data.
	/// Returns true if the handshake succeeds.
	Future<bool> tryChangeSettings(UpdateSetting value) async {
    final expectedHandshakes =
        models.sockets.sockets.where((socket) => socket.isConnected).map(
              (socket) => socket.tryHandshake(
                message: value,
                timeout: confirmationDelay,
                constructor: UpdateSetting.fromBuffer,
              ),
            );

    if (expectedHandshakes.isEmpty) {
      return true;
    }

    final receivedHandshakes = (await Future.wait(expectedHandshakes)).where((e) => e).length;

		if (receivedHandshakes < expectedHandshakes.length) {
      models.home.setMessage(
        severity: Severity.error,
        text: "Could not update settings, received $receivedHandshakes/${expectedHandshakes.length} handshakes",
      );
			return false;
		}
		return true;
	}

	/// Sets the status of the rover.
	///
	/// See [RoverStatus] for details.
	Future<void> setStatus(RoverStatus value) async {
    if (!models.sockets.sockets.any((e) => e.isConnected || !models.sockets.isEnabled)) return;
    final message = UpdateSetting(status: value);
    if (value != RoverStatus.MANUAL) {
      for (final controller in models.rover.controllers) {
        controller.setMode(OperatingMode.none);
      }
    }

    if (!await tryChangeSettings(message)) {
      return;
    }

    if (value == RoverStatus.MANUAL) {
      models.rover.setDefaultControls();
    }

    if (value == RoverStatus.RESTART) {
      settings.status = RoverStatus.IDLE;
      models.rover.status.value = RoverStatus.IDLE;

      models.home.setMessage(severity: Severity.info, text: "Restarting sockets");
    } else if (value != RoverStatus.POWER_OFF) {
      settings.status = value;
      models.rover.status.value = value;

      models.home.setMessage(severity: Severity.info, text: "Set mode to ${value.humanName}");
    }

    notifyListeners();
	}

	/// Changes the color of the rover's LED strip.
	Future<bool> setColor(ProtoColor color, {required bool blink}) async {
		final message = DriveCommand(color: color, blink: blink ? BoolState.YES : BoolState.NO);
    models.messages.sendMessage(message);
    return true;
	}
}
