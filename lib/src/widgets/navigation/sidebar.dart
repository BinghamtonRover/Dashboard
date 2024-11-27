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
                      GamepadsControlsDisplay(
                        controller: models.rover.controller1,
                        gamepadNum: 1,
                      ),
                      GamepadsControlsDisplay(
                        controller: models.rover.controller2,
                        gamepadNum: 2,
                      ),
                      GamepadsControlsDisplay(
                        controller: models.rover.controller3,
                        gamepadNum: 3,
                      ),
                      KeyboardControlsDisplay(),
                    ],
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
  Widget build(BuildContext context, Metrics model) => ExpansionTile(
    expandedCrossAxisAlignment: CrossAxisAlignment.start,
    expandedAlignment: Alignment.centerLeft,
    childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
    title: Text(
      model.name,
      style: Theme.of(context).textTheme.headlineSmall
        ?.copyWith(color: model.overallSeverity?.color),
    ),
    children: [
      for (final MetricLine metric in model.allMetrics) Text(
        metric.text,
        style: TextStyle(color: metric.severity?.color),
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

/// Shows a list of controls for an input.
class ControlsDisplayBase extends StatelessWidget {
  /// The controls and the buttons mapped to them.
  final Map<String, String> controls;

  /// The name of these controls.
  final String name;

  /// A widget to show a list of control.
  const ControlsDisplayBase({
    required this.controls,
    required this.name,
  });

  @override
  Widget build(BuildContext context) => ExpansionTile(
    expandedCrossAxisAlignment: CrossAxisAlignment.start,
    expandedAlignment: Alignment.centerLeft,
    childrenPadding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 8,
    ),
    title: Text(
      name,
      style: Theme.of(context).textTheme.titleLarge,
      textAlign: TextAlign.start,
    ),
    children: [
      for (final entry in controls.entries) ...[
        Text(entry.key, style: Theme.of(context).textTheme.labelLarge),
        Text(
          "  ${entry.value}",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    ],
  );
}

/// Displays controls for the given [Controller].
class GamepadsControlsDisplay extends ReusableReactiveWidget<Controller> {
  /// The number gamepad being used.
  final int gamepadNum;

  /// A const constructor for this widget.
  const GamepadsControlsDisplay({
    required Controller controller,
    required this.gamepadNum,
  }) : super(controller);

  @override
  Widget build(BuildContext context, Controller model) => ControlsDisplayBase(
    name: "$gamepadNum. ${model.controls.mode.name}",
    controls: model.controls.buttonMapping,
  );
}

/// Displays controls for the [KeyboardController].
///
/// This needs to be reactive since the [KeyboardController.buttonMapping] will change
/// depending on whether it is enabled.
class KeyboardControlsDisplay extends ReusableReactiveWidget<KeyboardController> {
  /// Starts listening to the [KeyboardController].
  KeyboardControlsDisplay() : super(models.rover.keyboardController);

  @override
  Widget build(BuildContext context, KeyboardController model) =>
    ControlsDisplayBase(controls: model.buttonMapping, name: "Keyboard controls");
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
