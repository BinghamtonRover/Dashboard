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
	Widget build(BuildContext context) => PopupMenuButton<View>(
		tooltip: "Select a feed",
		icon: const Icon(Icons.expand_more),
		onSelected: (view) => models.views.replaceView(currentView, view),
		itemBuilder: (_) => [
			for (final view in View.cameraViews) PopupMenuItem(
				value: view,
				child: Text(view.name),
			),
			const PopupMenuDivider(),
			for (final view in View.uiViews) PopupMenuItem(
				value: view,
				child: Text(view.name),
			),
		],
	);
}

/// A view in the UI.
/// 
/// A view can be a camera feed or any other UI element. Views are arranged in a grid.
class View {
	/// The name of the view.
	final String name;
	/// A function to build this view.
	final Widget Function() builder;
	/// A const constructor.
	const View({required this.name, required this.builder});

	/// A list of views that represent all the camera feeds.
	static final List<View> cameraViews = [
		for (final name in CameraName.values) 
			if (name != CameraName.CAMERA_NAME_UNDEFINED) View(
				name: name.humanName,
				builder: () => VideoFeed(name: name),
			)
	];

	/// A list of views that represent all non-camera feeds.
	static const List<View> uiViews = [
		View(name: Routes.science, builder: SciencePage.new),
	];

	/// A blank view.
	static final blank = View(
		name: Routes.blank,
		builder: () => ColoredBox(
			color: Colors.blueGrey,
			child: Column(
				children: [
					Row(children: const [Spacer(), ViewsSelector(currentView: Routes.blank)]),
					const Spacer(),
					const Text("Choose a view"),
					const Spacer(),
				],
			),
		),
	);
}

/// A data model for keeping track of the on-screen views.
class ViewsModel extends Model {
	/// The current views on the screen.
	List<View> views = [
		View.cameraViews[0],
	];

	@override
	Future<void> init() async { }

	/// Replaces the [oldView] with the [newView].
	void replaceView(String oldView, View newView) {
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
				views.add(View.blank);
			}
		}
		notifyListeners();
	}

}
