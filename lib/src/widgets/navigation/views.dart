import "package:flutter/material.dart";
import "package:flutter_resizable_container/flutter_resizable_container.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/widgets.dart";

/// A widget to render all the views the user selected.
class ViewsWidget extends StatelessWidget {
	/// A const constructor.
	const ViewsWidget();

	@override
	Widget build(BuildContext context) => ProviderConsumer<ViewsModel>.value(
		value: models.views,
		builder: (model) => LayoutBuilder(
      builder: (context, constraints) => switch (model.views.length) {
      1 => Column(children: [Expanded(child: models.views.views.first.builder(context))]),
      2 => ResizableContainer(
        direction: switch (models.settings.dashboard.splitMode) {
          SplitMode.horizontal => Axis.vertical,
          SplitMode.vertical => Axis.horizontal,
        },
        dividerWidth: 5, 
        dividerColor: Colors.black,
        children: [
          ResizableChildData(
            startingRatio: 0.5,
            child: models.views.views[0].builder(context),
          ),
          ResizableChildData(
            startingRatio: 0.5,
            child: models.views.views[1].builder(context),
          ),
        ],
      ),
      3 => ResizableContainer(
        direction: Axis.vertical,
        dividerWidth: 5, 
        dividerColor: Colors.black,
        children: [
          ResizableChildData(
            startingRatio: 0.5,
            child: ResizableContainer(
              direction: Axis.horizontal,
              dividerWidth: 5, 
              dividerColor: Colors.black,
              children: [
                ResizableChildData(
                  startingRatio: 0.5,
                  child: models.views.views[0].builder(context),
                ),
                ResizableChildData(
                  startingRatio: 0.5,
                  child: models.views.views[1].builder(context),
                ),
              ],
            ),
          ),
          ResizableChildData(
            startingRatio: 0.5,
            child: models.views.views[2].builder(context),
          ),
        ],
      ),
      4 => ResizableContainer(
        direction: Axis.vertical,
        dividerWidth: 5, 
        dividerColor: Colors.black,
        children: [
          ResizableChildData(
            startingRatio: 0.5,
            child: ResizableContainer(
              direction: Axis.horizontal,
              dividerWidth: 5, 
              dividerColor: Colors.black,
              children: [
                ResizableChildData(
                  startingRatio: 0.5,
                  child: models.views.views[0].builder(context),
                ),
                ResizableChildData(
                  startingRatio: 0.5,
                  child: models.views.views[1].builder(context),
                ),
              ],
            ),
          ),
          ResizableChildData(
            startingRatio: 0.5,
            child: ResizableContainer(
              direction: Axis.horizontal,
              dividerWidth: 5, 
              dividerColor: Colors.black,
              children: [
                ResizableChildData(
                  startingRatio: 0.5,
                  child: models.views.views[2].builder(context),
                ),
                ResizableChildData(
                  startingRatio: 0.5,
                  child: models.views.views[3].builder(context),
                ),
              ],
            ),
          ),
        ],
      ),
      _ => throw StateError("Too many views: ${model.views.length}"),
    },),
	);
}
