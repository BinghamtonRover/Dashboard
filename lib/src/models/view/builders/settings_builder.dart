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
	final NumberBuilder<double> swivel;
	final NumberBuilder<double> shoulder;
	final NumberBuilder<double> elbow;
	final NumberBuilder<double> lift;
	final NumberBuilder<double> rotate;
	final NumberBuilder<double> pinch;

	/// The builder for the IK increment.
	final NumberBuilder<double> ik;

	/// Whether to use manual control or IK.
	bool useIK;

	/// Modifies the given [ArmSettings].
	ArmSettingsBuilder(ArmSettings initial) : 
		swivel = NumberBuilder(initial.swivel),	
		shoulder = NumberBuilder(initial.shoulder),		
		elbow = NumberBuilder(initial.elbow),		
		lift = NumberBuilder(initial.lift),		
		rotate = NumberBuilder(initial.rotate),		
		pinch = NumberBuilder(initial.pinch),		
		ik = NumberBuilder(initial.ikIncrement),		
		useIK = initial.useIK
	{
		swivel.addListener(notifyListeners);
		shoulder.addListener(notifyListeners);
		elbow.addListener(notifyListeners);
		lift.addListener(notifyListeners);
		rotate.addListener(notifyListeners);
		pinch.addListener(notifyListeners);
		ik.addListener(notifyListeners);
	}

	@override
	bool get isValid => swivel.isValid
		&& shoulder.isValid
		&& elbow.isValid
		&& lift.isValid
		&& rotate.isValid
		&& pinch.isValid
		&& ik.isValid;

	/// Updates the [useIK] variable.
	void updateIK(bool input) {	// ignore: avoid_positional_boolean_parameters
		useIK = input;
		notifyListeners();
	}

	@override
	ArmSettings get value => ArmSettings(
		shoulder: shoulder.value,
		elbow: elbow.value,
		swivel: swivel.value,
		pinch: pinch.value,
		lift: lift.value,
		rotate: rotate.value,
		ikIncrement: ik.value,
		useIK: useIK,
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

	/// The number of samples collected. See [ScienceSettings.numSamples].
	NumberBuilder<int> numSamples;

	/// Modifies the given [ScienceSettings].
	ScienceSettingsBuilder(ScienceSettings initial) : 
		numSamples = NumberBuilder(initial.numSamples),
		scrollableGraphs = initial.scrollableGraphs;

	@override
	bool get isValid => numSamples.isValid;

	@override
	ScienceSettings get value => ScienceSettings(
		scrollableGraphs: scrollableGraphs,
		numSamples: numSamples.value,
	);

	/// Modifies [scrollableGraphs].
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
