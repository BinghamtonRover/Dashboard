
import "package:flutter/material.dart";
import "package:rover_dashboard/data.dart";
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
            controller: model.nameController,
            decoration: const InputDecoration(hintText: "Preset Name"),
          ),
        ),
      ],
    ),
    actions: [
      TextButton(child: const Text("Cancel"), onPressed: () => Navigator.of(context).pop()),
      ElevatedButton(
        onPressed: model.isValid ? () {model.save(); Navigator.of(context).pop(); } : null,
        child: const Text("Save"),
      ),
    ],
  );

}


///A stateful widget to delete a preset, includes [PresetBuilder] model.
class PresetDelete extends StatefulWidget{
  /// Model for presetBuilder.
  final PresetBuilder model;

  /// Listens to [model] to rebuild.
  const PresetDelete({required this.model});

  @override
  State<PresetDelete> createState() => _PresetDelete();
}

///A widget to delete a preset backed by [PresetDelete].
class _PresetDelete extends State<PresetDelete>{
  bool activateDelete = false;
  ViewPreset? selectedPreset;

  @override
  Widget build(BuildContext context) => AlertDialog(
      title: const Text("Delete a preset"),
      content: Column(
          mainAxisSize: MainAxisSize.min,
          children:  <Widget>[
            ExpansionTile(
            title: const Text("Saved Presets"),
            children: [
              SizedBox(
                height: models.settings.dashboard.presets.isNotEmpty ? 50 : 0,
                child: SingleChildScrollView(
                  child: Column(
                    children:
                  [for(final ViewPreset preset in models.settings.dashboard.presets) ListTile(
                    title: Text(preset.name),
                    onTap: () {
                      models.home.setMessage(
                        severity: Severity.error,
                        text: "Are you sure you want to delete?",
                      );
                      setState(() {
                        selectedPreset = preset;
                        activateDelete = true;
                      });
                    },
                  ),],),
                ),
              ),] ,
            ),
          ],
      ),
      actions: [
        TextButton(child: const Text("Cancel"), onPressed: () => Navigator.of(context).pop()),
        ElevatedButton(
          onPressed: activateDelete ? delete : null,
          child: const Text("Delete"),
        ),
      ],
    );

    void delete() {
      models.views.delete(selectedPreset!);
      Navigator.of(context).pop();
    }
}
