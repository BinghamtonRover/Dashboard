import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/pages.dart";
import "package:rover_dashboard/widgets.dart";

enum AutonomyCell {
	rover, destination, obstacle, path, empty
}

class AutonomyPage extends StatelessWidget {
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
					Slider(
						value: model.gridSize.toDouble(),
						min: 1,
						max: 41,
						divisions: 20,
						onChanged: (value) => model.zoom(value.toInt()),
					),
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
					const SizedBox(width: 8),
					Text("Task: ${model.data.task.humanName}", style: context.textTheme.headlineSmall),
					const ViewsSelector(currentView: Routes.autonomy),
				],),
			),
		],),
	);
}

class GridOffset {
	int x;
	int y;
	GridOffset(this.x, this.y);
}
