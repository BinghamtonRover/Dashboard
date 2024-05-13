import "dart:async";

import "package:flutter/material.dart";
import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/widgets.dart";

/// Drive controls for mobile devices where gamepads aren't feasible.
class MobileControlsModel with ChangeNotifier {
  /// The speed of the left wheels.
  double left = 0;
  /// The speed of the right wheels.
  double right = 0;

  late Timer _timer;

  /// Starts sending messages to the rover.
  MobileControlsModel() {
    _timer = Timer.periodic(const Duration(milliseconds: 10), _sendSpeeds);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _sendSpeeds(_) {
    final command1 = DriveCommand(setLeft: true, left: left);
    final command2 = DriveCommand(setRight: true, right: -1 * right);
    models.messages.sendMessage(command1);
    models.messages.sendMessage(command2);
  }

  /// Updates the left speed.
  void updateLeft(double value) {
    left = value;
    notifyListeners();
  }

  /// Updates the right speed.
  void updateRight(double value) {
    right = value;
    notifyListeners();
  }
}

/// Drive controls for mobile devices where gamepads aren't feasible.
class MobileControls extends ReactiveWidget<MobileControlsModel> {
  @override
  MobileControlsModel createModel() => MobileControlsModel();

  @override
  Widget build(BuildContext context, MobileControlsModel model) => Row(
    children: [
      const SizedBox(width: 24),
      RotatedBox(
        quarterTurns: 3,
        child: SliderTheme(
          data: const SliderThemeData(
            trackHeight: 48,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 36),
          ),
          child: Slider(
            onChanged: model.updateLeft,
            onChangeEnd: (_) => model.updateLeft(0),
            value: model.left,
            min: -1,
            label: model.left.toString(),
          ),
        ),
      ),
      const Spacer(),
      RotatedBox(
        quarterTurns: 3,
        child: SliderTheme(
          data: const SliderThemeData(
            trackHeight: 48,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 36),
          ),
          child: Slider(
            onChanged: model.updateRight,
            onChangeEnd: (_) => model.updateRight(0),
            value: model.right,
            min: -1,
            label: model.right.toString(),
          ),
        ),
      ),
      const SizedBox(width: 24),
    ],
  );
}
