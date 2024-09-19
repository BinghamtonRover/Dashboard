import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/pages.dart";
import "package:rover_dashboard/widgets.dart";

/// A function that builds a view of the given index.
typedef ViewBuilder = Widget Function(BuildContext context, int index);

/// A view in the UI.
///
/// A view can be a camera feed or any other UI element. Views are arranged in a grid.
class DashboardView {
  /// The name of the view.
  final String name;

  /// The icon used to represent the view
  final IconData? icon;

  /// A unique key to use while selecting this view.
  final Object? key;

  /// A function to build this view.
  final ViewBuilder builder;

  /// The Flutter widget key for this view.
  final Key flutterKey;

  /// A const constructor.
  DashboardView({required this.name, required this.builder, this.icon, this.key})
      : flutterKey = UniqueKey();

  /// A list of views that represent all the camera feeds.
  static final List<DashboardView> cameraViews = [
    for (final name in CameraName.values)
      if (name != CameraName.CAMERA_NAME_UNDEFINED)
        DashboardView(
          name: name.humanName,
          key: name,
          builder: (context, index) => VideoFeed(name: name, index: index),
        ),
  ];

  /// A list of views that represent all non-camera feeds.
  static final List<DashboardView> uiViews = [
    DashboardView(
      name: Routes.science,
      icon: Icons.science,
      builder: (context, index) => SciencePage(index: index),
    ),
    DashboardView(
      name: Routes.autonomy,
      icon: Icons.map,
      builder: (context, index) => MapPage(index: index),
    ),
    DashboardView(
      name: Routes.electrical,
      icon: Icons.bolt,
      builder: (context, index) => ElectricalPage(index: index),
    ),
    DashboardView(
      name: Routes.arm,
      icon: Icons.precision_manufacturing_outlined,
      builder: (context, index) => ArmPage(index: index),
    ),
    DashboardView(
      name: Routes.drive,
      icon: Icons.drive_eta,
      builder: (context, index) => DrivePage(index: index),
    ),
    DashboardView(
      name: Routes.rocks,
      icon: Icons.landslide,
      builder: (context, index) => RocksPage(index: index),
    ),
  ];

  /// A blank view.
  static final blank = DashboardView(
    name: Routes.blank,
    builder: (context, index) => ColoredBox(
      color: context.colorScheme.brightness == Brightness.light
          ? Colors.blueGrey
          : Colors.blueGrey[700]!,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Convoluted way to get all horizontal space filled
          Row(children: [const Spacer(), ViewsSelector(index: index)]),
          const Spacer(),
          const Text("Drag in or choose a view"),
          const Spacer(),
        ],
      ),
    ),
  );
}
