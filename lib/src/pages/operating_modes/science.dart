import "package:flutter/material.dart";

import "package:rover_dashboard/widgets.dart";

/// The page for the science operating mode. 
class ScienceMode extends StatelessWidget {
	/// A const constructor for this widget.
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
		Container(
			width: 225, 
			color: Colors.yellow, 
			alignment: Alignment.center,
			child: ListView(
				padding: const EdgeInsets.symmetric(horizontal: 16),
				children: [
					const MetricsList(),
					Text("Controls", style: Theme.of(context).textTheme.headline3),
					const SizedBox(height: 16),
					for (final control in controls) Text(control),
				]
			)
		),
	]);
}

/// The controls for the current operating mode, until there is a backend in place.
final controls = [
	"Start dig sequence: START",
	"Change operation mode: BACK",
	"Move Auger: D-pad Up/Down",
	"...",
];
