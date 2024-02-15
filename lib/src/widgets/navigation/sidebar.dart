import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
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
				Text("Metrics", style: context.textTheme.displaySmall, textAlign: TextAlign.center),
        for (final metrics in models.rover.metrics.allMetrics)
          MetricsList(metrics),
        const Divider(),
				Text("Controls", style: context.textTheme.displaySmall, textAlign: TextAlign.center),
				const SizedBox(height: 4),
				ControlsDisplay(controller: models.rover.controller1, gamepadNum: 1),
				ControlsDisplay(controller: models.rover.controller2, gamepadNum: 2),
				ControlsDisplay(controller: models.rover.controller3, gamepadNum: 3),
			],
		),
	);
}

/// Displays metrics of all sorts in a collapsible list.
class MetricsList extends ReusableReactiveWidget<Metrics> {
	/// A const constructor for this widget.
	const MetricsList(super.model);

	@override
	Widget build(BuildContext context, Metrics model) => ExpansionTile(
    expandedCrossAxisAlignment: CrossAxisAlignment.start,
    expandedAlignment: Alignment.centerLeft,
    childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
    title: Text(
      model.name,
      style: Theme.of(context).textTheme.headlineSmall,
    ),
    children: [
      for (final String metric in model.allMetrics) Text(metric),
      const SizedBox(height: 4),
    ],
  );
}

/// Displays controls for the given [Controller].
class ControlsDisplay extends ReusableReactiveWidget<Controller> {
	/// The number gamepad being used.
	final int gamepadNum;

	/// A const constructor for this widget.
	const ControlsDisplay({required Controller controller, required this.gamepadNum}) : super(controller);

	@override
	Widget build(BuildContext context, Controller model) => ExpansionTile(
    expandedCrossAxisAlignment: CrossAxisAlignment.start,
    expandedAlignment: Alignment.centerLeft,
    childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    title: Text(
      model.controls.mode.name, 
      style: Theme.of(context).textTheme.titleLarge,
      textAlign: TextAlign.start,
    ),
    children: [
      for (final entry in model.controls.buttonMapping.entries) ...[
        Text(entry.key, style: Theme.of(context).textTheme.labelLarge),
        Text("  ${entry.value}", style: Theme.of(context).textTheme.titleMedium),
      ],
    ],
	);
}
