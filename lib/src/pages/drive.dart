import "package:fl_chart/fl_chart.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/pages.dart";
import "package:rover_dashboard/widgets.dart";

/// The science analysis page.
class DrivePage extends ReactiveWidget<PositionModel> {
  @override
  PositionModel createModel() => PositionModel();
  

  /* 
  - a front-on view of the rover. The rover can tilt, representing roll
  - a profile view of the rover. The rover can tilt, representing pitch
  - some data representing how the wheels are doing. Useful for determining traction
  - two sliders, showing what each side of the rover is doing (slider from [-1, +1]
  - a button to spin all the wheels slowly and ramp up to ~50% throttle (adjustable). Good to test the hardware
  */

  @override
	Widget build(BuildContext context, PositionModel model) => Column(
    children: [
      const Text("hello"),
      Text(model.metrics.angle.toString()),
    ],

  );

}
