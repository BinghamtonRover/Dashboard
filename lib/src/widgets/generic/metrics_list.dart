import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";

/// Displays metrics of all sorts in a collapsible list.
class MetricsList extends StatelessWidget {
	/// A constant constructor for this widget.
	const MetricsList();

	/// All the metrics to display.
	static const List<Metrics> tempMetrics = [];

	@override
	Widget build(BuildContext context) => ExpansionPanelList(
		children: [
			for (final metrics in tempMetrics) ExpansionPanel(
				headerBuilder: (_, __) => Text(metrics.name),
				body: Column(
					children: [
						for (final String metric in metrics.allMetrics) Text(metric),
					]
				)
			)
		]
	);
}
