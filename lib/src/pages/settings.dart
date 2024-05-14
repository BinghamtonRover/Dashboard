// ignore_for_file: directives_ordering
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
class SettingsPage extends ReactiveWidget<SettingsBuilder> {
  @override
  SettingsBuilder createModel() => SettingsBuilder();

	@override
	Widget build(BuildContext context, SettingsBuilder model) => Scaffold(
		appBar: AppBar(title: const Text("Settings")),
		body: Column(children: [
      Expanded(child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          ValueEditor<NetworkSettings>(
            name: "Network settings",
            children: [
              SocketEditor(name: "Subsystems socket", model: model.network.dataSocket),
              SocketEditor(name: "Video socket", model: model.network.videoSocket),
              SocketEditor(name: "Autonomy socket", model: model.network.autonomySocket),
              SocketEditor(name: "Tank IP address", model: model.network.tankSocket, editPort: false),
              ListTile(
                title: const Text("Restart the network sockets"),
                subtitle: const Text("This only resets your computer's network, not the rover's"),
                trailing: const Icon(Icons.refresh),
                onTap: () async {
                  await models.sockets.reset();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Network reset"), duration: Duration(milliseconds: 500)),
                    );
                  }
                },
              ),
            ],
          ),
          const Divider(),
          ValueEditor<ArmSettings>(
            name: "Arm settings",
            children: [
              NumberEditor(name: "Swivel increment", model: model.arm.swivel),
              NumberEditor(name: "Shoulder increment", model: model.arm.shoulder),
              NumberEditor(name: "Elbow increment", model: model.arm.elbow),
              NumberEditor(name: "Wrist rotate increment", model: model.arm.rotate),
              NumberEditor(name: "Wrist lift increment", model: model.arm.lift),
              NumberEditor(name: "Pinch increment", model: model.arm.pinch),
              NumberEditor(name: "IK increment", model: model.arm.ik),
              SwitchListTile(
                title: const Text("Use IK?"),
                subtitle: const Text("Move in millimeters in 3D space instead of radians"),
                value: model.arm.useIK,
                onChanged: model.arm.updateIK,
              ),
            ],
          ),
          const Divider(),
          ValueEditor<ScienceSettings>(
            name: "Science settings",
            children: [
              NumberEditor(
                name: "Number of samples", 
                model: model.science.numSamples,
              ),
              SwitchListTile(
                title: const Text("Scrollable graphs"),
                subtitle: const Text("Graphs can either be forced to fit the page or allowed to scroll\nMight be inconvenient for desktop users"),
                value: model.science.scrollableGraphs,
                onChanged: model.science.updateScrollableGraphs,
              ),
            ],
          ),
          const Divider(),
          ValueEditor<DashboardSettings>(
            name: "Dashboard Settings",
            children: [
              NumberEditor(
                name: "Frames per second", 
                subtitle: "This does not affect the rover's cameras. Useful for limiting the CPU of the dashboard",
                model: model.dashboard.fps,
              ),
              NumberEditor(
                name: "Block size", 
                subtitle: "The precision of the GPS grid", 
                model: model.dashboard.blockSize,
              ),
              SwitchListTile(
                title: const Text("Split camera controls"),
                subtitle: const Text("If enabled, cameras can only be controlled by a separate operator"),
                value: model.dashboard.splitCameras,
                onChanged: model.dashboard.updateCameras,
              ),
              Row(children: [
                const SizedBox(
                  width: 200,
                  child: ListTile(
                    title: Text("Split mode"),
                  ),
                ),
                const Spacer(),
                DropdownMenu<SplitMode>(
                  initialSelection: model.dashboard.splitMode,
                  onSelected: model.dashboard.updateSplitMode,
                  dropdownMenuEntries: [
                    for (final value in SplitMode.values) DropdownMenuEntry(
                      value: value,
                      label: value.humanName,
                    ),
                  ],
                ),
              ],),
              Row(children: [
                const SizedBox(
                  width: 200,
                  child: ListTile(
                    title: Text("Theme mode"),
                  ),
                ),
                const Spacer(),
                DropdownMenu<ThemeMode>(
                  initialSelection: model.dashboard.themeMode,
                  onSelected: model.dashboard.updateThemeMode,
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
          const Divider(),
          ValueEditor<EasterEggsSettings>(
            name: "Easter eggs",
            children: [
              SwitchListTile(
                title: const Text("Enable SEGA Intro"),
                value: model.easterEggs.segaIntro,
                onChanged: model.easterEggs.updateSegaIntro,
              ),
              // Disabled because the sound is horrible. Please find a better sound :)
              // SwitchListTile(
              //   title: const Text("Enable SEGA sound"),
              //   subtitle: const Text('Says "Binghamton" in the SEGA style'),
              //   value: model.easterEggs.segaSound,
              //   onChanged: model.easterEggs.segaIntro ? model.easterEggs.updateSegaSound : null,
              // ),
              SwitchListTile(
                title: const Text("Enable Clippy"),
                value: model.easterEggs.enableClippy,
                onChanged: model.easterEggs.updateClippy,
              ),
              SwitchListTile(
                title: const Text("Bad Apple in the Map"),
                value: model.easterEggs.badApple,
                onChanged: model.easterEggs.updateBadApple,
              ),
            ],
          ),
          const Divider(),
          Text("Misc", style: Theme.of(context).textTheme.titleLarge),
          ListTile(
            title: const Text("Adjust throttle"),
            subtitle: const Text("Sets the max speed on the rover"),
            trailing: const Icon(Icons.speed),
            onTap: () => showDialog<void>(
              context: context,
              builder: (_) => ThrottleEditor(),
            ),
          ),
          ListTile(
            title: const Text("Open session output"),
            subtitle: const Text("Opens all files created by this session"),
            trailing: const Icon(Icons.launch),
            onTap: () => launchUrl(services.files.loggingDir.uri),
          ),
          ListTile(
            title: const Text("Open the output folder"),
            subtitle: const Text("Contains logs, screenshots, and settings"),
            trailing: const Icon(Icons.launch),
            onTap: () => launchUrl(services.files.outputDir.uri),
          ),
          ListTile(
            title: const Text("Change the LED strip color"),
            subtitle: const Text("Opens an RGB picker"),
            trailing: const Icon(Icons.launch),
            onTap: () => showDialog<void>(context: context, builder: (_) => ColorEditor(ColorBuilder())),
          ),
          ListTile(
            title: const Text("Set a timer"),
            subtitle: const Text("Shows a timer for the current mission"),
            trailing: const Icon(Icons.launch),
            onTap: () => showDialog<void>(context: context, builder: (_) => TimerEditor()),
          ),
          ListTile(
            title: const Text("About"),
            subtitle: const Text("Show contributor and version information"),
            trailing: const Icon(Icons.info),
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
        ],
      ),),
      Row(
        mainAxisAlignment: MainAxisAlignment.end, 
        children: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"), 
          ),
          const SizedBox(width: 4),
          ElevatedButton.icon(
            onPressed: !model.isValid ? null : () async {
              await model.save();
              if (context.mounted) Navigator.of(context).pop();
            },
            label: const Text("Save"), 
            icon: model.isLoading 
              ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator()) 
              : const Icon(Icons.save),
          ),
          const SizedBox(width: 4),
        ],
      ),
      const SizedBox(height: 12),
    ],),
	);
}
