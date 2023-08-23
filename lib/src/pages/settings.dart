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
class SettingsPage extends StatelessWidget {
	@override
	Widget build(BuildContext context) => Scaffold(
		appBar: AppBar(title: const Text("Settings")),
		body: ProviderConsumer<SettingsBuilder>(
			create: SettingsBuilder.new,
			builder: (model) => Column(children: [
				Expanded(child: ListView(
					padding: const EdgeInsets.all(12),
					children: [
						ValueEditor<NetworkSettings>(
							name: "Network settings",
							children: [
								SocketEditor(name: "Subsystems socket", model: model.network.dataSocket),
								SocketEditor(name: "Video socket", model: model.network.videoSocket),
								SocketEditor(name: "Autonomy socket", model: model.network.autonomySocket),
								SocketEditor(name: "MARS socket", model: model.network.marsSocket),
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
						ValueEditor<VideoSettings>(
							name: "Video settings",
							children: [
								NumberEditor(
									name: "Frames per second", 
									subtitle: "This does not affect the rover's cameras. Useful for limiting the CPU of the dashboard",
									model: model.video.fps,
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
						ValueEditor<AutonomySettings>(
							name: "Autonomy settings",
							children: [
								NumberEditor(
									name: "Block size", 
									subtitle: "The precision of the GPS grid", 
									model: model.autonomy.blockSize,
								),
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
							],
						),
						const Divider(),
						Text("Misc", style: Theme.of(context).textTheme.titleLarge),
						ListTile(
							title: const Text("Open the output folder"),
							trailing: const Icon(Icons.launch),
							onTap: () => launchUrl(services.files.outputDir.uri),
						),
						ListTile(
							title: const Text("Change the LED strip color"),
							trailing: const Icon(Icons.launch),
							onTap: () => showDialog<void>(context: context, builder: (_) => ColorEditor(ColorBuilder())),
						),
            ListTile(
							title: const Text("Set a timer"),
							trailing: const Icon(Icons.launch),
							onTap: () => showDialog<void>(context: context, builder: (_) => TimerEditor(TimerBuilder())),
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
		),
	);
}
