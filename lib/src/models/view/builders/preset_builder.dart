import "package:flutter/material.dart";
import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// A builder for presets.
class PresetBuilder extends ValueBuilder<void> {
  /// The text controller for the Preset name.
  final myController = TextEditingController();
  
  @override
  bool get isValid => myController.text.isNotEmpty;

  @override
  void get value { /* Use [start] instead */ }

  /// Updates the UI.
  void update(_) => notifyListeners();
  
  /// Calls [models.views.saveAsPreset] in views.dart
  void save(){
    models.views.saveAsPreset(myController.text);
  }

  /// Calls [delete] in views.dart
  void delete(ViewPreset preset){
    models.views.delete(preset);
    notifyListeners();
  }
}
