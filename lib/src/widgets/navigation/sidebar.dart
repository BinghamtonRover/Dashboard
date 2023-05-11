import "package:flutter/material.dart";

import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/widgets.dart";

/// A widget to display metrics and controls off to the side.
class Sidebar extends StatelessWidget {
	/// A const constructor for this widget.
	const Sidebar();

	@override
	Widget build(BuildContext context) => Container(
		width: 250, 
		color: Theme.of(context).colorScheme.surfaceVariant,
		child: ListView(
			padding: const EdgeInsets.symmetric(horizontal: 4),
			children: [
				Text("Metrics", style: Theme.of(context).textTheme.displaySmall, textAlign: TextAlign.center),
				const MetricsList(),
				const Divider(),
				Text("Controls", style: Theme.of(context).textTheme.displaySmall, textAlign: TextAlign.center),
				const SizedBox(height: 4),
				ControlsDisplay(controller: models.rover.controller1, gamepadNum: 1),
				ControlsDisplay(controller: models.rover.controller2, gamepadNum: 2),
			],
		),
	);
}

/// Displays metrics of all sorts in a collapsible list.
class MetricsList extends StatelessWidget {
	/// A const constructor for this widget.
	const MetricsList();

	@override
	Widget build(BuildContext context) => ProviderConsumer<RoverMetrics>.value(
		value: models.rover.metrics,
		builder: (model) => Column(
			children: [
				for (final metrics in model.allMetrics) ExpansionTile(
					expandedCrossAxisAlignment: CrossAxisAlignment.start,
					expandedAlignment: Alignment.centerLeft,
					childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
					title: Text(
						metrics.name,
						style: Theme.of(context).textTheme.headlineSmall,
					),
					children: [
						for (final String metric in metrics.allMetrics) Text(metric),
						const SizedBox(height: 4),
					],
				),
			],
		),
	);
}

/// Displays controls for the given [Controller].
class ControlsDisplay extends StatelessWidget {
	/// The controller to display controls for.
	final Controller controller;

	/// The number gamepad being used.
	final int gamepadNum;

	/// A const constructor for this widget.
	const ControlsDisplay({required this.controller, required this.gamepadNum});

	@override
	Widget build(BuildContext context) => ProviderConsumer<Controller>.value(
		value: controller,
		builder: (_) => ExpansionTile(
			expandedCrossAxisAlignment: CrossAxisAlignment.start,
			expandedAlignment: Alignment.centerLeft,
			childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
			title: Text(
				"Gamepad $gamepadNum: ${controller.controls.mode.name}", 
				style: Theme.of(context).textTheme.titleLarge,
				textAlign: TextAlign.start,
			),
			children: [
				for (final entry in controller.controls.buttonMapping.entries) ...[
					Text(entry.key, style: Theme.of(context).textTheme.labelLarge),
					Text("  ${entry.value}", style: Theme.of(context).textTheme.titleMedium),
				],
			],
		),
	);
}
