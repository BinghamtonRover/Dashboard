import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:rover_dashboard/models.dart";

/// Displays metrics of all sorts in a collapsible list.
class MetricsList extends StatelessWidget {
	/// A const constructor for this widget.
	const MetricsList();

	@override
	Widget build(BuildContext context) => Consumer<Rover>(
		builder: (context, rover, _) => Column(
			children: [
				for (final metrics in rover.metrics.allMetrics) ExpansionTile(
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
					]
				)
			]
		)
	);
}
