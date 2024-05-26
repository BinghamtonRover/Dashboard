import "package:flutter/material.dart";
import "package:flutter_resizable_container/flutter_resizable_container.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/widgets.dart";

/// A widget to render all the views the user selected.
class ViewsWidget extends ReusableReactiveWidget<ViewsModel> {
	/// A const constructor.
	ViewsWidget() : super(models.views);

	@override
	Widget build(BuildContext context, ViewsModel model) => switch (model.views.length) {
    1 => Column(children: [Expanded(
      child: models.views.views[0].builder(context, 0),
    ),],),
    2 => ResizableContainer(
      direction: switch (models.settings.dashboard.splitMode) {
        SplitMode.horizontal => Axis.vertical,
        SplitMode.vertical => Axis.horizontal,
      },
      dividerWidth: 8, 
      controller: switch (models.settings.dashboard.splitMode) {
        SplitMode.horizontal => model.verticalController,
        SplitMode.vertical => model.horizontalController1,
      },
      dividerColor: Colors.black,
      children: [
        ResizableChildData(
          minSize: 100,
          startingRatio: 0.5,
          child: models.views.views[0].builder(context, 0),
        ),
        ResizableChildData(
          minSize: 100,
          startingRatio: 0.5,
          child: models.views.views[1].builder(context, 1),
        ),
      ],
    ),
    3 || 4 => ResizableContainer(
      controller: model.verticalController,
      direction: Axis.vertical,
      dividerWidth: 8, 
      dividerColor: Colors.black,
      children: [
        ResizableChildData(
          minSize: 100,
          startingRatio: 0.5,
          child: ResizableContainer(
            controller: model.horizontalController1,
            direction: Axis.horizontal,
            dividerWidth: 8, 
            dividerColor: Colors.black,
            children: [
              ResizableChildData(
                minSize: 100,
                startingRatio: 0.5,
                child: models.views.views[0].builder(context, 0),
              ),
              ResizableChildData(
                minSize: 100,
                startingRatio: 0.5,
                child: models.views.views[1].builder(context, 1),
              ),
            ],
          ),
        ),
        if (model.views.length == 3) ResizableChildData(
          minSize: 100,
          startingRatio: 0.5,
          child: models.views.views[2].builder(context, 2),
        ) else ResizableChildData(
          minSize: 100,
          startingRatio: 0.5,
          child: ResizableContainer(
            controller: model.horizontalController2,
            direction: Axis.horizontal,
            dividerWidth: 8, 
            dividerColor: Colors.black,
            children: [
              ResizableChildData(
                minSize: 100,
                startingRatio: 0.5,
                child: models.views.views[2].builder(context, 2),
              ),
              ResizableChildData(
                minSize: 100,
                startingRatio: 0.5,
                child: models.views.views[3].builder(context, 3),
              ),
            ],
          ),
        ),
      ],
    ),
    8 => Row(children: [
      Expanded(child: ResizableContainer(
        controller: model.verticalController,
        direction: Axis.vertical,
        dividerWidth: 8, 
        dividerColor: Colors.black,
        children: [
          ResizableChildData(
            minSize: 100,
            startingRatio: 0.5,
            child: ResizableContainer(
              controller: model.horizontalController1,
              direction: Axis.horizontal,
              dividerWidth: 8, 
              dividerColor: Colors.black,
              children: [
                ResizableChildData(
                  minSize: 100,
                  startingRatio: 0.5,
                  child: models.views.views[0].builder(context, 0),
                ),
                ResizableChildData(
                  minSize: 100,
                  startingRatio: 0.5,
                  child: models.views.views[1].builder(context, 1),
                ),
              ],
            ),
          ),
          ResizableChildData(
            minSize: 100,
            startingRatio: 0.5,
            child: ResizableContainer(
              controller: model.horizontalController2,
              direction: Axis.horizontal,
              dividerWidth: 8, 
              dividerColor: Colors.black,
              children: [
                ResizableChildData(
                  minSize: 100,
                  startingRatio: 0.5,
                  child: models.views.views[2].builder(context, 2),
                ),
                ResizableChildData(
                  minSize: 100,
                  startingRatio: 0.5,
                  child: models.views.views[3].builder(context, 3),
                ),
              ],
            ),
          ),
        ],
      ),),
      const VerticalDivider(width: 8, color: Colors.black, thickness: 8),
      Expanded(child: ResizableContainer(
        controller: model.verticalController2,
        direction: Axis.vertical,
        dividerWidth: 8, 
        dividerColor: Colors.black,
        children: [
          ResizableChildData(
            minSize: 100,
            startingRatio: 0.5,
            child: ResizableContainer(
              controller: model.horizontalController3,
              direction: Axis.horizontal,
              dividerWidth: 8, 
              dividerColor: Colors.black,
              children: [
                ResizableChildData(
                  minSize: 100,
                  startingRatio: 0.5,
                  child: models.views.views[4].builder(context, 4),
                ),
                ResizableChildData(
                  minSize: 100,
                  startingRatio: 0.5,
                  child: models.views.views[5].builder(context, 5),
                ),
              ],
            ),
          ),
          ResizableChildData(
            minSize: 100,
            startingRatio: 0.5,
            child: ResizableContainer(
              controller: model.horizontalController4,
              direction: Axis.horizontal,
              dividerWidth: 8, 
              dividerColor: Colors.black,
              children: [
                ResizableChildData(
                  minSize: 100,
                  startingRatio: 0.5,
                  child: models.views.views[6].builder(context, 6),
                ),
                ResizableChildData(
                  minSize: 100,
                  startingRatio: 0.5,
                  child: models.views.views[7].builder(context, 7),
                ),
              ],
            ),
          ),
        ],
      ),),
    ],),
    _ => throw StateError("Too many views: ${model.views.length}"),
  };
}
