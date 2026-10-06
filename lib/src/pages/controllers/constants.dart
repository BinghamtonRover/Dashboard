import "package:flutter/material.dart";

/// Background image used by the controller widget.
const String controllerImageAsset =
    "assets/8bitdo-ultimate-2c-wireless-controller.png";

/// Button border thickness in source-image pixels.
/// FittedBox scales this border along with the rest of the controller.
const double normalButtonOutline = 7.5;

/// The color to fill in all gamepad buttons with.
const gamepadColor = Colors.blue;

/// The size of the controller image. Useful for overlaying elements on the picture.
const Size imageSize = Size(1131, 785);

/// The DIAMETER for a button. (Ignore Radius name))
const double normalButtonRadius = 40;

/// The DIAMETER for a joystick. (Ignore Radius name)
const double normalJoystickRadius = 70;

/// The furthest a joystick can be off its center.
const double joystickMaxOffset = 40;

/// The width of the trigger bars.
const double normalTriggerWidth = 30;

/// The height of hte trigger bars.
const double normalTriggerHeight = 80;

/// The thickness of the trigger bars.
const double normalTriggerOutline = 10;

// Every offset below represents an indicator's CENTER, measured from
// the top-left corner of the full controller PNG.
// Each widget helper subtracts half its own dimensions because
// Flutter's Positioned expects a top-left corner.


/// The position of the A button on the image.
const Offset buttonA = Offset(889, 302);

/// The position of the B button on the image.
const Offset buttonB = Offset(969, 222);

/// The position of the X button on the image.
const Offset buttonX = Offset(809, 222);

/// The position of the Y button on the image.
const Offset buttonY = Offset(889, 142);

/// The position of the left bumper/shoulder on the image.
const Offset leftBumper = Offset(240, 40);

/// The position of the right bumper/shoulder on the image.
const Offset rightBumper = Offset(891, 40);

/// The position of the left trigger on the image.
const Offset leftTrigger = Offset(40, 55);

/// The position of the right trigger on the image.
const Offset rightTrigger = Offset(1091, 55);

/// The position of the select button on the image.
const Offset select = Offset(420, 126);

/// The position of the start button on the image.
const Offset start = Offset(713, 126);

/// The position of the up arrow button on the image.
const Offset dPadUp = Offset(412, 345);

/// The position of the down arrow button on the image.
const Offset dPadDown = Offset(412, 461);

/// The position of the left arrow button on the image.
const Offset dPadLeft = Offset(350, 402);

/// The position of the right arrow button on the image.
const Offset dPadRight = Offset(472, 402);

/// The position of the left joystick on the image.
const Offset leftStick = Offset(240, 222);

/// The position of the right joystic on the image.
const Offset rightStick = Offset(718, 402);
