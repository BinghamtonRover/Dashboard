import "package:flutter/material.dart";

import "package:rover_dashboard/pages.dart";
import "package:rover_dashboard/widgets.dart";

import "../models/view/camera_feed.dart";
import "../models/view/feeds_notifier.dart";

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

/// different pages of the rover dashboard
enum Page {
  /// the number of the science page
  science(number: 0),

  /// the number of the arm page
  arm(number: 1),

  /// the number of the autonomy page
  autonomy(number: 2),

  /// the number of the manual page
  manual(number: 3);

  /// the number associated with the page
  final int number;

  /// constructor for the page enum
  const Page({required this.number});
}

/// list of all possible camera feeds
  List<CameraFeed> feeds = <CameraFeed>[CameraFeed("Science Video Feed", "Science", Page.science.number, pinned: true),
    CameraFeed("Microscope Video Feed", "Microscope", Page.science.number), CameraFeed("Rover Video Feed 1", "Rover 1", Page.manual.number, pinned: true),
    CameraFeed("Rover Video Feed 2", "Rover 2", Page.manual.number), CameraFeed("Arm Video Feed 1", "Arm 1", Page.arm.number, pinned: true), 
    CameraFeed("Arm Video Feed 2", "Arm 2", Page.arm.number), CameraFeed("Autonomy Video Feed", "Autonomy", Page.autonomy.number, pinned: true)];

/// The main dashboard page. 
/// 
/// TODO: Define what exactly will go here.
class HomePage extends StatelessWidget {

  /// the change notifier object for the camera feeds
  static FeedsNotifier feedsNotifier = FeedsNotifier(feeds, 4);

  /// the boolean value will change whenever feedsNotifier.onChange() is called so the widgets update
  static ValueNotifier<bool> feedsListener = ValueNotifier(false);

  //static ValueNotifier<FeedsNotifier> feedsNotifier = ValueNotifier(FeedsNotifier(feeds, 4));

  /// add the listener to change the boolean value and update widgets
  HomePage() {
    feedsNotifier.addListener(() {
      feedsListener.value = !feedsListener.value;
    });
  }
  
	@override
	Widget build(BuildContext context) => DefaultTabController(
		length: operatingModes.length, ///OperatingMode.values.length, 
		child: Scaffold(
			appBar: AppBar(
				title: const Text("Rover Control Dashboard"),
				bottom: TabBar(tabs: [
					for (final mode in operatingModes) ///OperatingMode.values)
						Tab(text: mode.name, icon: Icon(mode.icon)),
          ],
          onTap:(value) {
            feedsNotifier.currentPage = value;
            feedsNotifier.onChange();
          },
        ),
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
