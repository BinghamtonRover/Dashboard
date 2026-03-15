// ignore_for_file: directives_ordering
import "dart:io";

import "package:flutter/material.dart";
import "package:url_launcher/url_launcher.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";
import "package:rover_dashboard/widgets.dart";

/// A widget to display all the settings in a [ValueBuilder].
///
/// Technically this class does not need to be used with [ValueBuilder], but it provides a heading
/// and a list of children widgets to modify individual settings.
class ValueEditor<T> extends StatelessWidget {
	/// The name of the value being edited.
	final String name;

	/// Widgets to modify each individual setting.
	final List<Widget> children;

	/// Creates a widget to modify a value.
	const ValueEditor({required this.name, required this.children});

	@override
	Widget build(BuildContext context) => Column(
		crossAxisAlignment: CrossAxisAlignment.start,
		children: [
			const SizedBox(height: 4),
			Padding(
				padding: const EdgeInsets.symmetric(horizontal: 8),
				child: Text(
					name,
					style: Theme.of(context).textTheme.titleLarge,
					textAlign: TextAlign.start,
				),
			),
			const SizedBox(height: 4),
			...children,
		],
	);
}

/// The settings page.
///
/// Uses a [StatefulWidget] to manage the selected section index for the [NavigationRail].
class SettingsPage extends StatefulWidget {
	@override
	State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
	final _model = SettingsBuilder();
	int _index = 0;

	@override
	void initState() {
		super.initState();
		_model.addListener(onUpdate);
	}

	@override
	void dispose() {
		_model.removeListener(onUpdate);
		_model.dispose();
		super.dispose();
	}

	void onUpdate() => setState(() {});

