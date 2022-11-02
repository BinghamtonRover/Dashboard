import "package:flutter/material.dart";

import "package:rover_dashboard/pages.dart";
import "package:rover_dashboard/widgets.dart";

import '../models/view/camera_feed.dart';

/// A mode for operating the rover. 
/// 
/// The operator can switch between modes which will: 
/// - change the controller inputs to match the current mode
/// - change the on-screen UI to provide information useful in this context
/// - highlight the relevant metrics

/// class for the operating mode so the variables do not have to be final
class OpMode {
  /// The name of the operating mode.
	final String name;
	/// The contents of the page while in this operating mode. CANNOT BE FINAL
	Widget page;
	/// The icon for this operating mode.
	final IconData icon;

  /// Describes the UI for a given operating mode.
  OpMode(this.name, this.page, this.icon);
}

/// list of all the possible operating modes
List<OpMode> operatingModes = <OpMode>[OpMode("Science", ScienceMode(), Icons.science), 
  OpMode("Arm", ArmMode(), Icons.precision_manufacturing), OpMode("Autonomy", AutonomyMode(), Icons.smart_toy),
  OpMode("Manual", ManualMode(), Icons.sports_esports)];

/// The main dashboard page. 
/// 
/// TODO: Define what exactly will go here.
class HomePage extends StatelessWidget {

  /// list of all possible camera feeds
  static List<CameraFeed> feeds = <CameraFeed>[CameraFeed("Science Video Feed", "Science", pinned: true),
    CameraFeed("Microscope Video Feed", "Microscope"), CameraFeed("Rover Video Feed", "Rover"),
    CameraFeed("Extra Video Feed", "Extra")];

  /// the number of camera feeds currently selected
  static ValueNotifier<int> numCameraFeeds = ValueNotifier(feeds.where((element) => element.showing).length);

  /// the shortName of the currently pinned cameraFeed
  static ValueNotifier<String> pinnedCameraFeed = ValueNotifier(feeds.where((element) => element.pinned).first.shortName);
  
	@override
	Widget build(BuildContext context) => DefaultTabController(
		length: operatingModes.length, ///OperatingMode.values.length, 
		child: Scaffold(
			appBar: AppBar(
				title: const Text("Rover Control Dashboard"),
				bottom: TabBar(tabs: [
					for (final mode in operatingModes) ///OperatingMode.values)
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
					for (final mode in operatingModes) mode.page,
				])),
				Footer(),
			]),
		)
	);


}
