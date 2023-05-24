import "package:flutter/material.dart";

import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/pages.dart";
import "package:rover_dashboard/widgets.dart";

class MarsPage extends StatelessWidget {
	@override
	Widget build(BuildContext context) => Stack(children: [
		Column(),
		Container(  // The header at the top
			color: context.colorScheme.surface, 
			height: 48, 
			child: Row(children: [
				const SizedBox(width: 8),
				Text("MARS", style: context.textTheme.headlineMedium), 
				const Spacer(),
				const ViewsSelector(currentView: Routes.mars),
			],),
		),
	],);
}
