import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:rover_dashboard/models.dart";

/// Displays metrics of all sorts in a collapsible list.
class MetricsList extends StatelessWidget {
	/// A const constructor for this widget.
	const MetricsList();

	@override
	Widget build(BuildContext context) => Consumer<MetricsModel>(
		builder: (context, model, _) => ListView(
			shrinkWrap: true,
			children: [
				Text("Metrics", style: Theme.of(context).textTheme.displaySmall),
				for (final metrics in model.allMetrics) ExpansionTile(
					title: Text(
						metrics?.name ?? "Loading...",
						style: Theme.of(context).textTheme.headlineSmall,
					),
					children: [
						for (final String metric in metrics?.allMetrics ?? []) Text(metric),
					]
				)
			]
		)
	);
}
