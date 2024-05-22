import "package:flutter/material.dart";
import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// A [ValueBuilder] that modifies a [SocketInfo].
class SocketBuilder extends ValueBuilder<SocketInfo> {
	/// The builder for the IP address.
	final AddressBuilder address;

	/// The builder for the port number.
	final NumberBuilder<int> port;

	/// Creates a view model to modify the given [SocketInfo].
	SocketBuilder(SocketInfo initial) : 
		address = AddressBuilder(initial.address),
		port = NumberBuilder<int>(initial.port) 
	{
		address.addListener(notifyListeners);
		port.addListener(notifyListeners);
	}

	@override
	bool get isValid => address.isValid && port.isValid;

	@override
	SocketInfo get value => SocketInfo(address: address.value, port: port.value);
}

/// A [ValueBuilder] representing a [NetworkSettings].
class NetworkSettingsBuilder extends ValueBuilder<NetworkSettings> {
	/// The view model representing the [SocketInfo] for the subsystems program.
	final SocketBuilder dataSocket;

	/// The view model representing the [SocketInfo] for the video program.
	final SocketBuilder videoSocket;

	/// The view model representing the [SocketInfo] for the autonomy program.
	final SocketBuilder autonomySocket;

	/// The view model representing the [SocketInfo] for the tank.
	/// 
	/// Since the tank runs multiple programs, the port is discarded and only the address is used.
	final SocketBuilder tankSocket;

  /// The view model for [NetworkSettings.connectionTimeout].
  final NumberBuilder<double> connectionTimeout;

	@override
	List<SocketBuilder> get otherBuilders => [dataSocket, videoSocket, autonomySocket, tankSocket];

	/// Creates the view model based on the current [Settings].
	NetworkSettingsBuilder(NetworkSettings initial) :
		dataSocket = SocketBuilder(initial.subsystemsSocket),
		videoSocket = SocketBuilder(initial.videoSocket),
		autonomySocket = SocketBuilder(initial.autonomySocket),
		tankSocket = SocketBuilder(initial.tankSocket),
    connectionTimeout = NumberBuilder<double>(initial.connectionTimeout);

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
		connectionTimeout: connectionTimeout.value,
	);
}

/// A [ValueBuilder] representing an [ArmSettings].
class ArmSettingsBuilder extends ValueBuilder<ArmSettings>{
	/// The view model for [ArmSettings.swivel].
	final NumberBuilder<double> swivel;

	/// The view model for [ArmSettings.shoulder].
	final NumberBuilder<double> shoulder;

	/// The view model for [ArmSettings.elbow].
	final NumberBuilder<double> elbow;

	/// The view model for [ArmSettings.lift].
	final NumberBuilder<double> lift;

	/// The view model for [ArmSettings.pinch].
	final NumberBuilder<double> pinch;

	/// The view model for [ArmSettings.rotate].
	final NumberBuilder<double> rotate;

	/// The view model for [ArmSettings.ikIncrement].
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

/// A [ValueBuilder] that modifies a [DashboardSettings].
class DashboardSettingsBuilder extends ValueBuilder<DashboardSettings> {
  /// The builder for the FPS count.
	final NumberBuilder<int> fps;

  /// The precision of the GPS grid. See [DashboardSettings.mapBlockSize].
	final NumberBuilder<double> blockSize;

  /// How the Dashboard should split when only two views are present.
  SplitMode splitMode;

  /// The theme of the Dashboard. See [DashboardSettings.themeMode].
  ThemeMode themeMode;

  /// Whether to split cameras into their own controls. See [DashboardSettings.splitCameras].
  bool splitCameras;

  /// Whether to default to tank controls. See [DashboardSettings.preferTankControls].
  bool preferTankControls;

	/// Modifies the given [DashboardSettings].
  DashboardSettingsBuilder(DashboardSettings initial) : 
		fps = NumberBuilder(initial.maxFps),
		blockSize = NumberBuilder(initial.mapBlockSize),
    splitMode = initial.splitMode,
    splitCameras = initial.splitCameras,
    preferTankControls = initial.preferTankControls,
    themeMode = initial.themeMode;

  @override
  bool get isValid => fps.isValid && blockSize.isValid;

  @override
  DashboardSettings get value => DashboardSettings(
    maxFps: fps.value,
    mapBlockSize: blockSize.value,
    splitMode: splitMode,
    themeMode: themeMode,
    splitCameras: splitCameras,
    preferTankControls: preferTankControls,
  );

  /// Updates the [splitMode] when a new one is selected.
  void updateSplitMode(SplitMode? mode) {
    if (mode == null) return;
    splitMode = mode;
    notifyListeners();
  }

