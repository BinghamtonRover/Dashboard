import "package:flutter/material.dart";

import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/widgets.dart";

class ViewsWidget extends StatelessWidget {
	const ViewsWidget();

	Widget getView(int index) => Expanded(child: Container(
		margin: const EdgeInsets.all(1),
		decoration: BoxDecoration(border: Border.all(width: 3)),
		child: models.views.views[index].builder()),
	);

	@override
	Widget build(BuildContext context) => ProviderConsumer<ViewsModel>.value(
		value: models.views,
		builder: (model) => Column(children: [
			Expanded(
				child: Row(children: [
					if (model.views.isNotEmpty) getView(0),
					if (model.views.length >= 3) getView(1),
				],
			)),
			if (model.views.length >= 2) Expanded(
				child: Row(children: [
					if (model.views.length >= 2) 
						// Put the 2nd view on the bottom row or the upper left corner
						getView(model.views.length >= 3 ? 2 : 1),
					if (model.views.length >= 4) getView(3)
				])
			)
		])
	);
}
