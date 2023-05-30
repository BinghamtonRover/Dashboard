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
	};

	@override
	Widget build(BuildContext context) => ProviderConsumer<AutonomyModel>(
		create: AutonomyModel.new,
		builder: (model) => Stack(children: [
			Column(
				children: [
					const SizedBox(height: 48),
					for (final row in model.grid) Expanded(
						child: Row(children: [
							for (final cell in row) Expanded(child: Container(
								height: double.infinity,
								width: 24,
								decoration: BoxDecoration(color: getColor(cell), border: Border.all()),
							),)					
						],),
					),
					const SizedBox(height: 4),
					Row(children: [
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
					ProviderConsumer<AutonomyCommandBuilder>.value(
						value: model.command,
						builder: (command) => Row(mainAxisSize: MainAxisSize.min, children: [
							const SizedBox(width: 4),
							Text("Next destination: ", style: context.textTheme.titleLarge),
							const Spacer(),
							SizedBox(width: 250, child: NumberEditor(
								name: "Longitude",
								model: command.longitude,
								width: 12,
								titleFlex: 1,
							),),
							SizedBox(width: 250, child: NumberEditor(
								name: "Latitude",
								model: command.latitude,
								width: 12,
								titleFlex: 1,
							),),
							DropdownEditor<AutonomyTask>(
								name: "Task type",
								value: command.task,
								items: [
									for (final task in AutonomyTask.values) 
										if (task != AutonomyTask.AUTONOMY_TASK_UNDEFINED) task
								],
								onChanged: command.updateTask,
								humanName: (task) => task.humanName,
							),
							ElevatedButton(
								onPressed: command.isLoading ? null : command.submit, 
								child: const Text("Submit"),
							),
							const SizedBox(width: 8),
						],),
					),
					const SizedBox(height: 4),
				],
			),
			Container(
				color: context.colorScheme.surface, 
				height: 48, 
				child: Row(children: [  // The header at the top
					const SizedBox(width: 8),
					Text("Autonomy", style: context.textTheme.headlineMedium), 
					const Spacer(),
					Text("State: ${model.data.state.humanName}", style: context.textTheme.headlineSmall),
					const VerticalDivider(),
					Text("Task: ${model.data.task.humanName}", style: context.textTheme.headlineSmall),
					const ViewsSelector(currentView: Routes.autonomy),
				],),
			),
		],),
	);
}
