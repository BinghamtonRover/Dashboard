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

	/// An icon to indicate the status of the given camera. 
	Widget getCameraStatus(DashboardView view) {
		final name = view.key! as CameraName;
		final status = models.video.feeds[name]!.details.status;
		const size = 12.0;
		switch(status) {
			case CameraStatus.CAMERA_STATUS_UNDEFINED: return const Icon(Icons.question_mark, size: size);
			case CameraStatus.CAMERA_DISCONNECTED: return const Icon(Icons.circle, size: size, color: Colors.black);
			case CameraStatus.CAMERA_ENABLED: return const Icon(Icons.circle, size: size, color: Colors.green);
			case CameraStatus.CAMERA_LOADING: return const Icon(Icons.circle, size: size, color: Colors.blueGrey);
			case CameraStatus.CAMERA_DISABLED: return const Icon(Icons.circle, size: size, color: Colors.orange);
			case CameraStatus.CAMERA_NOT_RESPONDING: return const Icon(Icons.circle, size: size, color: Colors.red);
			case CameraStatus.FRAME_TOO_LARGE: return const Icon(Icons.circle, size: size, color: Colors.orange);
		}
		// Do not use `default` or you will lose exhaustiveness checking
		throw ArgumentError("Unrecognized status: $status");
	}

	@override
	Widget build(BuildContext context) => PopupMenuButton<DashboardView>(
		tooltip: "Select a feed",
		icon: const Icon(Icons.expand_more),
		onSelected: (view) => models.views.replaceView(currentView, view),
		itemBuilder: (_) => [
			const PopupMenuItem(enabled: false, child: Text("Cameras")),
			for (final view in DashboardView.cameraViews) PopupMenuItem(
				value: view,
				child: Row(children: [
					if (models.sockets.video.isConnected) ...[getCameraStatus(view), const SizedBox(width: 8)],
					Text(view.name),
				],),
			),
			const PopupMenuDivider(),
			const PopupMenuItem(enabled: false, child: Text("Controls")),
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
	/// A unique key to use while selecting this view.
	final Object? key;
	/// A function to build this view.
	final WidgetBuilder builder;
	/// A const constructor.
	const DashboardView({required this.name, required this.builder, this.key});

	/// A list of views that represent all the camera feeds.
	static final List<DashboardView> cameraViews = [
		for (final name in CameraName.values) 
			if (name != CameraName.CAMERA_NAME_UNDEFINED) DashboardView(
				name: name.humanName,
				key: name,
				builder: (context) => VideoFeed(name: name),
			)
	];

	/// A list of views that represent all non-camera feeds.
	static final List<DashboardView> uiViews = [
		DashboardView(name: Routes.science, builder: (context) => SciencePage()),
		DashboardView(name: Routes.autonomy, builder: (context) => AutonomyPage()),
		DashboardView(name: Routes.mars, builder: (context) => MarsPage()),
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
