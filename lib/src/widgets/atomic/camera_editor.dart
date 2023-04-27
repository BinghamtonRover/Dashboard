import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/widgets.dart";

/// A widget to modify [CameraDetails] for a given camera, backed by a [CameraDetailsBuilder].
class CameraDetailsEditor extends StatelessWidget {
	/// The data for the camera being modified.
	/// 
	/// This must be a [VideoData] and not a [CameraDetails] to get the camera's ID.
	final VideoData data;

	/// Creates a widget to modify a [CameraDetails].
	const CameraDetailsEditor(this.data);

	@override
	Widget build(BuildContext context) => ProviderConsumer<CameraDetailsBuilder>(
		create: () => CameraDetailsBuilder(data.details),
		builder: (model, _) => AlertDialog(
			title: const Text("Modify camera"),
			actions: [
				TextButton(
					onPressed: () => Navigator.of(context).pop(),
					child: const Text("Cancel"),
				),
				ElevatedButton(
					onPressed: !model.isValid ? null : () async {
						final result = await model.saveSettings(data.id);
						if (result && context.mounted) Navigator.of(context).pop();
					},
					child: const Text("Save"),
				)
			],
			content: SingleChildScrollView(
				child: Column(
					children: [
						DropdownEditor<CameraStatus>(
							name: "Status",
							humanName: (value) => value.humanName,
							value: model.status,
							onChanged: model.updateStatus,
							items: CameraDetailsBuilder.okStatuses,
						),
						NumberEditor(
							name: "Resolution height",
							model: model.resolutionHeight,
						),
						NumberEditor(
							name: "Resolution width",
							model: model.resolutionWidth,
						),
						NumberEditor(
							name: "Quality (0-100)",
							model: model.quality,
						),
						NumberEditor(
							name: "Frames per second",
							model: model.fps,
						),
						const SizedBox(height: 24),
						if (model.isLoading) const Text("Loading..."),
						if (model.error != null) Text(model.error!, style: const TextStyle(color: Colors.red))
					],
				),
			),
		),
	);
}
