import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/widgets.dart";

/// Creates a widget to edit host and port data for a socket.
class SocketEditor extends StatelessWidget {
	/// The name of the socket being edited.
	final String name;

	/// The [SocketBuilder] view model behind this widget.
	/// 
	/// Performs validation and tracks the text entered into the fields.
	final SocketBuilder model;

	/// Whether to edit the port as well.
	final bool editPort;

	/// Creates a widget to edit host and port data for a socket.
	const SocketEditor({
		required this.name,
		required this.model, 
		this.editPort = true
	});

	@override
	Widget build(BuildContext context) => ProviderConsumer<SocketBuilder>.value(
		value: model,
		builder: (model, _) => Row(
			children: [
				const SizedBox(width: 16),
				Expanded(child: Text(name)),
				const Spacer(),
				Expanded(child: TextField(
					onChanged: model.address.update,
					controller: model.address.controller,
					decoration: InputDecoration(errorText: model.address.error),
					inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"\d|\."))]
				)),
				const SizedBox(width: 12),
				if (editPort) ...[
					Expanded(child: TextField(
						onChanged: model.port.update,
						controller: model.port.controller,
						decoration: InputDecoration(errorText: model.port.error),
						inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"\d"))],
					)),
				] else const Spacer()
			],
		)
	);
}

/// A widget to edit a number, backed by [NumberBuilder].
class NumberEditor extends StatelessWidget {
	/// The value this number represents.
	final String name;

	/// The view model backing this value.
	final NumberBuilder model;

	/// Creates a widget to modify a number.
	const NumberEditor({required this.name, required this.model});

	@override
	Widget build(BuildContext context) => ProviderConsumer<TextBuilder<num>>.value(
		value: model,
		builder: (model, _) => Row(
			children: [
				const SizedBox(width: 16),
				Expanded(child: Text(name)),
				const Spacer(),
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
						ValueEditor<NetworkSettings>(
							name: "Network Settings",
							children: [
								SocketEditor(name: "Subsystems socket", model: model.network.dataSocket),
								SocketEditor(name: "Video socket", model: model.network.videoSocket),
								SocketEditor(name: "Autonomy socket", model: model.network.autonomySocket),
								SocketEditor(name: "Tank IP address", model: model.network.tankSocket, editPort: false),
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
