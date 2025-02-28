import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/widgets.dart";

/// A widget to display metrics and controls off to the side.
class Sidebar extends StatelessWidget {
  /// A const constructor for this widget.
  const Sidebar();

  @override
  Widget build(BuildContext context) => Material(
    elevation: 20,
    child: Container(
      width: 310,
      color: Theme.of(context).colorScheme.surface,
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(
                  child: Text(
                    "Metrics & Controls",
                    style: TextStyle(color: context.colorScheme.onSurface),
                  ),
                ),
                Tab(
                  child: Text(
                    "Views",
                    style: TextStyle(color: context.colorScheme.onSurface),
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      children: [
                        Text(
                          "Metrics",
                          style: context.textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        for (final metrics in models.rover.metrics.allMetrics)
                          MetricsList(metrics),
                        const Divider(),
                        Text(
                          "Controls",
                          style: context.textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        ControlsDisplay(
                          controller: models.rover.controller1,
                          gamepadNum: 1,
                        ),
                        ControlsDisplay(
                          controller: models.rover.controller2,
                          gamepadNum: 2,
                        ),
                        ControlsDisplay(
                          controller: models.rover.controller3,
                          gamepadNum: 3,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ViewsCounter(),
                          TextButton.icon(
                            icon: const Icon(Icons.aspect_ratio),
                            label: const Text("Reset View Sizes"),
                            onPressed: models.views.resetSizes,
                          ),
                        ],
                      ),
                      const Expanded(child: ViewsList()),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Displays metrics of all sorts in a collapsible list.
class MetricsList extends ReusableReactiveWidget<Metrics> {
  /// A const constructor for this widget.
  const MetricsList(super.model);

  @override
  Widget build(BuildContext context, Metrics model) => Theme(
    // expansion tiles don't have much customizability
    data: Theme.of(context).copyWith(
      listTileTheme: ListTileTheme.of(context).copyWith(
        dense: true,
        minVerticalPadding: 4,
        minTileHeight: 24,
      ),
    ),
    child: ExpansionTile(
      dense: true, 
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      expandedAlignment: Alignment.centerLeft,
      childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Text(
        model.name,
        style: context.textTheme.titleLarge?.copyWith(
          color: model.overallSeverity?.color,
          fontSize: 20,
        ),
      ),
      children: [
        for (final MetricLine metric in model.allMetrics) SelectableText(
          metric.text,
          style: TextStyle(color: metric.severity?.color),
        ),
        const SizedBox(height: 4),
      ],
    ),
  );
}

/// Extension for COlors on Severity
extension SeverityUtil on Severity {
  /// Fetch the color based on the severity
  Color? get color => switch (this) {
        Severity.info => Colors.blueGrey,
        Severity.warning => Colors.orange,
        Severity.error => Colors.red,
        Severity.critical => Colors.red.shade900,
      };
}

/// Displays controls for the given [Controller].
class ControlsDisplay extends ReusableReactiveWidget<Controller> {
  /// The number gamepad being used.
  final int gamepadNum;

  /// A const constructor for this widget.
  const ControlsDisplay({
    required Controller controller,
    required this.gamepadNum,
  }) : super(controller);

  @override
  Widget build(BuildContext context, Controller model) => Theme(
    data: Theme.of(context).copyWith(
      listTileTheme: ListTileTheme.of(context).copyWith(
        minVerticalPadding: 4,
        minTileHeight: 24,
      ),
    ),
    child: ExpansionTile(
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      expandedAlignment: Alignment.centerLeft,
      childrenPadding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      title: Text(
        model.controls.mode.name,
        style: context.textTheme.titleLarge?.copyWith(
          fontSize: 20,
        ),
        textAlign: TextAlign.start,
      ),
      children: [
        for (final entry in model.controls.buttonMapping.entries) ...[
          Text(entry.key, style: context.textTheme.labelLarge),
          Text(
            "  ${entry.value}",
            style: context.textTheme.bodyMedium,
          ),
        ],
      ],
    ),
  );
}

/// A dropdown to select more or less views.
class ViewsCounter extends ReusableReactiveWidget<ViewsModel> {
	/// Provides a const constructor for this widget.
	ViewsCounter() : super(models.views);

	@override
	Widget build(BuildContext context, ViewsModel model) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Text("Views:"),
      const SizedBox(width: 4),
      DropdownButton<int>(
        value: model.views.length,
        onChanged: model.setNumViews,
        items: [
          for (final option in [1, 2, 3, 4, 8]) DropdownMenuItem(
            value: option,
            child: Center(child: Text(option.toString())),
          ),
        ],
      ),
    ],
	);
}
