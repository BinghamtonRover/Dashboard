import "dart:math";
import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/pages.dart";
import "package:rover_dashboard/widgets.dart";

/// The UI for the autonomy subsystem.
/// 
/// Displays a bird's-eye view of the rover and its path to the goal.
class AutonomyPage extends StatelessWidget {
	/// Gets the color for a given [AutonomyCell].
	Color? getColor(AutonomyCell cell) => switch(cell) {
		AutonomyCell.rover => Colors.blue,
		AutonomyCell.destination => Colors.green,
		AutonomyCell.obstacle => Colors.black,
		AutonomyCell.path => Colors.blueGrey,
		AutonomyCell.empty => Colors.white,
		AutonomyCell.marker => Colors.red,
	};

  /// Opens a dialog to prompt the user for GPS coordinates and places a marker there. 
  void placeMarker(BuildContext context, AutonomyModel model) => showDialog<void>(
    context: context, 
    builder: (_) => AlertDialog(
      title: const Text("Add a Marker"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GpsEditor(model: model.markerBuilder),
        ],
      ),
      actions: [
        TextButton(child: const Text("Cancel"), onPressed: () => Navigator.of(context).pop()),
        ElevatedButton(
          onPressed: model.markerBuilder.isValid ? () { model.placeMarker(); Navigator.of(context).pop(); } : null,
          child: const Text("Add"), 
        ),
      ],
    ),
  );

  /// Opens a dialog to prompt the user to create an [AutonomyCommand] and sends it to the rover.
  void createTask(BuildContext context, AutonomyCommandBuilder command) => showDialog<void>(
    context: context, 
    builder: (_) => AlertDialog(
      title: const Text("Create a new Task"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownEditor<AutonomyTask>(
            name: "Task type",
            value: command.task,
            items: [
              for (final task in AutonomyTask.values) 
                if (task != AutonomyTask.AUTONOMY_TASK_UNDEFINED) task,
            ],
            onChanged: command.updateTask,
            humanName: (task) => task.humanName,
          ),
          GpsEditor(model: command.gps),
        ],
      ),
      actions: [
        TextButton(child: const Text("Cancel"), onPressed: () => Navigator.of(context).pop()),
        ElevatedButton(
          onPressed: command.isLoading ? null : () { command.submit(); Navigator.of(context).pop(); },
          child: const Text("Submit"), 
        ),
      ],
    ),
  );

	@override
	Widget build(BuildContext context) => ProviderConsumer<AutonomyModel>(
		create: AutonomyModel.new,
		builder: (model) => Stack(children: [
			Column(children: [
        const SizedBox(height: 48),
        for (final row in model.grid) Expanded(
          child: Row(children: [
            for (final cell in row) Expanded(
              child: Container(
                height: double.infinity,
                width: 24,
                decoration: BoxDecoration(color: getColor(cell), border: Border.all()),
                child: cell != AutonomyCell.rover ? null : ProviderConsumer<PositionMetrics>.value(
                  value: models.rover.metrics.position, 
                  builder: (position) => Transform.rotate(
                    angle: position.angle * pi / 180, 
                    child: const Icon(Icons.arrow_upward, size: 24),
                  ),
                ),
              ),
            ),
          ],),
        ),
        const SizedBox(height: 4),
        Row(children: [  // Legend
          const SizedBox(width: 4),
          Text("Legend:", style: context.textTheme.titleLarge),
          const SizedBox(width: 8),
          Container(width: 24, height: 24, color: Colors.blue),
          const SizedBox(width: 4),
          Text("Rover", style: context.textTheme.titleMedium),
          const SizedBox(width: 24),
          Container(width: 24, height: 24, color: Colors.green),
          const SizedBox(width: 4),
          Text("Destination", style: context.textTheme.titleMedium),
          const SizedBox(width: 24),
          Container(width: 24, height: 24, color: Colors.black),
          const SizedBox(width: 4),
          Text("Obstacle", style: context.textTheme.titleMedium),
          const SizedBox(width: 24),
          Container(width: 24, height: 24, color: Colors.blueGrey),
          const SizedBox(width: 4),
          Text("Path", style: context.textTheme.titleMedium),
          const SizedBox(width: 24),
          Container(width: 24, height: 24, color: Colors.red),
          const SizedBox(width: 4),
          Text("Marker", style: context.textTheme.titleMedium),
          const Spacer(),
          Text("Zoom: ", style: context.textTheme.titleLarge),
          Expanded(flex: 2, child: Slider(
            value: model.gridSize.toDouble(),
            min: 1,
            max: 41,
            divisions: 20,
            label: "${model.gridSize}x${model.gridSize}",
            onChanged: (value) => model.zoom(value.toInt()),
          ),),
        ],),
        Row(children: [  // Controls
          const SizedBox(width: 4),
          Text("Place marker: ", style: context.textTheme.titleLarge),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            icon: const Icon(Icons.add), 
            label: const Text("Add Marker"), 
            onPressed: () => placeMarker(context, model),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(icon: const Icon(Icons.clear), label: const Text("Clear all"), onPressed: model.clearMarkers),
          const Spacer(),
          ProviderConsumer<AutonomyCommandBuilder>(
          create: AutonomyCommandBuilder.new,
          builder: (command) => Row(children: [
            const SizedBox(width: 4),
            Text("Autonomy: ", style: context.textTheme.titleLarge),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.add), 
              label: const Text("New Task"), 
              onPressed: () => createTask(context, command),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
              onPressed: command.abort,
              child: const Text("ABORT"), 
            ),
          ],),
        ),
        const SizedBox(width: 8),
        ],),
        const SizedBox(height: 4),
      ],),
			Container(
				color: context.colorScheme.surface, 
				height: 50, 
				child: Row(children: [  // The header at the top
					const SizedBox(width: 8),
					Text("Map", style: context.textTheme.headlineMedium), 
					const Spacer(),
					Text("Autonomy status: ${model.data.state.humanName}, ${model.data.task.humanName}", style: context.textTheme.headlineSmall),
					const VerticalDivider(),
					const ViewsSelector(currentView: Routes.autonomy),
				],),
			),
		],),
	);
}
