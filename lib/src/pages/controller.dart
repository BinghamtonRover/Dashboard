import "package:flutter/material.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/widgets.dart";

import "controllers/controller.dart";

/// A view model to select and listen to a gamepad.
class ControllersViewModel with ChangeNotifier {
  /// The gamepad to listen to.
  Controller selectedController = models.rover.controller1;

  /// Starts listening to the gamepad.
  ControllersViewModel() {
    selectedController.addListener(notifyListeners);
  }

  @override
  void dispose() {
    selectedController.removeListener(notifyListeners);
    super.dispose();
  }

  /// Changes which controller is being listened to.
  void setController(Controller? value) {
    if (value == null) return;
    selectedController.removeListener(notifyListeners);
    selectedController = value;
    selectedController.addListener(notifyListeners);
    notifyListeners();
  }
}

/// The UI Page to display the controller status
class ControllersPage extends ReactiveWidget<ControllersViewModel> {
  /// The index of this view.
  final int index;

  /// Const constructor for [ControllersPage]
  const ControllersPage({required this.index, super.key});

  @override
  ControllersViewModel createModel() => ControllersViewModel();

  @override
  Widget build(BuildContext context, ControllersViewModel model) => Column(
    children: [
      const SizedBox(height: 16),
      Row(
        children: [
          const Spacer(),
          const Text("Controller: "),
          DropdownButton<Controller>(
            value: model.selectedController,
            onChanged: model.setController,
            items: [
              DropdownMenuItem(
                value: models.rover.controller1,
                child: const Text("Controller 1"),
              ),
              DropdownMenuItem(
                value: models.rover.controller2,
                child: const Text("Controller 2"),
              ),
              DropdownMenuItem(
                value: models.rover.controller3,
                child: const Text("Controller 3"),
              ),
            ],
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: model.selectedController.isConnected
              ? model.selectedController.gamepad.pulse : null,
            child: const Text("Vibrate"),
          ),
          const Spacer(),
          ViewsSelector(index: index),
        ],
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: ControllerWidget(model.selectedController),
          ),
        ),
      ),
    ],
  );
}
