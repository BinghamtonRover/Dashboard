import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// A [ValueBuilder] that modifies a [SocketConfig].
class SocketBuilder extends ValueBuilder<SocketConfig> {
	/// The builder for the IP address.
	final AddressBuilder address;

	/// The builder for the port number.
	final NumberBuilder<int> port;

	/// Creates a view model to modify the given [SocketConfig].
	SocketBuilder(SocketConfig initial) : 
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

/// A [ValueBuilder] representing a [NetworkSettings].
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
		dataSocket = SocketBuilder(initial.subsystemsSocket),
		videoSocket = SocketBuilder(initial.videoSocket),
		autonomySocket = SocketBuilder(initial.autonomySocket),
		tankSocket = SocketBuilder(initial.tankSocket)
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

/// A [ValueBuilder] representing an [ArmSettings].
class ArmSettingsBuilder extends ValueBuilder<ArmSettings>{
	/// The builder for the radian increment.
	final NumberBuilder<double> radians;

	/// The builder for the steps increment.
	final NumberBuilder<int> steps;

	/// The builder for the precise radian increment.
	final NumberBuilder<double> precise;

	/// The builder for the IK increment.
	final NumberBuilder<double> ik;

	/// The builder for the precise IK increment.
	final NumberBuilder<double> ikPrecise;

	/// Whether to use manual control or IK.
	bool useIK;

	/// Whether to use steps instead of radians.
	bool useSteps;

	/// Modifies the given [ArmSettings].
	ArmSettingsBuilder(ArmSettings initial) : 
		radians = NumberBuilder(initial.radianIncrement),
		steps = NumberBuilder(initial.stepIncrement),
		precise = NumberBuilder(initial.preciseIncrement),
		ik = NumberBuilder(initial.ikIncrement),
		ikPrecise = NumberBuilder(initial.ikPreciseIncrement),
		useIK = initial.useIK,
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

	/// Updates the [useIK] variable.
	void updateIK(bool input) {	// ignore: avoid_positional_boolean_parameters
		useIK = input;
		notifyListeners();
	}

	/// Updates the [useSteps] variable.
	void updateSteps(bool input) {	// ignore: avoid_positional_boolean_parameters
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
		useIK: useIK,
		useSteps: useSteps,
	);
}

/// A [ValueBuilder] that modifies a [VideoSettings].
class VideoSettingsBuilder extends ValueBuilder<VideoSettings> {
	/// The builder for the FPS count.
	final NumberBuilder<int> fps;

	/// Modifies the given [VideoSettings].
	VideoSettingsBuilder(VideoSettings initial) : 
		fps = NumberBuilder(initial.fps);

	@override
	bool get isValid => fps.isValid;

	@override
	VideoSettings get value => VideoSettings(
		fps: fps.value,
	);
}

/// A [ValueBuilder] that modifies a [ScienceSettings].
class ScienceSettingsBuilder extends ValueBuilder<ScienceSettings> {
	/// Whether the graphs can scrolls. See [ScienceSettings.scrollableGraphs].
	bool scrollableGraphs;

	/// Modifies the given [ScienceSettings].
	ScienceSettingsBuilder(ScienceSettings initial) : 
		scrollableGraphs = initial.scrollableGraphs;

	@override
	bool get isValid => true;

	@override
	ScienceSettings get value => ScienceSettings(
		scrollableGraphs: scrollableGraphs,
	);

	void updateScrollableGraphs(bool input) {  // ignore: avoid_positional_boolean_parameters
		scrollableGraphs = input;
		notifyListeners();
	}
}

/// A [ValueBuilder] representing an [ArmSettings].
class SettingsBuilder extends ValueBuilder<Settings> {
	/// The [NetworkSettings] view model.
	final NetworkSettingsBuilder network;

	/// The [ArmSettings] view model.
	final ArmSettingsBuilder arm;

	/// The [VideoSettings] view model.
	final VideoSettingsBuilder video;

	/// The [ScienceSettings] view model.
	final ScienceSettingsBuilder science;

	/// Whether the page is loading.
	bool isLoading = false;

	/// Modifies the user's settings.
	SettingsBuilder() : 
		network = NetworkSettingsBuilder(models.settings.network),
		arm = ArmSettingsBuilder(models.settings.arm),
		video = VideoSettingsBuilder(models.settings.video),
		science = ScienceSettingsBuilder(models.settings.science)
	{
		network.addListener(notifyListeners);
		arm.addListener(notifyListeners);
		video.addListener(notifyListeners);
		science.addListener(notifyListeners);
	}

	@override
	bool get isValid => network.isValid && arm.isValid;

	@override
	Settings get value => Settings(
		network: network.value,
		video: video.value,
		easterEggs: const EasterEggsSettings(),
		science: science.value,
		arm: arm.value,
	);

	/// Saves the settings to the device.
	Future<void> save() async {
		isLoading = true;
		notifyListeners();
		await models.settings.update(value);
		await models.rover.sockets.init();
		models.video.reset();
		isLoading = false;
		notifyListeners();
	}
}
