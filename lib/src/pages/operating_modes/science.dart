import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/widgets.dart";

class ScienceMode extends StatelessWidget {
	const ScienceMode();

	@override
	Widget build(BuildContext context) => Row(children: [
		Expanded(child: Column(children: [
			Expanded(flex: 2, child: Container(
				width: double.infinity,
				color: Colors.red, 
				child: const Text("Science video feed"),
			)),
			Expanded(child: Row(
				children: [
					Expanded(child: Container(
						height: double.infinity,
						width: double.infinity,
						color: Colors.green, 
						child: const Text("Microscope video feed"),
					)),
					Expanded(child: Container(
						height: double.infinity,
						width: double.infinity,
						color: Colors.blueGrey, 
						child: const Text("Rover video feed"),
					)),
				]
			))
		])),
		// Spacer(),
		Column(
			// mainAxisAlignment: MainAxisAlignment.center, 
			children: [
				const SizedBox(height: 48),
				const MetricsDisplay(samplePMetrics), 
				const SizedBox(height: 24), 
				const MetricsDisplay(sampleSMetrics),
				const SizedBox(height: 24),
				Text("Controls", style: Theme.of(context).textTheme.headline3),
				const SizedBox(height: 16),
				for (final control in controls) Text(control),
				const Spacer(),
			]
		),
		const SizedBox(width: 16),
	]);
}

final controls = [
	"Start dig sequence: START",
	"Change operation mode: BACK",
	"Move Auger: D-pad Up/Down",
	"...",
];
