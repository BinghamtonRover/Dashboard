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
          width: 300,
          color: Theme.of(context).colorScheme.surface,
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                TabBar(
                  tabs: [
                    Tab(child: Text("Metrics & Controls", style: TextStyle(color: context.colorScheme.onSurface)),),
                    Tab(child: Text("Views", style: TextStyle(color: context.colorScheme.onSurface))),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        children: [
                          Text(
                            "Metrics",
                            style: context.textTheme.displaySmall,
                            textAlign: TextAlign.center,
                          ),
                          for (final metrics in models.rover.metrics.allMetrics)
                            MetricsList(metrics),
                          const Divider(),
                          Text(
                            "Controls",
                            style: context.textTheme.displaySmall,
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
                      ViewsList(),
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
  Widget build(BuildContext context, Metrics model) => ExpansionTile(
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        expandedAlignment: Alignment.centerLeft,
        childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
        title: Text(
          model.name,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: model.overallSeverity?.color,
              ),
        ),
        children: [
          for (final MetricLine metric in model.allMetrics)
            Text(
              metric.text,
              style: TextStyle(
                color: metric.severity?.color,
              ),
            ),
          const SizedBox(height: 4),
        ],
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
  Widget build(BuildContext context, Controller model) => ExpansionTile(
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        expandedAlignment: Alignment.centerLeft,
        childrenPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          model.controls.mode.name,
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.start,
        ),
        children: [
          for (final entry in model.controls.buttonMapping.entries) ...[
            Text(entry.key, style: Theme.of(context).textTheme.labelLarge),
            Text(
              "  ${entry.value}",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ],
      );
}
