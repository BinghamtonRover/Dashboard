import "dart:math";
import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/pages.dart";
import "package:rover_dashboard/src/models/view/electrical.dart";
import "package:rover_dashboard/widgets.dart";

/// The UI for the electrical subsystem.
/// 
/// Displays a bird's-eye view of the rover and its path to the goal.
class ElectricalPage extends ReactiveWidget<ElectricalModel> {
  @override
  ElectricalModel createModel() => ElectricalModel();

	@override
	Widget build(BuildContext context, ElectricalModel model) => Column(
    children: [
      const SizedBox(
        child: Text("YO PUSSY"),
      ),
      SizedBox(
        child: Text(model.metrics.allMetrics.first),
      )
    ],
  );
}
