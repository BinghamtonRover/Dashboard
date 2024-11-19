import "dart:math";

import "package:flutter/material.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";
import "package:rover_dashboard/widgets.dart";

import "button.dart";
import "constants.dart";

/// A widget that shows all button presses and analog inputs overlaid on an image of a controller.
class ControllerWidget extends ReusableReactiveWidget<Controller> {
  /// Const constructor for Controller Widget
  const ControllerWidget(super.model);

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
    // TODO(Levi-Lesches): Support thumbstick presses, https://github.com/Levi-Lesches/sdl_gamepad/issues/1
    required bool? isPressed,
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
          color: (isPressed ?? false) ? gamepadColor : null,
          borderRadius: BorderRadius.circular(10000),
        ),
      ),
    );
  }

  Widget _buttonWidget({
    required Offset offset,
    required double buttonRadius,
    required double outlineWidth,
    bool? value,
  }) => Positioned(
    left: offset.dx,
    top: offset.dy,
    child: ControllerButton(
      isPressed: value ?? false,
      radius: buttonRadius,
      borderWidth: outlineWidth,
      color: gamepadColor,
    ),
  );

  Widget _triggerWidget({
    required Offset offset,
    required double? value,
    required Size size,
  }) {
    final scaleFactor = _getBackgroundFitWidth(size) / imageSize.width;
    final triggerWidth = normalTriggerWidth * scaleFactor;
    final triggerHeight = normalTriggerHeight * scaleFactor;
    final borderWidth = normalTriggerOutline * scaleFactor;
    return Positioned(
      left: offset.dx,
      top: offset.dy,
      child: Container(
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
          height: (value ?? 0) * triggerHeight,
          color: gamepadColor,
        ),
      ),
    );
  }

  Widget _buildGamepad(BuildContext context, Size widgetSize, Controller model) {
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

    return Opacity(
      opacity: model.isConnected ? 1 : 0.50,
      child: Stack(
        children: [
          Image.asset("assets/gamesir_controller.png", fit: BoxFit.contain),
          _buttonWidget(buttonRadius: buttonRadius, outlineWidth: outlineWidth, offset: aOffset, value: state?.buttonA),
          _buttonWidget(buttonRadius: buttonRadius, outlineWidth: outlineWidth, offset: bOffset, value: state?.buttonB),
          _buttonWidget(buttonRadius: buttonRadius, outlineWidth: outlineWidth, offset: xOffset, value: state?.buttonX),
          _buttonWidget(buttonRadius: buttonRadius, outlineWidth: outlineWidth, offset: yOffset, value: state?.buttonY),
          _buttonWidget(buttonRadius: buttonRadius, outlineWidth: outlineWidth, offset: lbOffset, value: state?.leftShoulder),
          _buttonWidget(buttonRadius: buttonRadius, outlineWidth: outlineWidth, offset: rbOffset, value: state?.rightShoulder),
          _buttonWidget(buttonRadius: buttonRadius, outlineWidth: outlineWidth, offset: startOffset, value: state?.buttonStart),
          _buttonWidget(buttonRadius: buttonRadius, outlineWidth: outlineWidth, offset: selectOffset, value: state?.buttonBack),
          _buttonWidget(buttonRadius: buttonRadius, outlineWidth: outlineWidth, offset: dPadUpOffset, value: state?.dpadUp),
          _buttonWidget(buttonRadius: buttonRadius, outlineWidth: outlineWidth, offset: dPadDownOffset, value: state?.dpadDown),
          _buttonWidget(buttonRadius: buttonRadius, outlineWidth: outlineWidth, offset: dPadLeftOffset, value: state?.dpadLeft),
          _buttonWidget(buttonRadius: buttonRadius, outlineWidth: outlineWidth, offset: dPadRightOffset, value: state?.dpadRight),
          _triggerWidget(size: widgetSize, offset: ltOffset, value: state?.normalLeftTrigger),
          _triggerWidget(size: widgetSize, offset: rtOffset, value: state?.normalRightTrigger),
          _controllerJoystick(
            x: state?.normalLeftX ?? 0,
            y: -1 * (state?.normalLeftY ?? 0),
            offsetOnImage: leftStick,
            widgetSize: widgetSize,
            isPressed: true,
          ),
          _controllerJoystick(
            x: state?.normalRightX ?? 0,
            y: -1 * (state?.normalRightY ?? 0),
            offsetOnImage: rightStick,
            widgetSize: widgetSize,
            isPressed: true,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, Controller model) => LayoutBuilder(
    builder: (context, constraints) => _buildGamepad(context, constraints.biggest, model),
  );
}
