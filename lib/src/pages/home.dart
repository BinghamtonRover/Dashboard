import "package:flutter/material.dart";
import "package:provider/provider.dart";

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
class HomePage extends StatelessWidget {
	@override
	Widget build(BuildContext context) => DefaultTabController(
		length: OperatingModePage.allPages.length,
		child: ChangeNotifierProvider(
			create: (_) => HomeModel(), 
			builder: (context, _) => Scaffold(
				appBar: AppBar(
					title: const Text("Dashboard"),
					bottom: PreferredSize(preferredSize: const Size.fromHeight(32), child: 
						TabBar(
						onTap: Provider.of<HomeModel>(context, listen: false).changeMode,
						tabs: [
							for (final page in OperatingModePage.allPages)Row(
								mainAxisAlignment: MainAxisAlignment.center,
								children: [
									Text(page.mode.name), 
									const SizedBox(width: 8), 
									Icon(page.icon)
								]
							)
						],
					)),
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
		)
	);
}
