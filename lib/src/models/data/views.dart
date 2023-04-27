import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/pages.dart";
import "package:rover_dashboard/widgets.dart";

class ViewsSelector extends StatelessWidget {
	final String currentView;
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
		]
	);
}

class View {
	final String name;
	final Widget Function() builder;
	const View({required this.name, required this.builder});

	static final List<View> cameraViews = [
		for (final name in CameraName.values) 
			if (name != CameraName.CAMERA_NAME_UNDEFINED) View(
				name: name.humanName,
				builder: () => VideoFeed(name: name),
			)
	];

	static const List<View> uiViews = [
		View(name: Routes.science, builder: SciencePage.new),
	];

	static final blank = View(
		name: Routes.blank,
		builder: () => Container(
			color: Colors.blueGrey,
			child: Column(
				children: [
					Row(children: const [Spacer(), ViewsSelector(currentView: Routes.blank)]),
					const Spacer(),
					const Text("Choose a view"),
					const Spacer(),
				]
			)
		)
	);
}

class ViewsModel extends Model {
	List<View> views = [
		View.cameraViews[0],
		View.cameraViews[1],
	];

	@override
	Future<void> init() async { }

	void replaceView(String oldView, View newView) {
		if (views.contains(newView)) {
			models.home.setMessage(severity: Severity.error, text: "That view is already on-screen");
			return;
		}
		final int index = views.indexWhere((view) => view.name == oldView);
		views[index] = newView;
		notifyListeners();
	}

	/// Adds or subtracts a number of views to/from the UI
	void setNumViews(int? value) {
		if (value == null || value > 4 || value < 1) return;
		final int currentNum = views.length;
		if (value < currentNum) {
			views = views.sublist(0, value);
		} else {
			for (int i = currentNum; i < value; i++) {
				views.add(View.blank);
			}
		}
		notifyListeners();
	}

}
