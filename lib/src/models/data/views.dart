import "package:flutter/material.dart";
import "package:flutter_resizable_container/flutter_resizable_container.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/pages.dart";

extension on ResizableController {
  void setRatios(List<double> ratios) => setSizes([
    for (final ratio in ratios)
      ResizableSize.ratio(ratio),
  ]);
}

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

  /// Saves the current state as a preset and updates the user's settings.
  Future<void> saveAsPreset(String? name) async {
    if (name == null) return;
    if (models.settings.dashboard.presets.any((otherPreset) => otherPreset.name == name)) {
      models.home.setMessage(
        severity: Severity.error,
        text: "Name is already taken, please rename preset",
      );
      return;
    }
    final preset = toPreset(name);
    models.settings.dashboard.presets.add(preset);
    await models.settings.update();
  }

  /// Returns a [ViewPreset] to match the current state.
  ViewPreset toPreset(String name) => ViewPreset(
    name: name,
    views: views.toList(),
    horizontal1: horizontalController1.ratios,
    horizontal2: horizontalController2.ratios,
    vertical1: verticalController.ratios,
    vertical2: verticalController2.ratios,
    horizontal3: horizontalController3.ratios,
    horizontal4: horizontalController4.ratios,
  );

  /// Loads preset from Json Row
  Future<void> loadPreset(ViewPreset preset) async {
    setNumViews(preset.views.length);
    resetSizes();
    for(var i = 0; i < preset.views.length; i++){
      replaceView(i, preset.views[i], ignoreErrors: true);
    }
    // This delay is needed to prevent an error
    //
    // While [setNumViews] does update the number of views in the view model,
    // it does not cause a build to occur. This small delay allows the next frame to be
    // built, the UI to update, and *then* updates the ratios. This is necessary because
    // the controllers listed below are directly tied to the UI.
    await Future<void>.delayed(const Duration(milliseconds: 200));
    if (preset.horizontal1.isNotEmpty) horizontalController1.setRatios(preset.horizontal1);
    if (preset.horizontal2.isNotEmpty) horizontalController2.setRatios(preset.horizontal2);
    if (preset.horizontal3.isNotEmpty) horizontalController3.setRatios(preset.horizontal3);
    if (preset.horizontal4.isNotEmpty) horizontalController4.setRatios(preset.horizontal4);
    if (preset.vertical1.isNotEmpty) verticalController.setRatios(preset.vertical1);
    if (preset.vertical2.isNotEmpty) verticalController2.setRatios(preset.vertical2);
  }

  /// Deletes presets and rewrites Json file
  Future<void> deletePreset(ViewPreset preset) async{
    models.settings.dashboard.presets.remove(preset);
    await models.settings.update();
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
  void replaceView(int index, DashboardView newView, {bool ignoreErrors = false}) {
    if (views.contains(newView) && newView.name != Routes.blank) {
      if (!ignoreErrors) {
        models.home.setMessage(
          severity: Severity.error,
          text: "That view is already on-screen",
        );
      }
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
    notifyListeners();
  }

  /// Swaps two presets in the user's settings.
  void swapPresets(int oldIndex, int newIndex) {
    final presets = models.settings.dashboard.presets;
      // ignore: parameter_assignments
    if (oldIndex < newIndex) newIndex -= 1;
    final element = presets.removeAt(oldIndex);
    presets.insert(newIndex, element);
    // This notifyListeners call is needed to update the UI smoothly.
    //
    // A ResizableListView simply *simulates* re-ordering its children. After
    // the child is dropped in its new position, it is sent back to its original
    // position, and it is the backend's job to actually update the underlying data.
    //
    // Calling [SettingsModel.update] here does the job, but its [notifyListeners] call
    // is (correctly) placed *after* the settings file is updated on disk. This introduces
    // a delay in the re-ordering, so items will animate back and forth.
    //
    // This call will update the UI based on the in-memory list before the disk is updated.
    notifyListeners();
    models.settings.update();
  }
}
