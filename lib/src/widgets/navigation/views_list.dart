import "package:flutter/material.dart";

import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/pages.dart";
import "package:rover_dashboard/widgets.dart";

/// A list of views for the user to drag into their desired view area
class ViewsList extends ReusableReactiveWidget<Sockets> {
  /// The size of the icon to appear under the mouse pointer when dragging
  static const double draggingIconSize = 100;

  /// A const constructor
  ViewsList() : super(models.sockets);

  Widget _buildDraggable(DashboardView view, {Widget? dragIcon}) => Draggable<DashboardView>(
    data: view,
    affinity: Axis.horizontal,
    dragAnchorStrategy: (draggable, context, position) =>
        const Offset(draggingIconSize, draggingIconSize) / 2,
    feedback: SizedBox(
      width: draggingIconSize,
      height: draggingIconSize,
      child: FittedBox(
        fit: BoxFit.fill,
        child: dragIcon ?? view.icon,
      ),
    ),
    child: ListTile(
      mouseCursor: SystemMouseCursors.move,
      title: Text(view.name),
      leading: view.icon,
    ),
  );

  @override
  Widget build(BuildContext context, Sockets model) => ListView(
    children: [
      ExpansionTile(
        title: const Text("Cameras"),
        children: [
          for (final view in DashboardView.cameraViews)
            _buildDraggable(view, dragIcon: const Icon(Icons.camera_alt)),
        ],
      ),
      ExpansionTile(
        title: const Text("Controls"),
        children: [
          for (final view in DashboardView.uiViews)
            _buildDraggable(view),
        ],
      ),
      _buildDraggable(DashboardView.blank),
    ],
  );
}

/// A button for the user to select a new view.
class ViewsSelector extends StatelessWidget {
  /// The index of this view.
  final int index;

  /// A const constructor.
  const ViewsSelector({required this.index});

  @override
  Widget build(BuildContext context) => PopupMenuButton<DashboardView>(
    tooltip: "Select a feed",
    icon: const Icon(Icons.expand_more),
    onSelected: (view) => models.views.replaceView(index, view),
    itemBuilder: (_) => [
      const PopupMenuItem(enabled: false, child: Text("Cameras")),
      for (final view in DashboardView.cameraViews)
        _buildItem(view),
      const PopupMenuDivider(),
      const PopupMenuItem(enabled: false, child: Text("Controls")),
      for (final view in DashboardView.uiViews)
        _buildItem(view),
    ],
  );

  PopupMenuItem<DashboardView> _buildItem(DashboardView view) => PopupMenuItem(
    value: view,
    child: Row(
      children: [
        view.icon,
        const SizedBox(width: 8),
        Text(view.name),
      ],
    ),
  );
}
