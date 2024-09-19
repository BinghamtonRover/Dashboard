import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/pages.dart";
import "package:rover_dashboard/widgets.dart";

/// A list of views for the user to drag into their desired view area
class ViewsList extends ReusableReactiveWidget<Sockets> {
  /// The size of the icon to appear under the mouse pointer when dragging
  static const double draggingIconSize = 100;

  /// A const constructor
  ViewsList() : super(models.sockets);

  @override
  Widget build(BuildContext context, Sockets model) => ListView(
    children: [
      ExpansionTile(
        title: const Text("Cameras"),
        children: [
          for (final view in DashboardView.cameraViews)
            Draggable<DashboardView>(
              data: view,
              affinity: Axis.horizontal,
              dragAnchorStrategy: (draggable, context, position) =>
                  const Offset(draggingIconSize, draggingIconSize) / 2,
              feedback: const SizedBox(
                width: draggingIconSize,
                height: draggingIconSize,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Icon(Icons.camera_alt),
                ),
              ),
              child: ListTile(
                mouseCursor: SystemMouseCursors.move,
                title: Text(view.name),
                leading: ViewsSelector.getCameraStatus(view),
              ),
            ),
        ],
      ),
      ExpansionTile(
        title: const Text("Controls"),
        children: [
          for (final view in DashboardView.uiViews)
            Draggable<DashboardView>(
              data: view,
              affinity: Axis.horizontal,
              dragAnchorStrategy: (draggable, context, position) =>
                  const Offset(draggingIconSize, draggingIconSize) / 2,
              feedback: SizedBox(
                width: draggingIconSize,
                height: draggingIconSize,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Icon(view.icon),
                ),
              ),
              child: ListTile(
                mouseCursor: SystemMouseCursors.move,
                title: Text(view.name),
                leading: Icon(view.icon),
              ),
            ),
        ],
      ),
      Draggable<DashboardView>(
        data: DashboardView.blank,
        affinity: Axis.horizontal,
        dragAnchorStrategy: (draggable, context, position) =>
          const Offset(draggingIconSize, draggingIconSize) / 2,
        feedback: const SizedBox(
          width: 100,
          height: 100,
          child: FittedBox(
            fit: BoxFit.fill,
            child: Icon(Icons.delete),
          ),
        ),
        child: const ListTile(
          mouseCursor: SystemMouseCursors.move,
          title: Text("Remove View"),
          trailing: Icon(Icons.delete),
        ),
      ),
    ],
  );
}

/// A button for the user to select a new view.
class ViewsSelector extends StatelessWidget {
  /// The index of this view.
  final int index;

  /// A const constructor.
  const ViewsSelector({required this.index});

  /// An icon to indicate the status of the given camera.
  static Widget getCameraStatus(DashboardView view) {
    if (!models.sockets.video.isConnected) {
      return const Icon(Icons.signal_wifi_off);
    }
    final name = view.key! as CameraName;
    final status = models.video.feeds[name]!.details.status;
    const size = 12.0;
    return switch (status) {
      CameraStatus.CAMERA_STATUS_UNDEFINED =>
        const Icon(Icons.question_mark, size: size),
      CameraStatus.CAMERA_DISCONNECTED =>
        const Icon(Icons.circle, size: size, color: Colors.black),
      CameraStatus.CAMERA_ENABLED =>
        const Icon(Icons.circle, size: size, color: Colors.green),
      CameraStatus.CAMERA_LOADING =>
        const Icon(Icons.circle, size: size, color: Colors.blueGrey),
      CameraStatus.CAMERA_DISABLED =>
        const Icon(Icons.circle, size: size, color: Colors.orange),
      CameraStatus.CAMERA_NOT_RESPONDING =>
        const Icon(Icons.circle, size: size, color: Colors.red),
      CameraStatus.FRAME_TOO_LARGE =>
        const Icon(Icons.circle, size: size, color: Colors.orange),
      CameraStatus.CAMERA_HAS_NO_NAME =>
        const Icon(Icons.circle, size: size, color: Colors.black),
      _ => throw ArgumentError("Unrecognized status: $status"),
    };
  }

  @override
  Widget build(BuildContext context) => PopupMenuButton<DashboardView>(
    tooltip: "Select a feed",
    icon: const Icon(Icons.expand_more),
    onSelected: (view) => models.views.replaceView(index, view),
    itemBuilder: (_) => [
      const PopupMenuItem(enabled: false, child: Text("Cameras")),
      for (final view in DashboardView.cameraViews)
        PopupMenuItem(
          value: view,
          child: Row(
            children: [
              getCameraStatus(view),
              const SizedBox(width: 8),
              Text(view.name),
            ],
          ),
        ),
      const PopupMenuDivider(),
      const PopupMenuItem(enabled: false, child: Text("Controls")),
      for (final view in DashboardView.uiViews)
        PopupMenuItem(
          value: view,
          child: Row(
            children: [
              Icon(view.icon),
              const SizedBox(width: 8),
              Text(view.name),
            ],
          ),
        ),
    ],
  );
}
