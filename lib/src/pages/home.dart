import "package:flutter/material.dart";

import "package:rover_dashboard/pages.dart";
import "package:rover_dashboard/widgets.dart";

/// A mode for operating the rover. 
/// 
/// The operator can switch between modes which will: 
/// - change the controller inputs to match the current mode
/// - change the on-screen UI to provide information useful in this context
/// - highlight the relevant metrics
enum OperatingMode {
	/// The operating mode for analyzing dirt samples.
	science(name: "Science", icon: Icons.science, page: ScienceMode()),

	/// The operating mode for controlling the arm
	arm(name: "Arm", icon: Icons.precision_manufacturing, page: ArmMode()),

	/// The operating mode for driving autonomously. 
	autonomy(name: "Autonomy", icon: Icons.smart_toy, page: AutonomyMode()),

	/// The operating mode for driving manually. 
	manual(name: "Manual", icon: Icons.sports_esports, page: ManualMode());

	/// The name of the operating mode.
	final String name;

	/// The contents of the page while in this operating mode.
	final Widget page;

	/// The icon for this operating mode.
	final IconData icon;

	/// Describes the UI for a given operating mode.
	const OperatingMode({required this.name, required this.page, required this.icon});
}

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
				actions: [
					IconButton(
						icon: const Icon(Icons.settings),
						onPressed: () => Navigator.of(context).pushNamed(Routes.settings),
					),
				]
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
