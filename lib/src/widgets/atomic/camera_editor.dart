import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/widgets.dart";

class CameraDetailsEditor extends StatelessWidget {
	static const allowedStatuses = [CameraStatus.CAMERA_ENABLED, CameraStatus.CAMERA_DISABLED];

	final VideoData data;
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
					onPressed: model.error != null ? null : () async {
						final result = await model.saveSettings(data.id);
						if (result && context.mounted) Navigator.of(context).pop();
					},
					child: const Text("Save"),
				)
			],
			content: SingleChildScrollView(
				child: Column(
					children: [
						DropdownEditor<CameraName>(
							name: "Name",
							humanName: (value) => value.humanName,
							value: model.name,
							onChanged: model.updateName,
							items: [
								for (final item in CameraName.values)
									if (item != CameraName.CAMERA_NAME_UNDEFINED) item
							]
						),
						DropdownEditor<CameraStatus>(
							name: "Status",
							humanName: (value) => value.humanName,
							value: model.status,
							onChanged: model.updateStatus,
							items: [
								for (final item in CameraStatus.values)
									if (item != CameraStatus.CAMERA_STATUS_UNDEFINED) item
							]
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
