import "package:flutter/material.dart";

import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/pages.dart";
import "package:rover_dashboard/widgets.dart";

/// A widget to switch between tank and rover modes.
class TankSwitcher extends StatelessWidget {
	@override
	Widget build(BuildContext context) => ProviderConsumer<Sockets>.value(
		value: models.rover.sockets,
		builder: (model) => Row(children: [
			TextButton(
				child: Text(
					"Rover", 
					style: TextStyle(color: model.rover == RoverType.rover ? Colors.black : Colors.grey)
				), 
				onPressed: () { }
			),
			Switch(
				value: model.rover == RoverType.tank, 
				onChanged: (value) => model.setRover(value ? RoverType.tank : RoverType.rover),
				thumbColor: MaterialStateProperty.all(Theme.of(context).colorScheme.surface),
			),
			TextButton(
				onPressed: () { },
				child: Text(
					"Tank", 
					style: TextStyle(color: model.rover == RoverType.tank ? Colors.black : Colors.grey)
				), 
			),
		]),
	);
}


/// The main dashboard page. 
/// 
/// TODO: Define what exactly will go here.
class HomePage extends StatelessWidget {
	@override
	Widget build(BuildContext context) => Scaffold(
		appBar: AppBar(
			title: Text("Dashboard v${models.home.version ?? ''}"),
			actions: [
				TankSwitcher(),
				IconButton(
					icon: const Icon(Icons.settings),
					onPressed: () => Navigator.of(context).pushNamed(Routes.settings),
				),
			]
		),
		body: Column(
			children: [
				Expanded(child: Row(
					children: const [
						Expanded(child: ViewsWidget()),
						Sidebar(),
					]
				)),
				Footer(),
			]
		),
	);
}
