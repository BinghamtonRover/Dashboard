import "dart:async";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

export "package:burt_network/burt_network.dart" show WrappedMessageStream;

class MessagesModel extends Model {
	/// Sends a command over the network or over Serial.
	void sendMessage(Message message, {bool checkVersion = true}) {
    final shouldCheck = checkVersion && models.settings.dashboard.versionChecking;
    if (shouldCheck && !models.rover.metrics.isSupportedVersion(message)) {
      if (models.rover.isConnected) {
        models.home.setMessage(severity: Severity.error, text: "Rover has the wrong ${message.messageName} version!");
      }
      return;
    }
		models.serial.sendMessage(message);
		models.sockets.data.sendMessage(message);
	}

  final _controller = StreamController<WrappedMessage>();
  Stream<WrappedMessage> get stream => _controller.stream;

  void onMessage(WrappedMessage message) =>
    _controller.add(message);

  @override
  Future<void> init() async { }
}
