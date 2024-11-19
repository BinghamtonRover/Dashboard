import "package:flutter/material.dart";

/// The color to fill in all gamepad buttons with.
const gamepadColor = Colors.blue;

/// The size of the controller image. Useful for overlaying elements on the picture.
const Size imageSize = Size(905, 568);

/// The radius for a button.
const double normalButtonRadius = 40;

/// The radius for a joystick.
const double normalJoystickRadius = 70;

/// The furthest a joystick can be off its center.
const double joystickMaxOffset = 40;

/// The width of the trigger bars.
const double normalTriggerWidth = 30;

/// The height of hte trigger bars.
const double normalTriggerHeight = 80;

/// The thickness of the trigger bars.
const double normalTriggerOutline = 10;

/// The position of the A button on the image.
const Offset buttonA = Offset(727, 230);

/// The position of the B button on the image.
const Offset buttonB = Offset(784, 173);

/// The position of the X button on the image.
const Offset buttonX = Offset(670, 173);

/// The position of the Y button on the image.
const Offset buttonY = Offset(727, 117);

/// The position of the left bumper/shoulder on the image.
const Offset leftBumper = Offset(186, 16);

/// The position of the right bumper/shoulder on the image.
const Offset rightBumper = Offset(726, 16);

/// The position of the left trigger on the image.
const Offset leftTrigger = Offset(40, 35);

/// The position of the right trigger on the image.
const Offset rightTrigger = Offset(872, 35);

/// The position of the select button on the image.
const Offset select = Offset(349, 112);

/// The position of the start button on the image.
const Offset start = Offset(558, 112);

/// The position of the up arrow button on the image.
const Offset dPadUp = Offset(180, 122);

/// The position of the down arrow button on the image.
const Offset dPadDown = Offset(180, 221);

/// The position of the left arrow button on the image.
const Offset dPadLeft = Offset(125, 175);

/// The position of the right arrow button on the image.
const Offset dPadRight = Offset(227, 175);

/// The position of the left joystick on the image.
const Offset leftStick = Offset(289, 295);

/// The position of the right joystic on the image.
const Offset rightStick = Offset(616, 295);
