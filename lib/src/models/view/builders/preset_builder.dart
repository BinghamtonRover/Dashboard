import "package:flutter/material.dart";
import "package:rover_dashboard/models.dart";

/// A builder for presets.
class PresetBuilder extends ValueBuilder<void> {
  /// The text controller for the Preset name.
  final nameController = TextEditingController();

  @override
  List<ChangeNotifier> get otherBuilders => [nameController];

  @override
  bool get isValid => nameController.text.isNotEmpty;

  @override
  void get value { /* Use [save] instead */ }

  /// Calls `models.views.saveAsPreset` in views.dart
  void save() => models.views.saveAsPreset(nameController.text);
}
