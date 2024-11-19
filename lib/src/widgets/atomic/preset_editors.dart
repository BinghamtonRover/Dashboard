
import "package:flutter/material.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/widgets.dart";

///A widget to save a preset backed by [PresetBuilder].
class PresetSave extends ReactiveWidget<PresetBuilder> {
  @override
  PresetBuilder createModel() => PresetBuilder();

  @override
  Widget build(BuildContext context, PresetBuilder model) => AlertDialog(
    title: const Text("Save a preset"),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 50,
          width: double.infinity,
          child: TextField(
            autofocus: true,
            controller: model.nameController,
            decoration: const InputDecoration(hintText: "Preset Name"),
            onSubmitted: (_) => save(context, model),
          ),
        ),
      ],
    ),
    actions: [
      TextButton(
        child: const Text("Cancel"),
        onPressed: () => Navigator.of(context).pop(),
      ),
      ElevatedButton(
        onPressed: !model.isValid ? null : () => save(context, model),
        child: const Text("Save"),
      ),
    ],
  );

  /// Saves the preset and closes the dialog.
  void save(BuildContext context, PresetBuilder model) {
    model.save();
    Navigator.of(context).pop();
  }
}
