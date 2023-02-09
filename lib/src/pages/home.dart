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

	/// Creates a new [OperatingModePage] to represent an [OperatingMode]
	factory OperatingModePage.fromMode(OperatingMode mode) {
		switch (mode) {
			case OperatingMode.science: return const OperatingModePage(mode: OperatingMode.science, page: SciencePage(), icon: Icons.science);
			case OperatingMode.arm: return const OperatingModePage(mode: OperatingMode.arm, page: ArmPage(), icon: Icons.precision_manufacturing);
			case OperatingMode.autonomy: return const OperatingModePage(mode: OperatingMode.autonomy, page: AutonomyPage(), icon: Icons.smart_toy);
			case OperatingMode.drive: return const OperatingModePage(mode: OperatingMode.drive, page: DrivePage(), icon: Icons.sports_esports);
		}
	}

	/// All the pages for all the operating modes.
	static final allPages = [
		for (final OperatingMode mode in OperatingMode.values) 
			OperatingModePage.fromMode(mode)
	];
}

/// The main dashboard page. 
/// 
/// TODO: Define what exactly will go here.
class HomePage extends StatelessWidget {
	@override
	Widget build(BuildContext context) => DefaultTabController(
		length: OperatingModePage.allPages.length,
		child: Scaffold(
			appBar: AppBar(
				title: const Text("Dashboard"),
				bottom: PreferredSize(
					preferredSize: const Size.fromHeight(32), 
					child: TabBar(
						onTap: models.home.changeMode,
						tabs: [
							for (final page in OperatingModePage.allPages) Row(
								mainAxisAlignment: MainAxisAlignment.center,
								children: [
									Text(page.mode.name), 
									const SizedBox(width: 8), 
									Icon(page.icon)
								]
							)
						],
					)
				),
				actions: [
					IconButton(
						icon: const Icon(Icons.settings),
						onPressed: () => Navigator.of(context).pushNamed(Routes.settings),
					),
				]
			),
			body: Column(
				children: [
					Expanded(child: Row(
						children: [
							Expanded(child: TabBarView(
								physics: const NeverScrollableScrollPhysics(),  // must use buttons
								children: [ 
									for (final page in OperatingModePage.allPages) page.page
								]
							)),
							Sidebar(),
						]
					)),
					Footer(),
				]
			),
		)
	);
}
