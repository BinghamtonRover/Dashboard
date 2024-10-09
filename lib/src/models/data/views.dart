import "package:flutter/material.dart";
import "package:flutter_resizable_container/flutter_resizable_container.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/pages.dart";
import "package:rover_dashboard/services.dart";

/// A function that builds a view of the given index.
typedef ViewBuilder = Widget Function(BuildContext context, int index);

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

  ///Saves preset as a JSon row in settings and rewrites the settings
  Future<void> saveAsPreset(String? name) async {
    for (final preset in models.settings.dashboard.presets){
      if(preset.name == name){
        models.home.setMessage(
        severity: Severity.error,
        text: "Name is already taken, please rename preset",
      );
      return;
      }
    }
    final copy = List<DashboardView>.from(views);
    final preset = ViewPreset(name: name, views: copy, horizontal1: horizontalController1.ratios, horizontal2: horizontalController2.ratios,  horizontal3: horizontalController3.ratios, horizontal4: horizontalController4.ratios, vertical1: verticalController.ratios, vertical2: verticalController2.ratios);
    models.settings.dashboard.presets.add(preset);
    await services.files.writeSettings(models.settings.all);
  }
  ///Loads preset from Json Row
  void loadPreset(ViewPreset preset) {
    setNumViews(preset.views.length);
    if (preset.horizontal1.toList().isNotEmpty) horizontalController1.setRatios(preset.horizontal1.toList());
    if (preset.horizontal2.toList().isNotEmpty) horizontalController2.setRatios(preset.horizontal2.toList());
    if (preset.horizontal3.toList().isNotEmpty) horizontalController3.setRatios(preset.horizontal3.toList());
    if (preset.horizontal4.toList().isNotEmpty) horizontalController4.setRatios(preset.horizontal4.toList());
    if (preset.vertical1.toList().isNotEmpty) verticalController.setRatios(preset.vertical1.toList());
    if (preset.vertical2.toList().isNotEmpty) verticalController2.setRatios(preset.vertical2.toList());
    for(var i =0; i < preset.views.length; i++){
      replaceView(i, preset.views[i]);
    }
  }

  /// Deletes presets and rewrites Json file
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
