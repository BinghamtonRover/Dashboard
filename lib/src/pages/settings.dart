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
			Text(
				name,
				style: Theme.of(context).textTheme.titleLarge,
				textAlign: TextAlign.start,
			),			
			Padding(
				padding: const EdgeInsets.symmetric(horizontal: 8),
				child: Column(children: children),
			)
		]
	);
} 

/// The settings page.
class SettingsPage extends StatelessWidget {
	@override
	Widget build(BuildContext context) => Scaffold(
		appBar: AppBar(title: const Text("Settings")),
		body: ProviderConsumer<SettingsBuilder>(
			create: SettingsBuilder.new,
			builder: (model, _) => Column(children: [
				Expanded(child: ListView(
					padding: const EdgeInsets.all(12),
					children: [
						ValueEditor<NetworkSettings>(
							name: "Network Settings",
							children: [
								SocketEditor(name: "Subsystems socket", model: model.network.dataSocket),
								SocketEditor(name: "Video socket", model: model.network.videoSocket),
								SocketEditor(name: "Autonomy socket", model: model.network.autonomySocket),
								SocketEditor(name: "Tank IP address", model: model.network.tankSocket, editPort: false),
								ListTile(
									title: const Text("Restart the network sockets"),
									subtitle: const Text("This is only useful when connecting to localhost. Does not affect the rover"),
									trailing: const Icon(Icons.refresh),
									onTap: () async {
										await models.rover.sockets.reset();
										if (context.mounted) {
											ScaffoldMessenger.of(context).showSnackBar(
												const SnackBar(content: Text("Network reset"), duration: Duration(milliseconds: 500)),
											);
										}
									}
								)
							]
						),
						ValueEditor<ArmSettings>(
							name: "Arm Settings",
							children: [
								NumberEditor(name: "Radian increment", model: model.arm.radians),
								NumberEditor(name: "Precise increment (radians)", model: model.arm.precise),
								NumberEditor(name: "Step increment", model: model.arm.steps),
								NumberEditor(name: "IK increment (mm)", model: model.arm.ik),
								NumberEditor(name: "Precise IK increment (mm)", model: model.arm.ikPrecise),
								SwitchListTile(
									title: const Text("Use IK?"),
									subtitle: const Text("Move in millimeters in 3D space instead of radians"),
									value: model.arm.useIK,
									onChanged: model.arm.updateIK,
								),
								SwitchListTile(
									title: const Text("Move in steps?"),
									subtitle: const Text("Move in steps rather than radians"),
									value: model.arm.useSteps,
									onChanged: model.arm.updateSteps,
								),
							]
						),
						const ValueEditor<EasterEggsSettings>(
							name: "Easter eggs",
							children: [
								ListTile(title: Text("Coming soon!")),
							]
						),
						Text("Misc", style: Theme.of(context).textTheme.titleLarge),
						ListTile(
							title: const Text("Open the output folder"),
							trailing: const Icon(Icons.launch),
							onTap: () => launchUrl(services.files.outputDir.uri),
						),
					],
				)),
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
			])
		)
	);
}
