import "dart:math";

import "package:flutter/material.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";
import "package:rover_dashboard/widgets.dart";

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
            child: _ControllerWidget(model.selectedController),
          ),
        ),
      ),
    ],
  );
}

/// The color to fill in all gamepad buttons with.
const gamepadColor = Colors.blue;

/// Displays data for the provided [Controller]
class _ControllerWidget extends ReusableReactiveWidget<Controller> {
  static const Size imageSize = Size(905, 568);

  static const double normalButtonRadius = 40;
  static const double normalJoystickRadius = 70;
  static const double joystickMaxOffset = 40;
  static const double normalTriggerWidth = 30;
  static const double normalTriggerHeight = 80;
  static const double normalTriggerOutline = 10;

  static const Offset buttonA = Offset(727, 230);
  static const Offset buttonB = Offset(784, 173);
  static const Offset buttonX = Offset(670, 173);
  static const Offset buttonY = Offset(727, 117);

  static const Offset leftBumper = Offset(186, 16);
  static const Offset rightBumper = Offset(726, 16);

  static const Offset leftTrigger = Offset(40, 35);
  static const Offset rightTrigger = Offset(872, 35);

  static const Offset select = Offset(349, 112);
  static const Offset start = Offset(558, 112);

  static const Offset dPadUp = Offset(180, 122);
  static const Offset dPadDown = Offset(180, 221);
  static const Offset dPadLeft = Offset(125, 175);
  static const Offset dPadRight = Offset(227, 175);

  static const Offset leftStick = Offset(289, 295);
  static const Offset rightStick = Offset(616, 295);

  /// Const constructor for Controller Widget
  const _ControllerWidget(super.model);

  double _getScaledValue(double normalValue, Size widgetSize) =>
    (_getBackgroundFitWidth(widgetSize) / imageSize.width) * normalValue;

  double _getBackgroundFitWidth(Size widgetSize) {
    var fitWidth = widgetSize.width;
    var fitHeight = widgetSize.height;

    if (imageSize.width < widgetSize.width && imageSize.height < widgetSize.height) {
      fitWidth = imageSize.width;
      fitHeight = imageSize.height;
    }

    return min(fitWidth, fitHeight / (imageSize.height / imageSize.width));
  }

  Offset _getPositionedOffset({
    required Offset offsetOnImage,
    required Size widgetSize,
    double radius = normalButtonRadius,
  }) {
    final scaleFactor = _getBackgroundFitWidth(widgetSize) / imageSize.width;
    final xFromCenter = offsetOnImage.dx - radius / 2;
    final yFromCenter = offsetOnImage.dy - radius / 2;

    return Offset(xFromCenter, yFromCenter) * scaleFactor;
  }

  // This can't be its own widget since it has to be embedded into the stack for the position to work
  Widget _controllerJoystick({
    required double x,
    required double y,
    required Offset offsetOnImage,
    required Size widgetSize,
  }) {
    final scaleFactor = _getBackgroundFitWidth(widgetSize) / imageSize.width;

    final joystickRadius = normalJoystickRadius * scaleFactor;
    final maxOffset = joystickMaxOffset * scaleFactor;

    final xFromCenter = offsetOnImage.dx - normalJoystickRadius / 2;
    final yFromCenter = offsetOnImage.dy - normalJoystickRadius / 2;

    return Positioned(
      left: xFromCenter * scaleFactor + maxOffset * x,
      top: yFromCenter * scaleFactor + maxOffset * y,
      child: Container(
        width: joystickRadius,
        height: joystickRadius,
        decoration: BoxDecoration(
          color: gamepadColor,
          borderRadius: BorderRadius.circular(10000),
        ),
      ),
    );
  }

