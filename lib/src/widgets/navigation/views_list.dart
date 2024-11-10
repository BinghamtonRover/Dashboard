import "package:flutter/material.dart";
import "package:rover_dashboard/data.dart";

import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/pages.dart";
import "package:rover_dashboard/widgets.dart";

/// A simple model that just listens for changes in the network and settings.
class ViewsSidebarModel with ChangeNotifier {
  /// Listens for changes in the network and settings.
  ViewsSidebarModel() {
    models.sockets.addListener(notifyListeners);
    models.views.addListener(notifyListeners);
    models.settings.addListener(notifyListeners);
  }

  @override
  void dispose() {
    models.sockets.removeListener(notifyListeners);
    models.views.removeListener(notifyListeners);
    models.settings.removeListener(notifyListeners);
    super.dispose();
  }
}

/// A list of views for the user to drag into their desired view area
class ViewsList extends ReactiveWidget<ViewsSidebarModel> {
  /// The size of the icon to appear under the mouse pointer when dragging
  static const double draggingIconSize = 100;

  @override
  ViewsSidebarModel createModel() => ViewsSidebarModel();

  /// A const constructor
  const ViewsList();

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
  Widget build(BuildContext context, ViewsSidebarModel model) => ListView(
    children: [
          ExpansionTile(
            title: const Text("Presets"),
            children: [
              ReorderableListView(
                shrinkWrap: true,
                onReorder: models.views.swapPresets,
                children: [
                  for (final preset in models.settings.dashboard.presets)
                    ListTile(
                      key: ValueKey(preset.name),
                      title: Text(preset.name),
                      onTap: () => models.views.loadPreset(preset),
                      leading: IconButton(
                        onPressed: () => _deletePreset(context, preset),
                        icon: const Icon(Icons.remove_circle),
                        splashColor: Colors.blueGrey,
                        color: Colors.red,
                      ),
                      trailing: Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Tooltip(
                          message: "Set as default preset",
                          waitDuration: const Duration(milliseconds: 500),
                          child: IconButton(
                            onPressed: () {
                              if (models.settings.dashboard.defaultPreset !=
                                  preset.name) {
                                models.views.setDefaultPreset(preset.name);
                              } else {
                                models.views.setDefaultPreset("");
                              }
                            },
                            icon: (models.settings.dashboard.defaultPreset ==
                                    preset.name)
                                ? const Icon(Icons.star)
                                : const Icon(Icons.star_outline),
                            splashColor: Colors.blueGrey,
                            color: Colors.yellow,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

          ListTile(
            title: const Text("Save current layout"),
            onTap: () => _savePreset(context),
            trailing: const Icon(Icons.save),
          ),
        ],
      ),
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
          for (final view in DashboardView.uiViews) _buildDraggable(view),
        ],
      ),
      _buildDraggable(DashboardView.blank),
    ],
  );

  void _deletePreset(BuildContext context, ViewPreset preset) => showDialog<void>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Delete a preset"),
      content: Text("Are you sure you want to delete the preset ${preset.name}?"),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          onPressed: () {
            models.views.deletePreset(preset);
            Navigator.of(context).pop();
          },
          child: const Text("Delete"),
        ),
      ],
    ),
  );

  void _savePreset(BuildContext context) => showDialog<void>(
    context: context,
    builder: (_) => PresetSave(),
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
          for (final view in DashboardView.cameraViews) _buildItem(view),
          const PopupMenuDivider(),
          const PopupMenuItem(enabled: false, child: Text("Controls")),
          for (final view in DashboardView.uiViews) _buildItem(view),
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
