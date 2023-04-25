import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/widgets.dart";

/// Creates a widget to edit host and port data for a socket.
class SocketEditor extends StatelessWidget {
	/// The [SocketBuilder] view model behind this widget.
	/// 
	/// Performs validation and tracks the text entered into the fields.
	final SocketBuilder model;

	/// Whether to edit the port as well.
	final bool editPort;

	/// Creates a widget to edit host and port data for a socket.
	const SocketEditor(this.model, {this.editPort = true});

	@override
	Widget build(BuildContext context) => ProviderConsumer<SocketBuilder>.value(
		value: model,
		builder: (model, _) => Row(
			children: [
				const SizedBox(width: 12),
				Expanded(child: Text(model.name)),
				const Spacer(flex: 2),
				Expanded(child: TextField(
					onChanged: model.address.update,
					controller: model.address.controller,
					decoration: InputDecoration(errorText: model.address.error),
					inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"\d|\."))]
				)),
				if (editPort) ...[
					const SizedBox(width: 12),
					Expanded(child: TextField(
						onChanged: model.port.update,
						controller: model.port.controller,
						decoration: InputDecoration(errorText: model.port.error),
						inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"\d"))],
					)),
				]
			],
		)
	);
}

class NumberEditor extends StatelessWidget {
	final String name;
	final TextBuilder<num> model;
	const NumberEditor({
		required this.name,
		required this.model,
	});

	@override
	Widget build(BuildContext context) => ProviderConsumer<TextBuilder<num>>.value(
		value: model,
		builder: (model, _) => Row(
			children: [
				const SizedBox(width: 12),
				Expanded(child: Text(name)),
				const Spacer(flex: 2),
				Expanded(child: TextField(
					onChanged: model.update,
					decoration: InputDecoration(errorText: model.error),
					controller: model.controller,
					inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"\d|\."))],
				)),
			]
		)
	);
}

class PartialSettingsEditor<T> extends StatelessWidget {
	final String name;
	final ValueBuilder<T> model;
	final List<Widget> children;

	const PartialSettingsEditor({
		required this.name,
		required this.model,
		required this.children,
	});

	@override
	Widget build(BuildContext context) => Column(
		crossAxisAlignment: CrossAxisAlignment.start,
		children: [
			Text(
				name,
				style: Theme.of(context).textTheme.titleLarge,
				textAlign: TextAlign.start,
			),			
			...children,
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
					padding: const EdgeInsets.all(8),
					children: [
						PartialSettingsEditor<NetworkSettings>(
							name: "Network Settings",
							model: model.network,
							children: [
								SocketEditor(model.network.dataSocket),
								SocketEditor(model.network.videoSocket),
								SocketEditor(model.network.autonomySocket),
								SocketEditor(model.network.tankSocket, editPort: false),
							]
						),
						PartialSettingsEditor<ArmSettings>(
							name: "Arm Settings",
							model: model.arm,
							children: [
								NumberEditor(name: "Radian increment", model: model.arm.radians),
								NumberEditor(name: "Precise increment (radians)", model: model.arm.precise),
								NumberEditor(name: "Step increment", model: model.arm.steps),
								NumberEditor(name: "IK increment (mm)", model: model.arm.ik),
								NumberEditor(name: "Precise IK increment (mm)", model: model.arm.ikPrecise),
							]
						)
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
