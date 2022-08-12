import "package:flutter/material.dart";

/// The settings page. 
class SettingsPage extends StatelessWidget {
	@override
	Widget build(BuildContext context) => Scaffold(
		appBar: AppBar(title: const Text("Settings")),
		body: ListView(
			children: [
				const Text("Network settings"),
				SwitchListTile(value: true, onChanged: (_) {}), 
				SwitchListTile(value: false, onChanged: (_) {}), 
				SwitchListTile(value: true, onChanged: (_) {}), 
				const Divider(),
				const Text("Controller settings"),
				SwitchListTile(value: true, onChanged: (_) {}), 
				SwitchListTile(value: false, onChanged: (_) {}), 
				SwitchListTile(value: true, onChanged: (_) {}), 
				const Divider(),
				const Text("Subsystem settings"),
				SwitchListTile(value: true, onChanged: (_) {}), 
				SwitchListTile(value: false, onChanged: (_) {}), 
				SwitchListTile(value: true, onChanged: (_) {}), 
			],
		)	
	);
}
