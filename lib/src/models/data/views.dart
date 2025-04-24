import "dart:async";

import "package:flutter/scheduler.dart";
import "package:flutter_resizable_container/flutter_resizable_container.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/pages.dart";

import "view_presets.dart";

extension on ResizableController {
  void setRatios(List<double> ratios) => setSizes([
    for (final ratio in ratios)
      ResizableSize.ratio(ratio),
  ]);

  void reset([int size = 0]) => setRatios(List.filled(size, 0.5));
}

/// A data model for keeping track of the on-screen views.
class ViewsModel extends Model with PresetsModel {
  /// The controller for the resizable row on top.
  final horizontalController1 = ResizableController();

  /// The controller for the resizable row on bottom.
  final horizontalController2 = ResizableController();

  /// The controller for screen 2's first row.
  final horizontalController3 = ResizableController();

  /// The controller for screen 2's second row.
  final horizontalController4 = ResizableController();

  /// The controller for the resizable column.
  final verticalController1 = ResizableController();

  /// The vertical controller for screen 2.
  final verticalController2 = ResizableController();

  /// The current views on the screen.
  List<DashboardView> views = [
    DashboardView.cameraViews[0],
  ];

  @override
  Future<void> init() async {
    models.settings.addListener(notifyListeners);
    unawaited(loadDefaultPreset());
  }

  @override
  void dispose() {
    models.settings.removeListener(notifyListeners);
    horizontalController1.dispose();
    horizontalController2.dispose();
    horizontalController3.dispose();
    horizontalController4.dispose();
    verticalController1.dispose();
    verticalController2.dispose();
    super.dispose();
  }

  @override
  ViewPreset toPreset(String name) => ViewPreset(
    name: name,
    splitMode: splitMode,
    views: views.toList(),
    horizontal1: (views.length > 2) || (views.length == 2 && splitMode == SplitMode.vertical)
      ? horizontalController1.ratios : [],
    horizontal2: views.length > 3 ? horizontalController2.ratios : [],
    horizontal3: views.length == 8 ? horizontalController3.ratios : [],
    horizontal4: views.length == 8 ? horizontalController4.ratios : [],
    vertical1: (views.length > 2) || (views.length == 2 && splitMode == SplitMode.horizontal)
      ? verticalController1.ratios : [],
    vertical2: views.length == 8 ? verticalController2.ratios : [],
  );

  /// Whether there is a preset already loading.
  bool isLoadingPreset = false;

  @override
  Future<void> loadPreset(ViewPreset preset) async {
    if (isLoadingPreset) return;
    isLoadingPreset = true;
    updateSplitMode(preset.splitMode);
    views = List.filled(views.length, DashboardView.blank, growable: true);
    // Wait for all views to reset so as not to cause overflow issues
    await nextFrame();
    setNumViews(preset.views.length);
    notifyListeners();
    // Wait 3 frames for flutter_resizable container to load
    await nextFrame();
    await nextFrame();
    await nextFrame();
    await nextFrame();
    await nextFrame();
    if (preset.horizontal1.isNotEmpty) horizontalController1.setRatios(preset.horizontal1);
    if (preset.horizontal2.isNotEmpty) horizontalController2.setRatios(preset.horizontal2);
    if (preset.horizontal3.isNotEmpty) horizontalController3.setRatios(preset.horizontal3);
    if (preset.horizontal4.isNotEmpty) horizontalController4.setRatios(preset.horizontal4);
    if (preset.vertical1.isNotEmpty) verticalController1.setRatios(preset.vertical1);
    if (preset.vertical2.isNotEmpty) verticalController2.setRatios(preset.vertical2);
    views = preset.views.toList();
    notifyListeners();
    isLoadingPreset = false;
  }

  /// Waits for the next frame to build.
  Future<void> nextFrame() {
    final completer = Completer<void>();
    SchedulerBinding.instance.addPostFrameCallback((_) => completer.complete());
    return completer.future;
  }

  /// Resets the size of all the views.
  void resetSizes() {
    if (
      views.length == 2
      && models.settings.dashboard.splitMode == SplitMode.horizontal
    ) {
      verticalController1.reset(2);
    } else if (
      views.length == 2
      && models.settings.dashboard.splitMode == SplitMode.vertical
    ) {
      horizontalController1.reset(2);
    } else if (views.length == 3) {
      horizontalController1.reset(2);
      verticalController1.reset(2);
    }
    if (views.length == 4) {
      horizontalController1.reset(2);
      horizontalController2.reset(2);
      verticalController1.reset(2);
    }
    if (views.length == 8) {
      horizontalController1.reset(2);
      horizontalController2.reset(2);
      horizontalController3.reset(2);
      horizontalController4.reset(2);
      verticalController1.reset(2);
      verticalController2.reset(2);
    }
    notifyListeners();
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
}