  Widget _analogTrigger({
    required double value,
    required Size widgetSize,
  }) {
    final scaleFactor = _getBackgroundFitWidth(widgetSize) / imageSize.width;

    final triggerWidth = normalTriggerWidth * scaleFactor;
    final triggerHeight = normalTriggerHeight * scaleFactor;
    final borderWidth = normalTriggerOutline * scaleFactor;

    return Container(
      width: triggerWidth,
      height: triggerHeight,
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        border: Border.all(
          color: gamepadColor,
          width: borderWidth,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
      ),
      child: Container(
        width: triggerWidth,
        height: value * triggerHeight,
        color: gamepadColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context, Controller model) {
    final renderBox = context.findAncestorRenderObjectOfType<RenderBox>();
    final widgetSize = (renderBox == null || !renderBox.hasSize) ? imageSize : renderBox.size;
    final buttonRadius = _getScaledValue(normalButtonRadius, widgetSize);
    final outlineWidth = _getScaledValue(7.5, widgetSize);
    final state = model.gamepad.getState();

    final aOffset = _getPositionedOffset(offsetOnImage: buttonA, widgetSize: widgetSize);
    final bOffset = _getPositionedOffset(offsetOnImage: buttonB, widgetSize: widgetSize);
    final xOffset = _getPositionedOffset(offsetOnImage: buttonX, widgetSize: widgetSize);
    final yOffset = _getPositionedOffset(offsetOnImage: buttonY, widgetSize: widgetSize);
    final lbOffset = _getPositionedOffset(offsetOnImage: leftBumper, widgetSize: widgetSize);
    final rbOffset = _getPositionedOffset(offsetOnImage: rightBumper, widgetSize: widgetSize);
    final ltOffset = _getPositionedOffset(offsetOnImage: leftTrigger, widgetSize: widgetSize);
    final rtOffset = _getPositionedOffset(offsetOnImage: rightTrigger, widgetSize: widgetSize);
    final startOffset = _getPositionedOffset(offsetOnImage: start, widgetSize: widgetSize);
    final selectOffset = _getPositionedOffset(offsetOnImage: select, widgetSize: widgetSize);
    final dPadUpOffset = _getPositionedOffset(offsetOnImage: dPadUp, widgetSize: widgetSize);
    final dPadDownOffset = _getPositionedOffset(offsetOnImage: dPadDown, widgetSize: widgetSize);
    final dPadLeftOffset = _getPositionedOffset(offsetOnImage: dPadLeft, widgetSize: widgetSize);
    final dPadRightOffset = _getPositionedOffset(offsetOnImage: dPadRight, widgetSize: widgetSize);

    Widget buttonWidget({required Offset offset, bool? value}) =>  Positioned(
      left: offset.dx,
      top: offset.dy,
      child: _ControllerButton(
        value: value ?? false,
        radius: buttonRadius,
        outlineWidth: outlineWidth,
      ),
    );

    Widget triggerWidget({required Offset offset, required double? value}) => Positioned(
      left: offset.dx,
      top: offset.dy,
      child: _analogTrigger(
        value: value ?? 0,
        widgetSize: widgetSize,
      ),
    );

    return Opacity(
      opacity: model.isConnected ? 1 : 0.50,
      child: Stack(
        children: [
          Image.asset("assets/gamesir_controller.png", fit: BoxFit.contain),
          buttonWidget(offset: aOffset, value: state?.buttonA),
          buttonWidget(offset: bOffset, value: state?.buttonB),
          buttonWidget(offset: xOffset, value: state?.buttonX),
          buttonWidget(offset: yOffset, value: state?.buttonY),
          buttonWidget(offset: lbOffset, value: state?.leftShoulder),
          buttonWidget(offset: rbOffset, value: state?.rightShoulder),
          buttonWidget(offset: startOffset, value: state?.buttonStart),
          buttonWidget(offset: selectOffset, value: state?.buttonBack),
          buttonWidget(offset: dPadUpOffset, value: state?.dpadUp),
          buttonWidget(offset: dPadDownOffset, value: state?.dpadDown),
          buttonWidget(offset: dPadLeftOffset, value: state?.dpadLeft),
          buttonWidget(offset: dPadRightOffset, value: state?.dpadRight),
          triggerWidget(offset: ltOffset, value: state?.normalLeftTrigger),
          triggerWidget(offset: rtOffset, value: state?.normalRightTrigger),
          _controllerJoystick(
            x: state?.normalLeftX ?? 0,
            y: -1 * (state?.normalLeftY ?? 0),
            offsetOnImage: leftStick,
            widgetSize: widgetSize,
          ),
          _controllerJoystick(
            x: state?.normalRightX ?? 0,
            y: -1 * (state?.normalRightY ?? 0),
            offsetOnImage: rightStick,
            widgetSize: widgetSize,
          ),
        ],
      ),
    );
  }
}

class _ControllerButton extends StatelessWidget {
  final double radius;
  final double outlineWidth;
  final bool value;

  const _ControllerButton({
    required this.value,
    required this.radius,
    required this.outlineWidth,
  });

  @override
  Widget build(BuildContext context) => Container(
    width: radius,
    height: radius,
    decoration: BoxDecoration(
      color: value ? gamepadColor : Colors.transparent,
      shape: BoxShape.circle,
      border: Border.all(color: gamepadColor, width: outlineWidth),
    ),
  );
}
