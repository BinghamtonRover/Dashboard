import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/widgets.dart";

/// A widget to display metrics and controls off to the side.
class Sidebar extends StatelessWidget {
	@override
	Widget build(BuildContext context) => Container(
		width: 225, 
		alignment: Alignment.center,
		color: Theme.of(context).colorScheme.surfaceVariant,
		child: Consumer<Rover>(
			child: const MetricsList(),
			builder: (context, rover, metrics) => ListView(
				padding: const EdgeInsets.symmetric(horizontal: 16),
				children: [
					metrics!,
					const Divider(),
					Text("Controls", style: Theme.of(context).textTheme.displaySmall),
					const SizedBox(height: 16),
					for (final entry in rover.controller.controls.entries) ...[
						Text(entry.key, style: Theme.of(context).textTheme.titleLarge),
						Text("  ${entry.value}", style: Theme.of(context).textTheme.titleMedium),
					]
				]
			)
		)
	);
}
