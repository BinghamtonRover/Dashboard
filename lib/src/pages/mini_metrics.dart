import "package:flutter/material.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/src/widgets/generic/reactive_widget.dart";
import "package:rover_dashboard/widgets.dart";

class MiniMetrics extends ReusableReactiveWidget<RoverMetrics> {
  const MiniMetrics(super.model);

  @override
  Widget build(BuildContext context, RoverMetrics model) => Row(
        children: [
          const Spacer(),
          Expanded(
            flex: 3,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              children: [
                for (int i = 0; i < 3; i++) MetricsList(model.allMetrics[i]),
              ],
            ),
          ),
          const Expanded(child: VerticalDivider()),
          Expanded(
            flex: 3,
            child: ListView(
              children: [
                for (int i = 3; i < model.allMetrics.length; i++) MetricsList(model.allMetrics[i]),
              ],
            ),
          ),
          const Spacer(),
        ],
      );
}
