import "package:flutter/material.dart";
import "package:flutter_resizable_container/flutter_resizable_container.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/pages.dart";
import "package:rover_dashboard/widgets.dart";

/// A widget to render all the views the user selected.
class ViewsWidget extends ReusableReactiveWidget<ViewsModel> {
  /// A const constructor.
  ViewsWidget() : super(models.views);

  @override
  Widget build(BuildContext context, ViewsModel model) {
    final childData = List<ResizableChild>.generate(
      (model.views.length > 1) ? model.views.length : 0,
      (index) => ResizableChild(
        minSize: 100,
        child: _ViewArea(model: model, index: index),
      ),
    );

    return switch (model.views.length) {
      1 => Column(
          children: [
            Expanded(child: _ViewArea(model: model, index: 0)),
          ],
        ),
      2 => ResizableContainer(
          direction: switch (models.settings.dashboard.splitMode) {
            SplitMode.horizontal => Axis.vertical,
            SplitMode.vertical => Axis.horizontal,
          },
          divider: const ResizableDivider(thickness: 8, color: Colors.black),
          controller: switch (models.settings.dashboard.splitMode) {
            SplitMode.horizontal => model.verticalController,
            SplitMode.vertical => model.horizontalController1,
          },
          children: childData.sublist(0, 2),
        ),
      3 || 4 => ResizableContainer(
          controller: model.verticalController,
          direction: Axis.vertical,
          divider: const ResizableDivider(thickness: 8, color: Colors.black),
          children: [
            ResizableChild(
              minSize: 100,
              child: ResizableContainer(
                controller: model.horizontalController1,
                divider: const ResizableDivider(thickness: 8, color: Colors.black),
                direction: Axis.horizontal,
                children: childData.sublist(0, 2),
              ),
            ),
            if (model.views.length == 3)
              childData[2]
            else
              ResizableChild(
                minSize: 100,
                child: ResizableContainer(
                  controller: model.horizontalController2,
                  direction: Axis.horizontal,
                  divider: const ResizableDivider(thickness: 8, color: Colors.black),
                  children: childData.sublist(2, 4),
                ),
              ),
          ],
        ),
      8 => Row(
          children: [
            Expanded(
              child: ResizableContainer(
                controller: model.verticalController,
                direction: Axis.vertical,
                divider: const ResizableDivider(thickness: 8, color: Colors.black),
                children: [
                  ResizableChild(
                    minSize: 100,
                    child: ResizableContainer(
                      controller: model.horizontalController1,
                      direction: Axis.horizontal,
                      divider: const ResizableDivider(thickness: 8, color: Colors.black),
                      children: childData.sublist(0, 2),
                    ),
                  ),
                  ResizableChild(
                    minSize: 100,
                    child: ResizableContainer(
                      controller: model.horizontalController2,
                      direction: Axis.horizontal,
                      divider: const ResizableDivider(thickness: 8, color: Colors.black),
                      children: childData.sublist(2, 4),
                    ),
                  ),
                ],
              ),
            ),
            const VerticalDivider(
              width: 8,
              color: Colors.black,
              thickness: 8,
            ),
            Expanded(
              child: ResizableContainer(
                controller: model.verticalController2,
                direction: Axis.vertical,
                divider: const ResizableDivider(thickness: 8, color: Colors.black),
                children: [
                  ResizableChild(
                    minSize: 100,
                    child: ResizableContainer(
                      controller: model.horizontalController3,
                      direction: Axis.horizontal,
                      divider: const ResizableDivider(thickness: 8, color: Colors.black),
                      children: childData.sublist(4, 6),
                    ),
                  ),
                  ResizableChild(
                    minSize: 100,
                    child: ResizableContainer(
                      controller: model.horizontalController4,
                      direction: Axis.horizontal,
                      divider: const ResizableDivider(thickness: 8, color: Colors.black),
                      children: childData.sublist(6, 8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      _ => throw StateError("Too many views: ${model.views.length}"),
    };
  }
}

class _ViewArea extends StatelessWidget {
  /// The views model
  final ViewsModel model;

  /// The view index of the area
  final int index;

  const _ViewArea({
    required this.model,
    required this.index,
  });

  @override
  Widget build(BuildContext context) => DragTarget<DashboardView>(
        onWillAcceptWithDetails: (details) =>
            details.data.name != model.views[index].name,
        onAcceptWithDetails: (details) {
          model.replaceView(index, details.data);
        },
        builder: (context, candidateData, rejectedData) =>
            model.views[index].builder(context, index),
      );
}
