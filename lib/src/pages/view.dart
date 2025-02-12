import "package:collection/collection.dart";
import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/pages.dart";
import "package:rover_dashboard/src/pages/controller.dart";
import "package:rover_dashboard/widgets.dart";

/// A function that builds a view of the given index.
typedef ViewBuilder = Widget Function(BuildContext context, int index);

/// A view in the UI.
///
/// A view can be a camera feed or any other UI element. Views are arranged in a grid.
class DashboardView {
  /// The name of the view.
  final String name;

  /// A function to dynamically compute the icon for the view.
  Widget Function(BuildContext context) iconFunc;

  /// A unique key to use while selecting this view.
  final CameraName? key;

  /// A function to build this view.
  final ViewBuilder builder;

  /// The Flutter widget key for this view.
  final Key flutterKey;

  /// A const constructor.
  DashboardView({required this.name, required this.builder, required this.iconFunc, this.key})
      : flutterKey = UniqueKey();

  /// Expands or contracts based on number of camera/ui views.
  static final List<DashboardView> allViews = [...cameraViews, ...uiViews, blank];

  /// Finds the right view in [allViews] that matches the given JSON.
  static DashboardView? fromJson(Json json) => allViews
    .firstWhereOrNull((view) => view.name == json["name"] && view.key?.value == json["cameraName"]);

  /// Converts name of uiView/cameraKey into json format
  Json toJson() => {
    "name": name,
    "cameraName": key?.value,
  };

  /// A list of views that represent all the camera feeds.
  static final List<DashboardView> cameraViews = [
    for (final name in CameraName.values)
      if (name != CameraName.CAMERA_NAME_UNDEFINED)
        DashboardView(
          name: name.humanName,
          key: name,
          iconFunc: (context) => getCameraStatus(context, name),
          builder: (context, index) => VideoFeed(name: name, index: index),
        ),
  ];

  /// An icon to indicate the status of the given camera.
  static Widget getCameraStatus(BuildContext context, CameraName name) {
    if (!models.sockets.video.isConnected) {
      return Icon(Icons.signal_wifi_off, color: context.colorScheme.onSurface.withValues(alpha: 0.5));
    }
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

  /// A list of views that represent all non-camera feeds.
  static final List<DashboardView> uiViews = [
    DashboardView(
      name: Routes.science,
      iconFunc: (context) => Icon(Icons.science, color: context.colorScheme.onSurface.withValues(alpha: 0.5)),
      builder: (context, index) => SciencePage(index: index),
    ),
    DashboardView(
      name: Routes.autonomy,
      iconFunc: (context) => Icon(Icons.map, color: context.colorScheme.onSurface.withValues(alpha: 0.5)),
      builder: (context, index) => MapPage(index: index),
    ),
    DashboardView(
      name: Routes.electrical,
      iconFunc: (context) => Icon(Icons.bolt, color: context.colorScheme.onSurface.withValues(alpha: 0.5)),
      builder: (context, index) => ElectricalPage(index: index),
    ),
    DashboardView(
      name: Routes.lidar,
      iconFunc: (context) => Icon(Icons.radar, color: context.colorScheme.onSurface.withValues(alpha: 0.5)),
      builder: (context, index) => LidarView(index: index),
    ),
    DashboardView(
      name: Routes.arm,
      iconFunc: (context) => Icon(Icons.precision_manufacturing_outlined, color: context.colorScheme.onSurface.withValues(alpha: 0.5)),
      builder: (context, index) => ArmPage(index: index),
    ),
    DashboardView(
      name: Routes.drive,
      iconFunc: (context) => Icon(Icons.drive_eta, color: context.colorScheme.onSurface.withValues(alpha: 0.5)),
      builder: (context, index) => DrivePage(index: index),
    ),
    DashboardView(
      name: Routes.rocks,
      iconFunc: (context) => Icon(Icons.landslide, color: context.colorScheme.onSurface.withValues(alpha: 0.5)),
      builder: (context, index) => RocksPage(index: index),
    ),
    DashboardView(
      name: Routes.controllers,
      iconFunc: (context) => Icon(Icons.sports_esports, color: context.colorScheme.onSurface.withValues(alpha: 0.5)),
      builder: (context, index) => ControllersPage(index: index),
    ),
  ];

  /// A blank view.
  static final blank = DashboardView(
    name: Routes.blank,
    iconFunc: (context) => const Icon(Icons.delete),
    builder: (context, index) => ColoredBox(
      color: context.colorScheme.brightness == Brightness.light
        ? Colors.blueGrey
        : Colors.blueGrey[700]!,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(children: [const Spacer(), ViewsSelector(index: index)]),
          const Spacer(),
          const Text("Drag in or choose a view", textAlign: TextAlign.center),
          const Spacer(),
        ],
      ),
    ),
  );
}
