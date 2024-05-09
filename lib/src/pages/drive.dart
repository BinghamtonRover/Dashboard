import "package:fl_chart/fl_chart.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:protobuf/protobuf.dart";

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
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Row(children: [  // The header at the top
        const SizedBox(width: 8),
        Text("Drive", style: context.textTheme.headlineMedium), 
        const Spacer(),
        const ViewsSelector(currentView: Routes.drive),
      ],),
      Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Column(children: [
                const Text("Front View of the Rover"),
                Transform.rotate(
                  angle: model.metrics.roll,
                  child: const Text("VIEW OF THE ROVER"),
                ),
              ],),
            ),
            Expanded(
              child: Column(children: [
                const Text("Side View of the Rover"),
                Transform.rotate(
                  angle: model.metrics.pitch,
                  child: const Text("VIEW OF THE ROVER"),
                ),
              ],),
            ),
          ],
        ),
      ),
      const Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(child: Text("6 rectangles for each wheel showing their rpm -- find the odd one out"),),
            Expanded(child: Text("Sliders for each side of wheels"),),
          ],
        ),
      ),
    ],
  );
      
}




/*
const Column(
    children: [
      Row(children: [
        Expanded(child: Text("Top Left")),
        Expanded(child: Text("Top Rght")),
      ],),
      Row(children: [
        Expanded(child: Text("Bottom Left")),
        Expanded(child: Text("Bottom Rght")),
      ],)
    ],

  );
  */