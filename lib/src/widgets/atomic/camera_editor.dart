import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/widgets.dart";

/// A widget to modify [CameraDetails] for a given camera, backed by a [CameraDetailsBuilder].
class CameraDetailsEditor extends ReactiveWidget<CameraDetailsBuilder> {
  /// The details for the camera being modified
  final CameraDetails details;

  /// The id for the camera being modified
  final String id;

	/// Creates a widget to modify a [CameraDetails].
	const CameraDetailsEditor({required this.details, required this.id});

  @override
  CameraDetailsBuilder createModel() => CameraDetailsBuilder(details);

	@override
	Widget build(BuildContext context, CameraDetailsBuilder model) => AlertDialog(
    title: const Text("Modify camera"),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text("Cancel"),
      ),
      ElevatedButton(
        onPressed: !model.isValid ? null : () async {
          final result = await model.saveSettings(id);
          if (result && context.mounted) Navigator.of(context).pop();
        },
        child: const Text("Save"),
      ),
    ],
    content: SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownEditor<CameraStatus>(
              name: "Status",
              humanName: (value) => value.humanName,
              value: model.status,
              onChanged: model.updateStatus,
              items: CameraDetailsBuilder.okStatuses,
            ),
          ),
          Row(
            children: [
              Flexible(
                child: NumberEditor(
                  name: "Capture Width",
                  model: model.captureWidth,
                  width: 5,
                  titleFlex: 3,
                ),
              ),
              Flexible(
                child: NumberEditor(
                  name: "Capture Height",
                  model: model.captureHeight,
                  width: 5,
                  titleFlex: 3,
                ),
              ),
          
            ],
          ),
          Row(
            children: [
              Flexible(
                child: NumberEditor(
                  name: "Stream Width",
                  model: model.streamWidth,
                  width: 5,
                  titleFlex: 3,
                ),
              ),
              Flexible(
                child: NumberEditor(
                  name: "Stream Height",
                  model: model.streamHeight,
                  width: 5,
                  titleFlex: 3,
                ),
              ),
            ],
          ),
          NumberEditor(
            name: "Quality (0-100)",
            model: model.quality,
            titleFlex: 2,
          ),
          NumberEditor(
            name: "Frames per second",
            model: model.fps,
            titleFlex: 2,
          ),
          const SizedBox(height: 24),
          if (model.isLoading) const Text("Loading..."),
          if (model.error != null) Text(model.error!, style: const TextStyle(color: Colors.red)),
        ],
      ),
    ),
	);
}
