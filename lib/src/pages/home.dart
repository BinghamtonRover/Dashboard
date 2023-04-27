import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/pages.dart";
import "package:rover_dashboard/widgets.dart";

/// Data needed for an operating mode's UI.
class OperatingModePage { 
	/// The mode the rover should be in.
	final OperatingMode mode;

	/// The icon to display in the mode switcher.
	final IconData icon;

	/// The page to display in this mode.
	final Widget page;

	/// A const constructor.
	const OperatingModePage({required this.mode, required this.icon, required this.page});

	/// All the pages for all the operating modes.
	static const allPages = [
		OperatingModePage(mode: OperatingMode.science, page: SciencePage(), icon: Icons.science), 
		OperatingModePage(mode: OperatingMode.arm, page: ArmPage(), icon: Icons.precision_manufacturing), 
		OperatingModePage(mode: OperatingMode.autonomy, page: AutonomyPage(), icon: Icons.smart_toy),
		OperatingModePage(mode: OperatingMode.drive, page: DrivePage(), icon: Icons.sports_esports),
	];
}

/// A widget to switch between tank and rover modes.
class TankSwitcher extends StatelessWidget {
	@override
	Widget build(BuildContext context) => ProviderConsumer<Sockets>.value(
		value: models.rover.sockets,
		builder: (model, _) => Row(children: [
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
						Expanded(child: VideoFeeds()),
						Sidebar(),
					]
				)),
				Footer(),
			]
		),
	);
}
