import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";

/// Connects to and monitors Serial devices connected over USB.
/// 
/// See the [Serial] service for the actual implementation.
class SerialModel extends Model {
	/// Convenient access to the [Serial] service.
	final serial = services.serial;

	/// The currently connected device. Null means no device connected.
	String? connectedDevice;

	@override
	Future<void> init() async { }

	/// Exposes a list of all available devices.
	Iterable<String> get availableDevices => serial.availablePorts;

	/// Whether the dashboard is connected to any Serial devices.
	bool get isConnected => connectedDevice != null;

	/// Disconnects from the currently connected device.
	Future<void> disconnect() async {
		models.home.setMessage(severity: Severity.info, text: "Disconnecting $connectedDevice...");
		await serial.disconnect();
		connectedDevice = null;
		notifyListeners();
	}

	/// Connects to the selected device.
	/// 
	/// If connection is successful, this sets [connectedDevice] and listens for incoming Serial data.
	Future<void> connect(String device) async {
		if (isConnected) await disconnect(); 
		try {
			await serial.connect(device);
		} on SerialException catch(error) {
			models.home.setMessage(severity: Severity.error, text: error.toString());
			return;
		}
		models.home.setMessage(severity: Severity.info, text: "Connected to $device");
		connectedDevice = device;
		notifyListeners();
	}
}
