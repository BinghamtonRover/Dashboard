import "package:flutter/material.dart";

import "package:rover_dashboard/pages.dart";
import "package:rover_dashboard/widgets.dart";

enum OperatingMode {
	science(name: "Science", icon: Icons.science, page: ScienceMode()),
	arm(name: "Arm", icon: Icons.precision_manufacturing, page: ArmMode()),
	autonomy(name: "Autonomy", icon: Icons.smart_toy, page: AutonomyMode()),
	manual(name: "Manual", icon: Icons.sports_esports, page: ManualMode());

	final String name;
	final Widget page;
	final IconData icon;
	const OperatingMode({required this.name, required this.page, required this.icon});
}

class Routes { static const String settings = "settings"; }

/// The main dashboard page. 
/// 
/// TODO: Define what exactly will go here.
class HomePage extends StatelessWidget {
	@override
	Widget build(BuildContext context) => DefaultTabController(
		length: OperatingMode.values.length, 
		child: Scaffold(
			appBar: AppBar(
				title: const Text("Rover Control Dashboard"),
				bottom: TabBar(tabs: [
					for (final mode in OperatingMode.values) 
						Tab(text: mode.name, icon: Icon(mode.icon)),
				]),
				actions: [IconButton(
					icon: const Icon(Icons.settings),
					onPressed: () => Navigator.of(context).pushNamed(Routes.settings),
				)]
			),
			body: Column(children: [
				Expanded(child: TabBarView(children: [
					for (final mode in OperatingMode.values) mode.page,
				])),
				Footer(),
			]),
		)
	);
}
