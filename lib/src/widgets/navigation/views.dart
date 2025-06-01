import "package:flutter/material.dart";
import "package:flutter_resizable_container/flutter_resizable_container.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/pages.dart";
import "package:rover_dashboard/widgets.dart";

class _ViewArea extends StatelessWidget {
  /// The views model
  final ViewsModel model;

  /// The view index of the area
  final int index;

  const _ViewArea({required this.model, required this.index});

  @override
  Widget build(BuildContext context) => DragTarget<DashboardView>(
    onWillAcceptWithDetails: (details) =>
        details.data.name != model.views[index].name,
    onAcceptWithDetails: (details) => model.replaceView(index, details.data),
    builder: (context, candidateData, rejectedData) => Container(
      decoration: BoxDecoration(
        boxShadow: const [BoxShadow(offset: Offset(2, 2), blurRadius: 10.5)],
        borderRadius: BorderRadius.circular(15),
        color: context.colorScheme.surface,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: model.views[index].builder(context, index),
      ),
    ),
  );
}

extension on ViewsModel {
  List<ResizableChild> get children => [
    for (var i = 0; i < views.length; i++)
      ResizableChild(
        minSize: 100,
        child: _ViewArea(model: this, index: i),
      ),
  ];
}

/// A widget to render all the views the user selected.
class ViewsWidget extends ReusableReactiveWidget<ViewsModel> {
  /// A thick divider between each view.
  static const divider = ResizableDivider(
    thickness: 12,
    color: Colors.transparent,
  );

  /// A const constructor.
  ViewsWidget() : super(models.views);

  /// Returns a [ResizableChild]s with the given children.
  ResizableChild nestChild({
    required ResizableController controller,
    required List<ResizableChild> children,
    required Axis axis,
  }) => ResizableChild(
    minSize: 100,
    child: ResizableContainer(
      controller: controller,
      divider: divider,
      direction: axis,
      children: children,
    ),
  );

  @override
  Widget build(BuildContext context, ViewsModel model) => Padding(
    padding: const EdgeInsets.all(8),
    child: switch (model.views.length) {
      1 => Column(children: [Expanded(child: model.children[0].child)]),
      2 => ResizableContainer(
        key: ValueKey("1-${models.settings.dashboard.splitMode.name}"),
        direction: switch (models.settings.dashboard.splitMode) {
          SplitMode.horizontal => Axis.vertical,
          SplitMode.vertical => Axis.horizontal,
        },
        divider: divider,
        controller: switch (models.settings.dashboard.splitMode) {
          SplitMode.horizontal => model.verticalController1,
          SplitMode.vertical => model.horizontalController1,
        },
        children: model.children.sublist(0, 2),
      ),
      3 || 4 => ResizableContainer(
        key: const ValueKey(2),
        controller: model.verticalController1,
        direction: Axis.vertical,
        divider: divider,
        children: [
          nestChild(
            controller: model.horizontalController1,
            children: model.children.sublist(0, 2),
            axis: Axis.horizontal,
          ),
          if (model.views.length == 3)
            model.children[2]
          else
            nestChild(
              controller: model.horizontalController2,
              children: model.children.sublist(2, 4),
              axis: Axis.horizontal,
            ),
        ],
      ),
      8 => Row(
        children: [
          Expanded(
            // left page
            child: ResizableContainer(
              key: const ValueKey(3),
              controller: model.verticalController1,
              direction: Axis.vertical,
              divider: divider,
              children: [
                nestChild(
                  // top row
                  controller: model.horizontalController1,
                  axis: Axis.horizontal,
                  children: model.children.sublist(0, 2),
                ),
                nestChild(
                  // bottom row
                  controller: model.horizontalController2,
                  axis: Axis.horizontal,
                  children: model.children.sublist(2, 4),
                ),
              ],
            ),
          ),
          const VerticalDivider(
            width: 12,
            color: Colors.transparent,
            thickness: 0,
          ),
          Expanded(
            // right page
            child: ResizableContainer(
              key: const ValueKey(4),
              controller: model.verticalController2,
              direction: Axis.vertical,
              divider: divider,
              children: [
                nestChild(
                  // top row
                  controller: model.horizontalController3,
                  axis: Axis.horizontal,
                  children: model.children.sublist(4, 6),
                ),
                nestChild(
                  // bottom row
                  controller: model.horizontalController4,
                  axis: Axis.horizontal,
                  children: model.children.sublist(6, 8),
                ),
              ],
            ),
          ),
        ],
      ),
      _ => throw StateError("Too many views: ${model.views.length}"),
    },
  );
}
