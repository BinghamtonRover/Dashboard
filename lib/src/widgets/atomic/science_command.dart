import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/widgets.dart";

/// A widget to create and send a [ScienceCommand].
class ScienceCommandEditor extends ReactiveWidget<ScienceCommandBuilder> {
  @override
  ScienceCommandBuilder createModel() => ScienceCommandBuilder();

  @override
  Widget build(BuildContext context, ScienceCommandBuilder model) => Container(  
    color: context.colorScheme.surface,
    height: 48,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(width: 8),
        Text("Status", style: context.textTheme.titleLarge),
        const SizedBox(width: 12),
        Text("Sample: ${models.rover.metrics.science.data.sample}", style: context.textTheme.titleMedium),
        const SizedBox(width: 12),
        Text("State: ${models.rover.metrics.science.data.state.humanName}", style: context.textTheme.titleMedium),
        const Spacer(),
        Text("Command", style: context.textTheme.titleLarge),
        SizedBox(width: 125, child: NumberEditor(width: 4, name: "Sample: ", model: model.sample)),
        SizedBox(child: DropdownEditor(
          name: "State: ",
          value: model.state,
          onChanged: model.updateState,
          items: const [ScienceState.STOP_COLLECTING, ScienceState.COLLECT_DATA],
          humanName: (state) => state.humanName,
        ),),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: model.isValid ? model.send : null,
          child: const Text("Send"),
        ),
        const SizedBox(width: 12),
      ],
    ),
  );
}
