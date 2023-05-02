import "package:flutter/material.dart";

import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/widgets.dart";

/// A widget to render all the views the user selected.
class ViewsWidget extends StatelessWidget {
	/// A const constructor.
	const ViewsWidget();

	/// Renders the view at the given [index] in [ViewsModel.views].
	Widget getView(BuildContext context, int index) => Expanded(child: Container(
		decoration: BoxDecoration(border: Border.all(width: 3)),
		child: models.views.views[index].builder(context),
	),);

	@override
	Widget build(BuildContext context) => ProviderConsumer<ViewsModel>.value(
		value: models.views,
		builder: (model) => Column(children: [
			Expanded(
				child: Row(children: [
					if (model.views.isNotEmpty) getView(context, 0),
					if (model.views.length >= 3) getView(context, 1),
				],
			),),
			if (model.views.length >= 2) Expanded(
				child: Row(children: [
					if (model.views.length >= 2) 
						// Put the 2nd view on the bottom row or the upper left corner
						if (model.views.length >= 3) getView(context, 2)
						else getView(context, 1),
					if (model.views.length >= 4) getView(context, 3)
				],),
			),
		],),
	);
}
