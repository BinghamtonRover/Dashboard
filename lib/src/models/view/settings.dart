import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";

final ipAddressRegex = RegExp(r"\d{3}\.\d{3}\.\d{1}\.\d{1,3}");

class SocketBuilder with ChangeNotifier {
	final addressController = TextEditingController();
	final portController = TextEditingController();

	String address;
	int port;
	final String name;

	SocketBuilder(this.name, SocketConfig config) : 
		address = config.address.address, 
		port = config.port 
	{
		addressController.text = address;
		portController.text = port.toString();
	}

	String? addressError, portError;

	void setAddress(String? value) {
		if (value == null) return;
		if (ipAddressRegex.stringMatch(value) != value) {
			addressError = "Not a valid IP";
		} else {
			addressError = null;
			address = value;
		}
		notifyListeners();
	}

	void setPort(String? value) {
		if (value == null) return;
		final int? newPort = int.tryParse(value);
		if (newPort == null) {
			portError = "Not an integer";
		} else if (newPort < 8000 || newPort >= 9000) {
			portError = "Port must be in the 8000s";
		} else {
			portError = null;
			port = newPort;
		}
		notifyListeners();
	}

	SocketConfig get socket => SocketConfig.raw(address, port);
}

class SettingsBuilder with ChangeNotifier {
	final SocketBuilder dataSocket;
	final SocketBuilder videoSocket;
	final SocketBuilder autonomySocket;

	final TextEditingController tankAddressController;
	String tankAddress = "";
	String? tankAddressError;
	bool isLoading = false;

	SettingsBuilder(Settings settings) :
		tankAddressController = TextEditingController(text: settings.tankAddress),
		tankAddress = settings.tankAddress,
		dataSocket = SocketBuilder("Subsystems", settings.subsystemsSocket),
		videoSocket = SocketBuilder("Video", settings.videoSocket),
		autonomySocket = SocketBuilder("Autonomy", settings.autonomySocket);

	void setTankAddress(String? value) {
		if (value == null) return;
		if (ipAddressRegex.stringMatch(value) != value) {
			tankAddressError = "Not a valid IP";
		} else {
			tankAddressError = null;
			tankAddress = value;
		}
		notifyListeners();
	}

	Settings get settings => Settings(
		subsystemsSocket: dataSocket.socket,
		videoSocket: videoSocket.socket,
		autonomySocket: autonomySocket.socket,
		tankAddress: tankAddress,
		connectionTimeout: 5,
	);

	Future<void> save() async {
		isLoading = true;
		notifyListeners();
		await Future.delayed(const Duration(milliseconds: 500));
		await services.files.writeSettings(settings);
		await models.rover.sockets.init();
		isLoading = false;
		notifyListeners();
	}
}