	@override
	Widget build(BuildContext context) => Scaffold(
		appBar: AppBar(title: const Text("Settings")),
		body: Column(children: [
			Expanded(child: Row(children: [
				NavigationRail(
					selectedIndex: _index,
					onDestinationSelected: (i) => setState(() => _index = i),
					labelType: NavigationRailLabelType.all,
					destinations: const [
						NavigationRailDestination(
							icon: Icon(Icons.wifi),
							label: Text("Network"),
						),
						NavigationRailDestination(
							icon: Icon(Icons.settings_input_antenna),
							label: Text("Base Station"),
						),
						NavigationRailDestination(
							icon: Icon(Icons.precision_manufacturing),
							label: Text("Arm"),
						),
						NavigationRailDestination(
							icon: Icon(Icons.science),
							label: Text("Science"),
						),
						NavigationRailDestination(
							icon: Icon(Icons.dashboard),
							label: Text("Dashboard"),
						),
						NavigationRailDestination(
							icon: Icon(Icons.celebration),
							label: Text("Easter Eggs"),
						),
						NavigationRailDestination(
							icon: Icon(Icons.more_horiz),
							label: Text("Misc"),
						),
					],
				),
				const VerticalDivider(width: 1),
				Expanded(child: ListView(
					padding: const EdgeInsets.all(12),
					children: _buildSection(),
				)),
			])),
			Row(
				mainAxisAlignment: MainAxisAlignment.end,
				children: [
					TextButton(
						onPressed: () => Navigator.of(context).pop(),
						child: const Text("Cancel"),
					),
					const SizedBox(width: 4),
					ElevatedButton.icon(
						onPressed: !_model.isValid ? null : () async {
							await _model.save();
							if (context.mounted) Navigator.of(context).pop();
						},
						label: const Text("Save"),
						icon: _model.isLoading
							? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator())
							: const Icon(Icons.save),
					),
					const SizedBox(width: 4),
				],
			),
			const SizedBox(height: 12),
		]),
	);

	List<Widget> _buildSection() => switch (_index) {
		0 => _network(),
		1 => _baseStation(),
		2 => _arm(),
		3 => _science(),
		4 => _dashboard(),
		5 => _easterEggs(),
		_ => _misc(),
	};

	List<Widget> _network() => [
		ValueEditor<NetworkSettings>(
			name: "Network settings",
			children: [
				SocketEditor(name: "Subsystems socket", model: _model.network.dataSocket),
				SocketEditor(name: "Video socket", model: _model.network.videoSocket),
				SocketEditor(name: "Autonomy socket", model: _model.network.autonomySocket),
				SocketEditor(name: "Base station socket", model: _model.network.baseSocket),
				SocketEditor(name: "Tank IP address", model: _model.network.tankSocket, editPort: false),
				NumberEditor(name: "Heartbeats per second", model: _model.network.connectionTimeout),
				if (Platform.isWindows) ListTile(
					title: const Text("Open Windows network settings"),
					subtitle: const Text("You may need to change these if the rover will not connect"),
					trailing: const Icon(Icons.lan_outlined),
					onTap: () {
						launchUrl(Uri.parse("ms-settings:network-ethernet"));
						showDialog<void>(
							context: context,
							builder: (context) => AlertDialog(
								content: const SelectableText(
									"Click on IP Assignment, select Manual, then IPv4, then set:\n"
									"\n- IP address: 192.168.1.10"
									"\n- Subnet 255.255.255.0 (or Subnet length: 24)"
									"\n- Gateway: 192.168.1.1"
									"\n- Preferred DNS: 192.168.1.1",
								),
								title: const Text("Set your IP settings"),
								actions: [
									TextButton(
										child: const Text("Ok"),
										onPressed: () => Navigator.of(context).pop(),
									),
								],
							),
						);
					},
				),
			],
		),
	];

	List<Widget> _baseStation() => [
		ValueEditor<BaseStationSettings>(
			name: "Base Station settings",
			children: [
				NumberEditor(name: "Latitude", model: _model.baseStation.latitude),
				NumberEditor(name: "Longitude", model: _model.baseStation.longitude),
				NumberEditor(name: "Altitude (m)", model: _model.baseStation.altitude),
				NumberEditor(
					name: "Angle Tolerance",
					subtitle: "The angle threshold for the antenna facing the rover",
					model: _model.baseStation.angleTolerance,
				),
			],
		),
	];

	List<Widget> _arm() => [
		ValueEditor<ArmSettings>(
			name: "Arm settings",
			children: [
				NumberEditor(name: "Swivel increment", model: _model.arm.swivel),
				NumberEditor(name: "Shoulder increment", model: _model.arm.shoulder),
				NumberEditor(name: "Elbow increment", model: _model.arm.elbow),
				NumberEditor(name: "Wrist rotate increment", model: _model.arm.rotate),
				NumberEditor(name: "Wrist lift increment", model: _model.arm.lift),
				NumberEditor(name: "Pinch increment", model: _model.arm.pinch),
			],
		),
	];

	List<Widget> _science() => [
		ValueEditor<ScienceSettings>(
			name: "Science settings",
			children: [
				NumberEditor(
					name: "Number of samples",
					model: _model.science.numSamples,
				),
				SwitchListTile(
					title: const Text("Scrollable graphs"),
					subtitle: const Text("Graphs can either be forced to fit the page or allowed to scroll\nMight be inconvenient for desktop users"),
					value: _model.science.scrollableGraphs,
					onChanged: _model.science.updateScrollableGraphs,
				),
			],
		),
	];

	List<Widget> _dashboard() => [
		ValueEditor<DashboardSettings>(
			name: "Dashboard Settings",
			children: [
				NumberEditor(
					name: "Frames per second",
					subtitle: "This does not affect the rover's cameras. Useful for limiting the CPU of the dashboard",
					model: _model.dashboard.fps,
				),
				NumberEditor(
					name: "Block size",
					subtitle: "The precision of the GPS grid in meters",
					model: _model.dashboard.blockSize,
				),
				SwitchListTile(
					title: const Text("Split camera controls"),
					subtitle: const Text("If enabled, cameras can only be controlled by a separate operator"),
					value: _model.dashboard.splitCameras,
					onChanged: _model.dashboard.updateCameras,
				),
				SwitchListTile(
					title: const Text("Prefer tank controls"),
					subtitle: const Text("Default to tank controls instead of modern drive controls"),
					value: _model.dashboard.preferTankControls,
					onChanged: _model.dashboard.updateTank,
				),
				NumberEditor(
					name: "Drive Rate Limit",
					subtitle: "The maximum acceleration of the drive (joystick input per second)",
					model: _model.dashboard.driveRateLimit,
				),
				NumberEditor(
					name: "Throttle Rate Limit",
					subtitle: "The maximum acceleration of the drive throttle (input per second)",
					model: _model.dashboard.throttleRateLimit,
				),
				SwitchListTile(
					title: const Text("Require version checking"),
					subtitle: const Text("Default to version checking on"),
					value: _model.dashboard.versionChecking,
					onChanged: _model.dashboard.updateVersionChecking,
				),
				Row(children: [
					const SizedBox(
						width: 200,
						child: ListTile(
							title: Text("Theme mode"),
						),
					),
					const Spacer(),
					DropdownMenu<ThemeMode>(
						initialSelection: _model.dashboard.themeMode,
						onSelected: _model.dashboard.updateThemeMode,
						dropdownMenuEntries: [
							for (final value in ThemeMode.values) DropdownMenuEntry<ThemeMode>(
								value: value,
								label: value.humanName,
							),
						],
					),
				],),
			],
		),
	];

	List<Widget> _easterEggs() => [
		ValueEditor<EasterEggsSettings>(
			name: "Easter eggs",
			children: [
				SwitchListTile(
					title: const Text("Enable SEGA Intro"),
					value: _model.easterEggs.segaIntro,
					onChanged: _model.easterEggs.updateSegaIntro,
				),
				// Disabled because the sound is horrible. Please find a better sound :)
				// SwitchListTile(
				//   title: const Text("Enable SEGA sound"),
				//   subtitle: const Text('Says "Binghamton" in the SEGA style'),
				//   value: _model.easterEggs.segaSound,
				//   onChanged: _model.easterEggs.segaIntro ? _model.easterEggs.updateSegaSound : null,
				// ),
				SwitchListTile(
					title: const Text("Enable Clippy"),
					value: _model.easterEggs.enableClippy,
					onChanged: _model.easterEggs.updateClippy,
				),
				SwitchListTile(
					title: const Text("Bad Apple in the Map"),
					value: _model.easterEggs.badApple,
					onChanged: _model.easterEggs.updateBadApple,
				),
				SwitchListTile(
					title: const Text("DVD Logo Animation in Screensaver"),
					value: _model.easterEggs.dvdLogoAnimation,
					onChanged: _model.easterEggs.updateDvdLogoAnimation,
				),
			],
		),
	];

	List<Widget> _misc() => [
		Text("Misc", style: Theme.of(context).textTheme.titleLarge),
		ListTile(
			title: const Text("Open session output"),
			subtitle: const Text("Opens all files created by this session"),
			trailing: const Icon(Icons.folder_open),
			onTap: () => launchUrl(services.files.loggingDir.uri),
		),
		ListTile(
			title: const Text("Open the output folder"),
			subtitle: const Text("Contains logs, screenshots, and settings"),
			trailing: const Icon(Icons.folder_open),
			onTap: () => launchUrl(services.files.outputDir.uri),
		),
		ListTile(
			title: const Text("Set a timer"),
			subtitle: const Text("Shows a timer for the current mission"),
			trailing: const Icon(Icons.alarm),
			onTap: () => showDialog<void>(context: context, builder: (_) => TimerEditor()),
		),
		ListTile(
			title: const Text("About"),
			subtitle: const Text("Show contributor and version information"),
			trailing: const Icon(Icons.info_outline),
			onTap: () => showAboutDialog(
				context: context,
				applicationName: "Binghamton University Rover Team Dashboard",
				applicationVersion: models.home.version,
				applicationIcon: Image.asset("assets/logo.png", scale: 4),
				applicationLegalese: [
					"Firmware versions:",
					for (final metrics in models.rover.metrics.allMetrics)
						"  ${metrics.name}: Supports ${metrics.supportedVersion.format()}. Rover: ${metrics.version.format()}",
				].join("\n"),
				children: [
					const SizedBox(height: 24),
					Center(child: TextButton(
						onPressed: () => launchUrl(Uri.parse("https://github.com/BinghamtonRover/Dashboard/graphs/contributors")),
						child: const Text("Click to see contributions"),
					),),
				],
			),
		),
	];
}
