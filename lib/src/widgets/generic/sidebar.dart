import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/widgets.dart";

/// A widget to display metrics and controls off to the side.
/// 
/// The [T] type argument allows this widget to find the controls for the 
/// current operating mode.
class Sidebar<T extends OperatingModeModel> extends StatelessWidget {
	@override
	Widget build(BuildContext context) => Container(
		width: 225, 
		color: Colors.yellow, 
		alignment: Alignment.center,
		child: Consumer<HomeModel>(
			child: const MetricsList(),
			builder: (context, model, metrics) => ListView(
				padding: const EdgeInsets.symmetric(horizontal: 16),
				children: [
					metrics!,
					Text("Controls", style: Theme.of(context).textTheme.displaySmall),
					const SizedBox(height: 16),
					for (final control in model.controls) Text(control),
				]
			)
		)
	);
}
