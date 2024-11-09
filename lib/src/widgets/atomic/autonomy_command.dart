import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/widgets.dart";

/// A widget to edit an [AutonomyCommand].
class AutonomyCommandEditor extends ReusableReactiveWidget<AutonomyCommandBuilder> {
  /// The autonomy view model.
  final AutonomyModel dataModel;
  /// A const constructor.
  const AutonomyCommandEditor(super.model, this.dataModel);

  /// Opens a dialog to prompt the user to create an [AutonomyCommand] and sends it to the rover.
  void createTask(BuildContext context, AutonomyCommandBuilder command) => showDialog<void>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Create a new Task"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownEditor<AutonomyTask>(
            name: "Task type",
            value: command.task,
            items: [
              for (final task in AutonomyTask.values)
                if (task != AutonomyTask.AUTONOMY_TASK_UNDEFINED) task,
            ],
            onChanged: command.updateTask,
            humanName: (task) => task.humanName,
          ),
          GpsEditor(command.gps),
        ],
      ),
      actions: [
        TextButton(child: const Text("Cancel"), onPressed: () => Navigator.of(context).pop()),
        ElevatedButton(
          onPressed: command.isLoading ? null : () { command.submit(); Navigator.of(context).pop(); },
          child: const Text("Submit"),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context, AutonomyCommandBuilder model) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Autonomy:", style: context.textTheme.titleLarge),
          Text(
            "${dataModel.data.state.humanName}, ${dataModel.data.task.humanName}",
            style: context.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text("New Task"),
            onPressed: () {
              if (RoverStatus.AUTONOMOUS == models.rover.status.value) {
                createTask(context, model);
              } else {
                models.home.setMessage(
                  severity: Severity.error,
                  text: "You must be in autonomy mode to do that",
                );
              }
            },
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.red),
            ),
            onPressed: model.abort,
            child: const Text("ABORT"),
          ),
        ],
      );
}
