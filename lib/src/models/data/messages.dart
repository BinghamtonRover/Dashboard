import "dart:async";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

export "package:burt_network/burt_network.dart" show WrappedMessageStream;

/// A single model to consolidate all messages.
///
/// Messages can arrive from serial devices or UDP devices, and any device can be unexpectedly
/// disconnected at any time. To simplify the logic of subscribing for new messages, this model
/// holds a [stream] of [WrappedMessage]s that anyone can subscribe to. When a message arrives,
/// simply call [addMessage] to ensure it will be added to the stream.
///
/// Note that having this model forward [stream] to the serial and UDP streams would *not* work,
/// as those streams can be closed when devices are disconnected, and new streams are created when
/// devices are connected for the first time. In that case, anyone who subscribes to the stream
/// before a device is connected (eg, in [Model.init]) won't get messages received afterwards. To
/// get around this issue, this model uses the same [StreamController] the entire time.
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

  final _controller = StreamController<WrappedMessage>.broadcast();

  /// The stream of messages. Use [WrappedMessageStream.onMessage] to subscribe to messages.
  Stream<WrappedMessage> get stream => _controller.stream;

  /// Adds a message to the [stream].
  void addMessage(WrappedMessage message) => _controller.add(message);

  @override
  Future<void> init() async { }
}
