import "package:burt_network/burt_network.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// A data model to manage all connected serial devices.
///
/// Each connected device is represented by a [SerialDevice] object in the [devices] map.
/// This model offers an API to connect, disconnect, and query devices using their port
/// names instead.
///
/// Send messages to the connected devices using the [sendMessage] method, and all messages
/// received all ports are forwarded to [MessagesModel.addMessage].
class SerialModel extends Model {
  /// All the connected devices and their respective serial ports.
  ///
  /// Devices listed here are assumed to have successfully connected.
	Map<String, BurtFirmwareSerial> devices = {};

  /// Whether the given port is connected.
  bool isConnected(String port) => devices.containsKey(port);
  /// Returns true if any device is connected.
  bool get hasDevice => devices.isNotEmpty;

  @override
  Future<void> init() async { }

  /// Connects to the given serial port and adds an entry to [devices].
  ///
  /// If the connection or handshake fails, a message is logged to the home screen
  /// and the device is not added to [devices].
  Future<void> connect(String port) async {
    models.home.setMessage(severity: Severity.info, text: "Connecting to $port...");
    final device = BurtFirmwareSerial(port: port, logger: BurtLogger());
    if (!await device.init()) {
      await device.dispose();
    	models.home.setMessage(severity: Severity.error, text: "Could not connect to $port");
    	return;
    }
    device.messages.listen(models.messages.addMessage);
    models.home.setMessage(severity: Severity.info, text: "Connected to $port");
    devices[port] = device;
    notifyListeners();
  }

  /// Disconnects the device on the given port, if any, and removes its entry from [devices].
  void disconnect(String port) {
    final device = devices[port];
    if (device == null) return;
    device.dispose();
    devices.remove(port);
    models.home.setMessage(severity: Severity.info, text: "Disconnected from $port");
    notifyListeners();
  }

  /// Sends a message to all connected devices.
  ///
  /// This also ensures that only the correct messages get sent to each device.
  void sendMessage(Message message) {
    for (final device in devices.values) {
      final thisDeviceAccepts = getCommandName(device.device);
      if (message.messageName != thisDeviceAccepts) return;
    	device.sendMessage(message);
    }
  }

  /// Either connects or disconnects the device on the given port.
  void toggle(String port) => isConnected(port) ? disconnect(port) : connect(port);
}
