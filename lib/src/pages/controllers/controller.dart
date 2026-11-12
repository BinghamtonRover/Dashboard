import "package:flutter/material.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";
import "package:rover_dashboard/widgets.dart";

import "button.dart";
import "constants.dart";

/// Displays controller inputs over an image of the controller.
class ControllerWidget extends ReusableReactiveWidget<Controller> {
  /// Const constructor for Controller Widget
  const ControllerWidget(super.model);


  // Positions and sizes use the original image's pixel coordinates.
  // FittedBox scales the image and all indicators together

  // Moves a joystick marker based on its X and Y input.
Widget _controllerJoystick({
  required double x,
  required double y,
  required Offset offsetOnImage,
  required bool? isPressed,
}) => Positioned(

  // Center the marker, then add movement from the joystick input
  // normalJoystickRadius stores the diameter despite its name

  left:
      offsetOnImage.dx -
      normalJoystickRadius / 2 +
      joystickMaxOffset * x,
  top:
      offsetOnImage.dy -
      normalJoystickRadius / 2 +
      joystickMaxOffset * y,
  child: Container(
    width: normalJoystickRadius,
    height: normalJoystickRadius,
    decoration: BoxDecoration(
      color: (isPressed ?? false) ? gamepadColor : null,
      shape: BoxShape.circle,
    ),
  ),
);


// Draws a button indicator that fills when pressed
Widget _buttonWidget({
  required Offset offset,
  bool? value,
}) => Positioned(

  // Convert the center coordinate to the circle's top-left corner
  // normalButtonRadius stores the diameter despite its name
  left: offset.dx - normalButtonRadius / 2,
  top: offset.dy - normalButtonRadius / 2,
  child: ControllerButton(
    isPressed: value ?? false,
    radius: normalButtonRadius,
    borderWidth: normalButtonOutline,
    color: gamepadColor,
  ),
);

/// Draws a meter that fills upward as the trigger is pressed
Widget _triggerWidget({
  required Offset offset,
  required double? value,
}) {

    // Keep the fill between empty (0) and full (1)
  final amount = (value ?? 0.0).clamp(0.0, 1.0).toDouble();

  return Positioned(
    // Center the rectangular meter around its assigned coordinate
    left: offset.dx - normalTriggerWidth / 2,
    top: offset.dy - normalTriggerHeight / 2,
    child: Container(
      width: normalTriggerWidth,
      height: normalTriggerHeight,
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        border: Border.all(
          color: gamepadColor,
          width: normalTriggerOutline,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
      ),
      child: Container(
        width: normalTriggerWidth,
        height: amount * normalTriggerHeight,
        color: gamepadColor,
      ),
    ),
  );
}

  /// Builds the controller image and its input indicators
Widget _buildGamepad(Controller model) {
  final state = model.gamepad.getState();

  return Opacity(


    // Dims the controller when it is disconnected. Cool Right?
    opacity: model.isConnected ? 1 : 0.50,

    // Resize everything together to keep the indicators aligned
    child: FittedBox(
      fit: BoxFit.contain,
      alignment: Alignment.center,

      // Match the canvas to the image dimensions used by the coordinates
      child: SizedBox(
        width: imageSize.width,
        height: imageSize.height,
        child: Stack(
          // Make the background image occupy the full canvas
          fit: StackFit.expand,
          children: [
            Image.asset(controllerImageAsset, fit: BoxFit.contain),
            
            // Face buttons
            _buttonWidget(
              offset: buttonA,
              value: state?.buttonA,
            ),
            _buttonWidget(
              offset: buttonB,
              value: state?.buttonB,
            ),
            _buttonWidget(
              offset: buttonX,
              value: state?.buttonX,
            ),
            _buttonWidget(
              offset: buttonY,
              value: state?.buttonY,
            ),

            _buttonWidget(
              offset: leftBumper,
              value: state?.leftShoulder,
            ),
            _buttonWidget(
              offset: rightBumper,
              value: state?.rightShoulder,
            ),

            // Start (+) and Select (-)
            _buttonWidget(
              offset: start,
              value: state?.buttonStart,
            ),
            _buttonWidget(
              offset: select,
              value: state?.buttonBack,
            ),

            // D-pad directions
            _buttonWidget(
              offset: dPadUp,
              value: state?.dpadUp,
            ),
            _buttonWidget(
              offset: dPadDown,
              value: state?.dpadDown,
            ),
            _buttonWidget(
              offset: dPadLeft,
              value: state?.dpadLeft,
            ),
            _buttonWidget(
              offset: dPadRight,
              value: state?.dpadRight,
            ),

            // Trigger meters show how far each trigger is pressed
            _triggerWidget(
              offset: leftTrigger,
              value: state?.normalLeftTrigger,
            ),
            _triggerWidget(
              offset: rightTrigger,
              value: state?.normalRightTrigger,
            ),

            // Missing joystick input defaults to the center
            // Invert Y for screen coordinates, which increase downward
            _controllerJoystick(
              x: state?.normalLeftX ?? 0,
              y: -1 * (state?.normalLeftY ?? 0),
              offsetOnImage: leftStick,
              isPressed: true, // Keep the marker visible.
            ),
            _controllerJoystick(
              x: state?.normalRightX ?? 0,
              y: -1 * (state?.normalRightY ?? 0),
              offsetOnImage: rightStick,
              isPressed: true, // Keep the marker visible.
            ),
          ],
        ),
      ),
    ),
  );
}

// FittedBox handles scaling, so no manual size calculation is needed
@override
Widget build(BuildContext context, Controller model) =>
    _buildGamepad(model);
}