  /// Updates the [themeMode]. 
  void updateThemeMode(ThemeMode? input) {
    if (input == null) return;
    themeMode = input;
    notifyListeners();
  }

  /// Updates [splitCameras].
  void updateCameras(bool? input) {  // ignore: avoid_positional_boolean_parameters
    if (input == null) return;
    splitCameras = input;
    notifyListeners();
  }

  /// Updates [preferTankControls].
  void updateTank(bool? input) {  // ignore: avoid_positional_boolean_parameters
    if (input == null) return;
    preferTankControls = input;
    notifyListeners();
  }
}

/// A [ValueBuilder] that modifies an [EasterEggsSettings].
class EasterEggsSettingsBuilder extends ValueBuilder<EasterEggsSettings> {
	/// Whether to show a SEGA intro. See [EasterEggsSettings.segaIntro].
	bool segaIntro;

  /// Whether to say "Binghamton" in the SEGA style. See [EasterEggsSettings.segaSound].
  bool segaSound;

  /// Whether Clippy should appear by log messages. See [EasterEggsSettings.enableClippy].
  bool enableClippy;

  /// Whether to render Bad Apple in the Map page. See [EasterEggsSettings.badApple].
  bool badApple;

	/// Fills in the fields with the given [initial] settings.
	EasterEggsSettingsBuilder(EasterEggsSettings initial) : 
    badApple = initial.badApple,
    enableClippy = initial.enableClippy,
    segaSound = initial.segaSound,
		segaIntro = initial.segaIntro;

	@override
	bool get isValid => true;

	@override
	EasterEggsSettings get value => EasterEggsSettings(
    segaIntro: segaIntro,
    segaSound: segaSound,
    enableClippy: enableClippy,
    badApple: badApple,
  );

	/// Updates the value of [EasterEggsSettings.segaIntro].
	void updateSegaIntro(bool input) {  // ignore: avoid_positional_boolean_parameters
		segaIntro = input;
		notifyListeners();
	}

  /// Updates the value of [segaSound].
  void updateSegaSound(bool input) {  // ignore: avoid_positional_boolean_parameters
    segaSound = input;
    notifyListeners();
  }

  /// Updates the value of [EasterEggsSettings.enableClippy].
  void updateClippy(bool input) {  // ignore: avoid_positional_boolean_parameters
    enableClippy = input;
    notifyListeners();
  }

  /// Updates the value of [badApple].
  void updateBadApple(bool input) {  // ignore: avoid_positional_boolean_parameters
    badApple = input;
    notifyListeners();
  }
}

/// A [ValueBuilder] representing an [ArmSettings].
class SettingsBuilder extends ValueBuilder<Settings> {
	/// The [NetworkSettings] view model.
	final NetworkSettingsBuilder network;

	/// The [ArmSettings] view model.
	final ArmSettingsBuilder arm;

	/// The [ScienceSettings] view model.
	final ScienceSettingsBuilder science;

  /// The [DashboardSettings] view model.
  final DashboardSettingsBuilder dashboard;

	/// The [EasterEggsSettings] view model.
	final EasterEggsSettingsBuilder easterEggs;

	/// Whether the page is loading.
	bool isLoading = false;

	/// Modifies the user's settings.
	SettingsBuilder() : 
		network = NetworkSettingsBuilder(models.settings.network),
		arm = ArmSettingsBuilder(models.settings.arm),
		science = ScienceSettingsBuilder(models.settings.science),
    dashboard = DashboardSettingsBuilder(models.settings.dashboard),
		easterEggs = EasterEggsSettingsBuilder(models.settings.easterEggs)
	{
		network.addListener(notifyListeners);
		arm.addListener(notifyListeners);
		science.addListener(notifyListeners);
    dashboard.addListener(notifyListeners);
		easterEggs.addListener(notifyListeners);
	}

	@override
	bool get isValid => network.isValid 
		&& arm.isValid 
		&& science.isValid
    && dashboard.isValid
    && easterEggs.isValid;

	@override
	Settings get value => Settings(
		network: network.value,
		arm: arm.value,
		science: science.value,
    dashboard: dashboard.value,
		easterEggs: easterEggs.value,
	);

	/// Saves the settings to the device.
	Future<void> save() async {
		isLoading = true;
		notifyListeners();
    if (value.dashboard.splitCameras != models.settings.dashboard.splitCameras) {
      // Need an if to avoid resetting throttle when trying to set throttle
      models.rover.setDefaultControls();
    }
		await models.settings.update(value);
		await models.sockets.reset();
		models.video.reset();
		isLoading = false;
		notifyListeners();
	}
}
