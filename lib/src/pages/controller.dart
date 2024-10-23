import "dart:math";

import "package:flutter/material.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/src/widgets/generic/reactive_widget.dart";
import "package:rover_dashboard/widgets.dart";

/// The UI Page to display the controller status
class ControllersPage extends StatefulWidget {
  /// The index of this view.
  final int index;

  /// Const constructor for [ControllersPage]
  const ControllersPage({required this.index, super.key});

  @override
  State<ControllersPage> createState() => _ControllersPageState();
}

class _ControllersPageState extends State<ControllersPage> {
  Controller selectedController = models.rover.controller1;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Row(
            children: [
              const Spacer(),
              const Text("Controller: "),
              DropdownButton<Controller>(
                value: selectedController,
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
                onChanged: (Controller? value) {
                  if (value == null) {
                    return;
                  }

                  setState(() {
                    selectedController = value;
                  });
                },
              ),
              const Spacer(),
              ViewsSelector(index: widget.index),
            ],
          ),
          Expanded(
            child: Center(child: _ControllerWidget(selectedController)),
          ),
        ],
      );
}

/// Displays data for the provided [Controller]
class _ControllerWidget extends ReusableReactiveWidget<Controller> {
  static const Size imageSize = Size(905, 568);

  static const double normalButtonRadius = 40;
  static const double normalJoystickRadius = 70;
  static const double joystickMaxOffset = 40;

  static const Offset buttonA = Offset(727, 230);
  static const Offset buttonB = Offset(784, 173);
  static const Offset buttonX = Offset(670, 173);
  static const Offset buttonY = Offset(727, 117);

  static const Offset leftBumper = Offset(186, 16);
  static const Offset rightBumper = Offset(726, 16);

  static const Offset select = Offset(349, 112);
  static const Offset start = Offset(558, 112);

  static const Offset dPadUp = Offset(180, 122);
  static const Offset dPadDown = Offset(180, 221);
  static const Offset dPadLeft = Offset(125, 175);
  static const Offset dPadRight = Offset(227, 175);

  static const Offset leftStick = Offset(289, 293);
  static const Offset rightStick = Offset(616, 293);

  /// Const constructor for Controller Widget
  const _ControllerWidget(super.model);

  double _getScaledValue(double normalValue, Size widgetSize) =>
      (_getBackgroundFitWidth(widgetSize) / imageSize.width) * normalValue;

