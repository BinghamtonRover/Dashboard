import "package:flutter/material.dart";

class SettingsPage extends StatelessWidget {
	@override
	Widget build(BuildContext context) => Scaffold(
		appBar: AppBar(title: Text("Settings")),
		body: ListView(
			children: [
				Text("Network settings"),
				SwitchListTile(value: true, onChanged: (_) {}), 
				SwitchListTile(value: false, onChanged: (_) {}), 
				SwitchListTile(value: true, onChanged: (_) {}), 
				Divider(),
				Text("Controller settings"),
				SwitchListTile(value: true, onChanged: (_) {}), 
				SwitchListTile(value: false, onChanged: (_) {}), 
				SwitchListTile(value: true, onChanged: (_) {}), 
				Divider(),
				Text("Subsystem settings"),
				SwitchListTile(value: true, onChanged: (_) {}), 
				SwitchListTile(value: false, onChanged: (_) {}), 
				SwitchListTile(value: true, onChanged: (_) {}), 
			],
		)	
	);
}
