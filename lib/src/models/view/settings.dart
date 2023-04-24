import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// A regular expression representing a valid IP address.
final ipAddressRegex = RegExp(r"\d{3}\.\d{3}\.\d{1}\.\d{1,3}");

/// Modified and validates a [SocketConfig] in the UI. 
class SocketBuilder with ChangeNotifier {
	/// The text controller for the IP address.
	final addressController = TextEditingController();

	/// The text controller for the port.
	final portController = TextEditingController();

	/// The name of the socket being edited.
	final String name;

	/// Creates a view model to modify a [SocketConfig].
	SocketBuilder(this.name, SocketConfig config) {
		addressController.text = config.address.address;
		portController.text = config.port.toString();
	}

	/// The error while modifying the IP address, if any.
	String? addressError;

	/// The error while modifying the port number, if any.
	String? portError;

	/// Validates the IP address.
	void validateAddress(String? value) {
		if (value == null) return;
		if (ipAddressRegex.stringMatch(value) != value) {
			addressError = "Not a valid IP";
		} else {
			addressError = null;
		}
		notifyListeners();
	}

	/// Validates the port number.
	void validatePort(String? value) {
		if (value == null) return;
		final int? newPort = int.tryParse(value);
		if (newPort == null) {
			portError = "Not an integer";
		} else if (newPort < 8000 || newPort >= 9000) {
			portError = "Port must be in the 8000's";
		} else {
			portError = null;
		}
		notifyListeners();
	}

	/// Whether the [SocketConfig] in the UI is valid.
	/// 
	/// Do not try to access [socket] if this is false.
	bool get isValid => addressError == null && portError == null;

	/// The [SocketConfig] represented by this model.
	SocketConfig get socket => SocketConfig.raw(addressController.text, int.parse(portController.text));
}

/// A view model representing a whole [Settings] object in the UI.
class SettingsBuilder with ChangeNotifier {
	/// The view model representing the [SocketConfig] for the subsystems program.
	final SocketBuilder dataSocket;

	/// The view model representing the [SocketConfig] for the video program.
	final SocketBuilder videoSocket;

	/// The view model representing the [SocketConfig] for the autonomy program.
	final SocketBuilder autonomySocket;

	/// The view model representing the [SocketConfig] for the tank.
	/// 
	/// Since the tank runs multiple programs, the port is discarded and only the address is used.
	final SocketBuilder tankSocket;

	/// The user's arm settings.
	final ArmSettings arm;

	/// Whether the page is loading.
	bool isLoading = false;

	/// Creates the view model based on the current [Settings].
	SettingsBuilder() :
		dataSocket = SocketBuilder("Subsystems", models.settings.network.subsystemsSocket),
		videoSocket = SocketBuilder("Video", models.settings.network.videoSocket),
		autonomySocket = SocketBuilder("Autonomy", models.settings.network.autonomySocket),
		tankSocket = SocketBuilder("Tank IP address", models.settings.network.tankSocket),
		arm = models.settings.arm
	{
		dataSocket.addListener(notifyListeners);
		videoSocket.addListener(notifyListeners);
		autonomySocket.addListener(notifyListeners);
		tankSocket.addListener(notifyListeners);
	}

	/// The [Settings] object inputted by the user.
	Settings get settings => Settings(
		network: NetworkSettings(
			subsystemsSocket: dataSocket.socket,
			videoSocket: videoSocket.socket,
			autonomySocket: autonomySocket.socket,
			tankSocket: tankSocket.socket,
			connectionTimeout: 5,
		),
		arm: arm,
	);

	/// Whether these settings are valid.
	/// 
	/// Do not try to access [settings] if this is not true.
	bool get isValid {
		final result = dataSocket.isValid && videoSocket.isValid && autonomySocket.isValid && tankSocket.isValid;
		return result;
	}

	/// Saves the [settings] to the device.
	Future<void> save() async {
		isLoading = true;
		notifyListeners();
		await Future.delayed(const Duration(milliseconds: 500));
		await models.settings.update(settings);
		await models.rover.sockets.init();
		isLoading = false;
		notifyListeners();
	}
}