  double _getBackgroundFitWidth(Size widgetSize) {
    final fitWidth = widgetSize.width;
    final fitHeight = widgetSize.height;

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
          color: Colors.yellow,
          borderRadius: BorderRadius.circular(10000),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, Controller model) {
    final renderBox = context.findAncestorRenderObjectOfType<RenderBox>();

    final widgetSize =
        (renderBox == null || !renderBox.hasSize) ? imageSize : renderBox.size;

    final aOffset = _getPositionedOffset(
      offsetOnImage: buttonA,
      widgetSize: widgetSize,
    );
    final bOffset = _getPositionedOffset(
      offsetOnImage: buttonB,
      widgetSize: widgetSize,
    );
    final xOffset = _getPositionedOffset(
      offsetOnImage: buttonX,
      widgetSize: widgetSize,
    );
    final yOffset = _getPositionedOffset(
      offsetOnImage: buttonY,
      widgetSize: widgetSize,
    );
    final lbOffset = _getPositionedOffset(
      offsetOnImage: leftBumper,
      widgetSize: widgetSize,
    );
    final rbOffset = _getPositionedOffset(
      offsetOnImage: rightBumper,
      widgetSize: widgetSize,
    );
    final startOffset = _getPositionedOffset(
      offsetOnImage: start,
      widgetSize: widgetSize,
    );
    final selectOffset = _getPositionedOffset(
      offsetOnImage: select,
      widgetSize: widgetSize,
    );
    final dPadUpOffset = _getPositionedOffset(
      offsetOnImage: dPadUp,
      widgetSize: widgetSize,
    );
    final dPadDownOffset = _getPositionedOffset(
      offsetOnImage: dPadDown,
      widgetSize: widgetSize,
    );
    final dPadLeftOffset = _getPositionedOffset(
      offsetOnImage: dPadLeft,
      widgetSize: widgetSize,
    );
    final dPadRightOffset = _getPositionedOffset(
      offsetOnImage: dPadRight,
      widgetSize: widgetSize,
    );

    final buttonRadius = _getScaledValue(normalButtonRadius, widgetSize);

    final outlineWidth = _getScaledValue(7.5, widgetSize);

    final state = model.gamepad.getState();
    return Opacity(
      opacity: model.isConnected ? 1 : 0.50,
      child: Stack(
        children: [
          Image.asset("assets/gamesir_controller.png"),
          Positioned(
            left: aOffset.dx,
            top: aOffset.dy,
            child: _ControllerButton(
              value: state?.buttonA ?? false,
              radius: buttonRadius,
              outlineWidth: outlineWidth,
            ),
          ),
          Positioned(
            left: bOffset.dx,
            top: bOffset.dy,
            child: _ControllerButton(
              value: state?.buttonB ?? false,
              radius: buttonRadius,
              outlineWidth: outlineWidth,
            ),
          ),
          Positioned(
            left: xOffset.dx,
            top: xOffset.dy,
            child: _ControllerButton(
              value: state?.buttonX ?? false,
              radius: buttonRadius,
              outlineWidth: outlineWidth,
            ),
          ),
          Positioned(
            left: yOffset.dx,
            top: yOffset.dy,
            child: _ControllerButton(
              value: state?.buttonY ?? false,
              radius: buttonRadius,
              outlineWidth: outlineWidth,
            ),
          ),
          Positioned(
            left: lbOffset.dx,
            top: lbOffset.dy,
            child: _ControllerButton(
              value: state?.leftShoulder ?? false,
              radius: buttonRadius,
              outlineWidth: outlineWidth,
            ),
          ),
          Positioned(
            left: rbOffset.dx,
            top: rbOffset.dy,
            child: _ControllerButton(
              value: state?.rightShoulder ?? false,
              radius: buttonRadius,
              outlineWidth: outlineWidth,
            ),
          ),
          Positioned(
            left: startOffset.dx,
            top: startOffset.dy,
            child: _ControllerButton(
              value: state?.buttonStart ?? false,
              radius: buttonRadius,
              outlineWidth: outlineWidth,
            ),
          ),
          Positioned(
            left: selectOffset.dx,
            top: selectOffset.dy,
            child: _ControllerButton(
              value: state?.buttonBack ?? false,
              radius: buttonRadius,
              outlineWidth: outlineWidth,
            ),
          ),
          Positioned(
            left: dPadUpOffset.dx,
            top: dPadUpOffset.dy,
            child: _ControllerButton(
              value: state?.dpadUp ?? false,
              radius: buttonRadius,
              outlineWidth: outlineWidth,
            ),
          ),
          Positioned(
            left: dPadDownOffset.dx,
            top: dPadDownOffset.dy,
            child: _ControllerButton(
              value: state?.dpadDown ?? false,
              radius: buttonRadius,
              outlineWidth: outlineWidth,
            ),
          ),
          Positioned(
            left: dPadLeftOffset.dx,
            top: dPadLeftOffset.dy,
            child: _ControllerButton(
              value: state?.dpadLeft ?? false,
              radius: buttonRadius,
              outlineWidth: outlineWidth,
            ),
          ),
          Positioned(
            left: dPadRightOffset.dx,
            top: dPadRightOffset.dy,
            child: _ControllerButton(
              value: state?.dpadRight ?? false,
              radius: buttonRadius,
              outlineWidth: outlineWidth,
            ),
          ),
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
    super.key,
  });

  @override
  Widget build(BuildContext context) => Container(
        width: radius,
        height: radius,
        decoration: BoxDecoration(
          color: value ? Colors.yellow : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.yellow,
            width: outlineWidth,
          ),
        ),
      );
}
