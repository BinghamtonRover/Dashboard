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

/// The main dashboard page. 
/// 
/// TODO: Define what exactly will go here.
class HomePage extends StatefulWidget {
	@override
	HomeState createState() => HomeState();
}

/// A state for the home page.
/// 
/// Responsible for listening to changes in [HomeModel.mode] and animating the UI.
class HomeState extends State<HomePage> with SingleTickerProviderStateMixin {
	/// Controls tab-related UI, like animation.
	late final TabController controller;

	@override
	void initState() {
		super.initState();
		models.home.addListener(listener);
		controller = TabController(length: OperatingMode.values.length, vsync: this);
	}

	@override
	void dispose() {
		controller.dispose();
		models.home.removeListener(listener);
		super.dispose();
	}

	/// Listens to mode changes and animates [controller].
	void listener() {
		controller.animateTo(models.home.mode.index);
	}

	@override
	Widget build(BuildContext context) => Scaffold(
		appBar: AppBar(
			title: const Text("Dashboard"),
			bottom: PreferredSize(
				preferredSize: const Size.fromHeight(32), 
				child: TabBar(
					controller: controller,
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
							controller: controller,
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
	);
}
