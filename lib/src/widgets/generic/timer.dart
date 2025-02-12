import "package:flutter/material.dart";

import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/widgets.dart";

/// A widget to view timer
/// Can also stop and start timer
class TimerWidget extends ReusableReactiveWidget<MissionTimer> {
  /// Creates a new Timer widget
  TimerWidget() : super(models.home.mission);

  /// Gets the text style for the timer.
  TextStyle getStyle(BuildContext context, MissionTimer model) => model.underMin
    ? context.textTheme.headlineSmall!.copyWith(
      color: context.colorScheme.error,
      fontWeight: FontWeight.bold,
    )
    : context.textTheme.headlineSmall!.copyWith(color: Colors.white);

	@override
	Widget build(BuildContext context, MissionTimer model) => model.title == null
    ? Container()
    : Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("${model.title}: ",
          style: context.textTheme.headlineSmall!.copyWith(color: Colors.white),
        ),
        const SizedBox(width: 4),
        AnimatedScale(
          scale: (model.underMin) && (model.timeLeft.inSeconds.isEven) ? 1.2 : 1,
          duration: const Duration(milliseconds: 750),
          child: Text(
            model.timeLeft.toString().split(".").first.padLeft(8, "0"),
            style: getStyle(context, model),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: model.isPaused ? model.resume : model.pause,
          child: model.isPaused ? const Text("Resume") : const Text("Pause"),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: model.cancel,
          child: const Text("Cancel"),
        ),
      ],
    );
}
