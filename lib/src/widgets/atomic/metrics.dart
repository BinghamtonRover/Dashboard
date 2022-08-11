import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";

class MetricsDisplay extends StatelessWidget {
	final Metrics metrics;
	const MetricsDisplay(this.metrics);

	@override
	Widget build(BuildContext context) => Container(
		decoration: BoxDecoration(border: Border.all()),
		padding: EdgeInsets.all(10),
		child: Column(
			children: [
				for (final metric in metrics.allMetrics) Text(metric),
			]
		)
	);
}
