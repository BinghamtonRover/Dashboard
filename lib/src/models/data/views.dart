import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/pages.dart";
import "package:rover_dashboard/widgets.dart";

/// A button for the user to select a new view.
class ViewsSelector extends StatelessWidget {
	/// The current view to swap with the user's choice of view.
	final String currentView;

	/// A const constructor.
	const ViewsSelector({required this.currentView});

	@override
	Widget build(BuildContext context) => PopupMenuButton<DashboardView>(
		tooltip: "Select a feed",
		icon: const Icon(Icons.expand_more),
		onSelected: (view) => models.views.replaceView(currentView, view),
		itemBuilder: (_) => [
			for (final view in DashboardView.cameraViews) PopupMenuItem(
				value: view,
				child: Text(view.name),
			),
			const PopupMenuDivider(),
			for (final view in DashboardView.uiViews) PopupMenuItem(
				value: view,
				child: Text(view.name),
			),
		],
	);
}

/// A view in the UI.
/// 
/// A view can be a camera feed or any other UI element. Views are arranged in a grid.
class DashboardView {
	/// The name of the view.
	final String name;
	/// A function to build this view.
	final WidgetBuilder builder;
	/// A const constructor.
	const DashboardView({required this.name, required this.builder});

	/// A list of views that represent all the camera feeds.
	static final List<DashboardView> cameraViews = [
		for (final name in CameraName.values) 
			if (name != CameraName.CAMERA_NAME_UNDEFINED) DashboardView(
				name: name.humanName,
				builder: (context) => VideoFeed(name: name),
			)
	];

	/// A list of views that represent all non-camera feeds.
	static final List<DashboardView> uiViews = [
		DashboardView(name: Routes.science, builder: (context) => SciencePage()),
		DashboardView(name: Routes.autonomy, builder: (context) => AutonomyPage()),
	];

	/// A blank view.
	static final blank = DashboardView(
		name: Routes.blank,
		builder: (context) => ColoredBox(
			color: context.colorScheme.brightness == Brightness.light
				? Colors.blueGrey
				: Colors.blueGrey[700]!, 
			child: const Column(
				children: [
					Row(children: [Spacer(), ViewsSelector(currentView: Routes.blank)]),
					Spacer(),
					Text("Choose a view"),
					Spacer(),
				],
			),
		),
	);
}

/// A data model for keeping track of the on-screen views.
class ViewsModel extends Model {
	/// The current views on the screen.
	List<DashboardView> views = [
		DashboardView.cameraViews[0],
	];

	@override
	Future<void> init() async { }

	/// Replaces the [oldView] with the [newView].
	void replaceView(String oldView, DashboardView newView) {
		if (views.contains(newView)) {
			models.home.setMessage(severity: Severity.error, text: "That view is already on-screen");
			return;
		}
		final index = views.indexWhere((view) => view.name == oldView);
		views[index] = newView;
		notifyListeners();
	}

	/// Adds or subtracts a number of views to/from the UI
	void setNumViews(int? value) {
		if (value == null || value > 4 || value < 1) return;
		final currentNum = views.length;
		if (value < currentNum) {
			views = views.sublist(0, value);
		} else {
			for (var i = currentNum; i < value; i++) {
				views.add(DashboardView.blank);
			}
		}
		notifyListeners();
	}

}
