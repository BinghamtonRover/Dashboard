import "dart:io";
import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// A regular expression representing a valid IP address.
final ipAddressRegex = RegExp(r"\d{3}\.\d{3}\.\d{1}\.\d{1,3}");

abstract class ValueBuilder<T> with ChangeNotifier {
	/// The value being updated in the UI.
	T get value;

	/// Whether the [value] in the UI is valid.
	/// 
	/// Do not try to access [value] if this is false.
	bool get isValid;
}

abstract class TextBuilder<T> extends ValueBuilder<T> {
	@override
	T value;

	final TextEditingController controller;

	/// Creates a view model to update settings.
	TextBuilder(this.value, {String? text}) : 
		controller = TextEditingController(text: text ?? value.toString());

	/// The error to display in the UI.
	String? error;

	/// Updates the [value] based on the user's input.
	void update(String input);

	@override
	bool get isValid => error == null;
}

class NumberBuilder<T extends num> extends TextBuilder<T> {
	bool get isDecimal => List<int> != List<T>;

	NumberBuilder(super.value);

	@override
	void update(String input) {
		if (input.isEmpty) {
			error = "Must not be empty";
		} else if (double.tryParse(input) == null) {
			error = "Invalid number";
		} else if (!isDecimal && int.tryParse(input) == null) {
			error = "Must be an integer";
		} else {
			error = null;
			if (isDecimal) {
				value = double.parse(input) as T;
			} else {
				value = int.parse(input) as T;
			}
		}
		notifyListeners();
	}
}

class AddressBuilder extends TextBuilder<InternetAddress> {
	AddressBuilder(InternetAddress value) : super(value, text: value.address.toString());

	@override
	void update(String input) {
		if (input.isEmpty) {
			error = "Must not be blank";
		} else if (ipAddressRegex.stringMatch(input) != input || input.endsWith(".")) {
			error = "Not a valid IP";
		} else if (input.split(".").any((part) => int.parse(part) > 255)) {
			error = "IP out of range";
		} else {
			error = null;
			value = InternetAddress(input);
		}
		notifyListeners();
	}
}

/// Modified and validates a [SocketConfig] in the UI. 
class SocketBuilder extends ValueBuilder<SocketConfig> {
	/// The name of the socket being edited.
	final String name;

	final AddressBuilder address;
	final NumberBuilder<int> port;

	/// Creates a view model to modify a [SocketConfig].
	SocketBuilder(this.name, SocketConfig initial) : 
		address = AddressBuilder(initial.address),
		port = NumberBuilder<int>(initial.port) 
	{
		address.addListener(notifyListeners);
		port.addListener(notifyListeners);
	}

	@override
	bool get isValid => address.isValid && port.isValid;

	@override
	SocketConfig get value => SocketConfig(address.value, port.value);
}

/// A view model representing a whole [Settings] object in the UI.
class NetworkSettingsBuilder extends ValueBuilder<NetworkSettings> {
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

	/// Creates the view model based on the current [Settings].
	NetworkSettingsBuilder(NetworkSettings initial) :
		dataSocket = SocketBuilder("Subsystems", initial.subsystemsSocket),
		videoSocket = SocketBuilder("Video", initial.videoSocket),
		autonomySocket = SocketBuilder("Autonomy", initial.autonomySocket),
		tankSocket = SocketBuilder("Tank IP address", initial.tankSocket)
	{
		dataSocket.addListener(notifyListeners);
		videoSocket.addListener(notifyListeners);
		autonomySocket.addListener(notifyListeners);
		tankSocket.addListener(notifyListeners);
	}

	@override
	bool get isValid => dataSocket.isValid
		&& videoSocket.isValid
		&& autonomySocket.isValid
		&& tankSocket.isValid;

	@override
	NetworkSettings get value => NetworkSettings(
		subsystemsSocket: dataSocket.value,
		videoSocket: videoSocket.value,
		autonomySocket: autonomySocket.value,
		tankSocket: tankSocket.value,
		connectionTimeout: 5,
	);
}

class ArmSettingsBuilder extends ValueBuilder<ArmSettings>{
	final TextBuilder<double> radians;
	final TextBuilder<int> steps;
	final TextBuilder<double> precise;
	final TextBuilder<double> ik;
	final TextBuilder<double> ikPrecise;

	bool manualControl;
	bool useSteps;

	ArmSettingsBuilder(ArmSettings initial) : 
		radians = NumberBuilder(initial.radianIncrement),
		steps = NumberBuilder<int>(initial.stepIncrement),
		precise = NumberBuilder(initial.preciseIncrement),
		ik = NumberBuilder(initial.ikIncrement),
		ikPrecise = NumberBuilder(initial.ikPreciseIncrement),
		manualControl = initial.manualControl,
		useSteps = initial.useSteps
	{
		radians.addListener(notifyListeners);
		steps.addListener(notifyListeners);
		precise.addListener(notifyListeners);
		ik.addListener(notifyListeners);
		ikPrecise.addListener(notifyListeners);
	}

	@override
	bool get isValid => radians.isValid
		&& steps.isValid
		&& precise.isValid
		&& ik.isValid
		&& ikPrecise.isValid;

	// ignore: avoid_positional_boolean_parameters
	void updateManual(bool input) {
		manualControl = input;
		notifyListeners();
	}

	// ignore: avoid_positional_boolean_parameters
	void updateSteps(bool input) {
		useSteps = input;
		notifyListeners();
	}

	@override
	ArmSettings get value => ArmSettings(
		radianIncrement: radians.value,
		stepIncrement: steps.value,
		preciseIncrement: precise.value,
		ikIncrement: ik.value,
		ikPreciseIncrement: ikPrecise.value,
		manualControl: manualControl,
		useSteps: useSteps,
	);
}

class SettingsBuilder extends ValueBuilder<Settings> {
	final NetworkSettingsBuilder network;
	final ArmSettingsBuilder arm;

	/// Whether the page is loading.
	bool isLoading = false;

	SettingsBuilder() : 
		network = NetworkSettingsBuilder(NetworkSettings.copy(models.settings.network)),
		arm = ArmSettingsBuilder(ArmSettings.copy(models.settings.arm))
	{
		network.addListener(notifyListeners);
		arm.addListener(notifyListeners);
	}

	@override
	bool get isValid => network.isValid && arm.isValid;

	@override
	Settings get value => Settings(
		network: network.value,
		arm: arm.value,
	);

	/// Saves the settings to the device.
	Future<void> save() async {
		isLoading = true;
		notifyListeners();
		await Future.delayed(const Duration(milliseconds: 500));
		await models.settings.update(value);
		await models.rover.sockets.init();
		isLoading = false;
		notifyListeners();
	}
}
