import "package:flutter/material.dart";

/// Represents a button that is pressed or not.
class ControllerButton extends StatelessWidget {
  /// The radius with which to draw this button.
  final double radius;

  /// How thick the border should be.
  final double borderWidth;

  /// Whether the button is pressed or not.
  final bool isPressed;

  /// The color of the button.
  final Color color;

  /// Draws a small circle to represent a button that can be pressed.
  const ControllerButton({
    required this.isPressed,
    required this.radius,
    required this.borderWidth,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Container(
    width: radius,
    height: radius,
    decoration: BoxDecoration(
      color: isPressed ? color : null,
      shape: BoxShape.circle,
      border: Border.all(color: color, width: borderWidth),
    ),
  );
}
