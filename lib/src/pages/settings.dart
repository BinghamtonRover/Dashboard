import "package:flutter/material.dart";

import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/widgets.dart";

/// Creates a widget to edit host and port data for a socket.
class SocketEditor extends StatelessWidget {
	/// The [SocketBuilder] view model behind this widget.
	/// 
	/// Performs validation and tracks the text entered into the fields.
	final SocketBuilder model;

	/// Creates a widget to edit host and port data for a socket.
	const SocketEditor(this.model);

	@override
	Widget build(BuildContext context) => ProviderConsumer<SocketBuilder>.value(
		value: model,
		builder: (model, _) => Row(
			children: [
				const SizedBox(width: 12),
				Expanded(child: Text(model.name)),
				const Spacer(flex: 2),
				Expanded(child: TextField(
					controller: model.addressController, 
					onChanged: model.setAddress,
					decoration: InputDecoration(errorText: model.addressError),
				)),
				const SizedBox(width: 12),
				Expanded(child: TextField(
					controller: model.portController, 
					onChanged: model.setPort,
					decoration: InputDecoration(errorText: model.portError),
				)),
			],
		)
	);
}

/// The settings page. 
class SettingsPage extends StatelessWidget {
	@override
	Widget build(BuildContext context) => Scaffold(
		appBar: AppBar(title: const Text("Settings")),
		body: ProviderConsumer<SettingsBuilder>(
			create: () => SettingsBuilder(models.rover.sockets.settings),
			builder: (model, child) => Column(children: [
				Expanded(child: ListView(
					padding: const EdgeInsets.all(8),
					children: [
						Text("Network settings", style: Theme.of(context).textTheme.titleLarge),
						SocketEditor(model.dataSocket),
						SocketEditor(model.videoSocket),
						SocketEditor(model.autonomySocket),
						Row(children: [
							const Text("Tank Address"),
							const Spacer(flex: 2),
							Expanded(child: TextField(
								controller: model.tankAddressController, 
								onChanged: model.setTankAddress,
								decoration: InputDecoration(errorText: model.tankAddressError),
							)),
						]),
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
							onPressed: () async {
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
