import "package:flutter/material.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/widgets.dart";

/// Metrics for the Mini Dashboard
/// 
/// Displays 2 columns of expansion tiles, the left is the regular rover
/// metrics, and the right is the controls
class MiniMetrics extends ReusableReactiveWidget<RoverMetrics> {
  /// Const constructor for mini metrics
  const MiniMetrics(super.model);

  @override
  Widget build(BuildContext context, RoverMetrics model) => Row(
        children: [
          const Spacer(),
          Expanded(
            flex: 3,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              children: [
                Text(
                  "Metrics",
                  style: context.textTheme.displaySmall,
                  textAlign: TextAlign.center,
                ),
                for (final metrics in model.allMetrics) MetricsList(metrics),
              ],
            ),
          ),
          const Expanded(child: VerticalDivider()),
          Expanded(
            flex: 3,
            child: ListView(
              children: [
                Text(
                  "Controls",
                  style: context.textTheme.displaySmall,
                  textAlign: TextAlign.center,
                ),
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
          const Spacer(),
        ],
      );
}
