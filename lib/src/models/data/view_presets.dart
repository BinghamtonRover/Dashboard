
import "package:flutter/foundation.dart";
import "package:collection/collection.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// A mixin to provide preset functionality.
mixin PresetsModel on ChangeNotifier {
  /// The user's Dashboard settings.
  DashboardSettings get settings => models.settings.dashboard;

  /// Swaps two presets in the user's settings.
  void swapPresets(int oldIndex, int newIndex) {
    final presets = settings.presets;
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

  /// Sets the default preset to [preset]
  Future<void> setDefaultPreset(String? preset) async {
    settings.defaultPreset = preset;
    await models.settings.update();
  }

  /// Deletes presets and rewrites Json file
  Future<void> deletePreset(ViewPreset preset) async{
    if (settings.defaultPreset == preset.name) {
      settings.defaultPreset = null;
    }
    settings.presets.remove(preset);
    await models.settings.update();
  }

  /// Returns a [ViewPreset] to match the current state.
  ViewPreset toPreset(String name);

  /// Loads the given preset.
  void loadPreset(ViewPreset preset);

  /// Saves the current state as a preset and updates the user's settings.
  Future<void> saveAsPreset(String? name) async {
    if (name == null) return;
    if (settings.presets.any((otherPreset) => otherPreset.name == name)) {
      models.home.setMessage(
        severity: Severity.error,
        text: "Name is already taken, please rename preset",
      );
      return;
    }
    final preset = toPreset(name);
    settings.presets.add(preset);
    await models.settings.update();
  }

  /// Retreives and loads the default settings.
  Future<void> loadDefaultPreset() async {
    final defaultPresetName = settings.defaultPreset;
    final defaultPreset = settings.presets
      .firstWhereOrNull((preset) => preset.name == defaultPresetName);
    if (defaultPreset == null) return;
    loadPreset(defaultPreset);
  }

  /// Sets or clears this preset as the default.
  void toggleDefaultPreset(ViewPreset preset) {
    if (settings.defaultPreset != preset.name) {
      models.views.setDefaultPreset(preset.name);
    } else {
      models.views.setDefaultPreset(null);
    }
  }

  /// Returns whether this preset is the default.
  bool isDefaultPreset(ViewPreset preset) =>
    settings.defaultPreset == preset.name;

  /// The list of all available presets.
  List<ViewPreset> get presets => settings.presets;

  /// The current [DashboardSettings.splitMode].
  SplitMode get splitMode => settings.splitMode;

  /// Updates [DashboardSettings.splitMode].
  void updateSplitMode(SplitMode? value) {
    if (value == null) return;
    settings.splitMode = value;
    models.settings.update();
    notifyListeners();
  }

  /// Replaces the given preset with the current state using [toPreset].
  Future<void> updatePreset(ViewPreset preset) async {
    final index = presets.indexOf(preset);
    presets[index] = toPreset(preset.name);
    await models.settings.update();
  }
}
