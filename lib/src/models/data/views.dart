
import "dart:convert";
import "dart:ffi";

import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:flutter_resizable_container/flutter_resizable_container.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/pages.dart";
import "package:rover_dashboard/services.dart";
import "package:rover_dashboard/src/models/view/builders/preset_builder.dart";
import "package:rover_dashboard/widgets.dart";

/// A list of views for the user to drag into their desired view area
class ViewsList extends StatelessWidget {
  /// The size of the icon to appear under the mouse pointer when dragging
  static const double draggingIconSize = 100;
  final myController = TextEditingController();
  
  ViewsList({super.key});

  /// Get a widget for the camera status of the view
  Widget getCameraStatus(DashboardView view) {
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
  Widget build(BuildContext context) => ListView(
        children: [
          ExpansionTile(
            title: const Text("Cameras"),
            children: [
              for (final view in DashboardView.cameraViews)
                Draggable<DashboardView>(
                  data: view,
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
                    leading: (models.sockets.video.isConnected)
                        ? getCameraStatus(view)
                        : null,
                    trailing: const Icon(Icons.camera_alt),
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
                    trailing: Icon(view.icon),
                  ),
                ),
            ],
          ),
          Draggable<DashboardView>(
            data: DashboardView.blank,
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
          ExpansionTile(
            title: Text("Presets"),
            children:[
              ListTile(
                title: Text("Save Preset"),
                onTap: () => showDialog<void>(context: context, builder: (_) => PresetSave()),
              ),
              ListTile(
                title: Text("Load Preset"),    
                onTap:  () => showDialog<void>(context: context, builder: (_) => PresetLoad()),            
              ),  
              ListTile(
                title: Text("Delete Preset"),
                onTap:  () => showDialog<void>(context: context, builder: (BuildContext context) =>  PresetDelete(model: PresetBuilder(),)),            

              )
            ]
          ),
        ],
      );
}

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
  final CameraName? key;

  /// A function to build this view.
  final ViewBuilder builder;

  /// The Flutter widget key for this view.
  final Key flutterKey;

  /// A const constructor.
  DashboardView(
      {required this.name, required this.builder, this.icon, this.key,})
      : flutterKey = UniqueKey();

  static final List<DashboardView> allViews = [...cameraViews, ...uiViews, blank];

  static DashboardView? fromJson(Json json) => allViews
    .firstWhereOrNull((view) => view.name == json["name"] && view.key?.value == json["cameraName"]);
  
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
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Convoluted way to get all horizontal space filled
          Row(children: [Spacer()]),
          Text("Drag in a view"),
          Row(children: [Spacer()]),
        ],
      ),
    ),
  );
}



/// A data model for keeping track of the on-screen views.
class ViewsModel extends Model {
  /// The controller for the resizable row on top.
  final horizontalController1 = ResizableController();

  /// The controller for the resizable row on bottom.
  final horizontalController2 = ResizableController();

  /// The controller for screen 2's first row.
  final horizontalController3 = ResizableController();

  /// The controller for screen 2's second row.
  final horizontalController4 = ResizableController();

  /// The controller for the resizable column.
  final verticalController = ResizableController();

  /// The vertical controller for screen 2.
  final verticalController2 = ResizableController();

  /// The current views on the screen.
  List<DashboardView> views = [
    DashboardView.cameraViews[0],
  ];

  @override
  Future<void> init() async {
    models.settings.addListener(notifyListeners);
  }

  Future<void> saveAsPreset(String? name) async {
    for(ViewPreset preset in models.settings.dashboard.presets){
      if(preset.name == name){
        models.home.setMessage(
        severity: Severity.error,
        text: "Name is already taken, please rename preset",
      );
      return;
      }
    }
    final preset = ViewPreset(name: name, views: views, horizontal1: horizontalController1.ratios, horizontal2: horizontalController2.ratios,  horizontal3: horizontalController3.ratios, horizontal4: horizontalController4.ratios, vertical1: verticalController.ratios, vertical2: verticalController2.ratios);
    models.settings.dashboard.presets.add(preset);
    await services.files.writeSettings(models.settings.all);
  }

  void loadPreset(ViewPreset preset) {
    setNumViews(preset.views.length);
    !preset.horizontal1.toList().isEmpty ? horizontalController1.setRatios(preset.horizontal1.toList()) : null;  
    !preset.horizontal2.toList().isEmpty ? horizontalController2.setRatios(preset.horizontal2.toList()) : null;    
    !preset.horizontal3.toList().isEmpty ? horizontalController3.setRatios(preset.horizontal3.toList()) : null;  
    !preset.horizontal4.toList().isEmpty ? horizontalController4.setRatios(preset.horizontal4.toList()) : null;
    !preset.vertical1.toList().isEmpty ? verticalController.setRatios(preset.vertical1.toList()) : null;  
    !preset.vertical2.toList().isEmpty ? verticalController2.setRatios(preset.vertical2.toList()) : null;   
    for(var i =0; i < preset.views.length; i++){
      replaceView(i, preset.views[i]);
    }
  }

  Future<void> delete(ViewPreset preset) async{
    models.settings.dashboard.presets.remove(preset);
    await services.files.writeSettings(models.settings.all); 
  }



  @override
  void dispose() {
    models.settings.removeListener(notifyListeners);
    horizontalController1.dispose();
    horizontalController2.dispose();
    horizontalController3.dispose();
    horizontalController4.dispose();
    verticalController.dispose();
    verticalController2.dispose();
    super.dispose();
  }

  /// Resets the size of all the views.
  void resetSizes() {
    if (views.length == 2 &&
        models.settings.dashboard.splitMode == SplitMode.horizontal) {
      verticalController.setRatios([0.5, 0.5]);
    } else if (views.length > 2) {
      verticalController.setRatios([0.5, 0.5]);
    }
    if (views.length == 2 &&
        models.settings.dashboard.splitMode == SplitMode.vertical) {
      horizontalController1.setRatios([0.5, 0.5]);
    } else if (views.length > 2) {
      horizontalController1.setRatios([0.5, 0.5]);
    }
    if (views.length == 4) horizontalController2.setRatios([0.5, 0.5]);
    if (views.length == 8) {
      horizontalController2.setRatios([0.5, 0.5]);
      horizontalController3.setRatios([0.5, 0.5]);
      horizontalController4.setRatios([0.5, 0.5]);
      verticalController.setRatios([0.5, 0.5]);
      verticalController2.setRatios([0.5, 0.5]);
    }
  }

  /// Replaces the view at the given index with the new view.
  void replaceView(int index, DashboardView newView) {
    if (views.contains(newView) && newView.name != Routes.blank) {
      models.home.setMessage(
        severity: Severity.error,
        text: "That view is already on-screen",
      );
      return;
    }
    views[index] = newView;
    notifyListeners();
  }

  /// Adds or subtracts a number of views to/from the UI
  void setNumViews(int? value) {
    if (value == null || value > 8 || value < 1) return;
    final currentNum = views.length;
    if (value < currentNum) {
      views = views.sublist(0, value);
    } else {
      for (var i = currentNum; i < value; i++) {
        views.add(DashboardView.blank);
      }
    }
    // resetSizes();
    notifyListeners();
  }
}
