import "package:flutter/material.dart";
import "package:rover_dashboard/pages.dart";
import "package:rover_dashboard/widgets.dart";

/// A screensaver for the mini dashboard
///
/// Displays a large BURT logo that will dismiss itself when double tapped
class MiniScreenSaver extends StatelessWidget {
  /// Const constructor for mini screensaver
  const MiniScreenSaver({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor:
        context.colorScheme.brightness == Brightness.dark ? Colors.black : null,
    body: Center(
      child: GestureDetector(
        onDoubleTap: () {
          Navigator.of(context)
            ..pop()
            ..pushNamed(Routes.home);
        },
        child: Image.asset(
          context.colorScheme.brightness == Brightness.light
              ? "assets/logo-light.png"
              : "assets/logo-dark.png",
        ),
      ),
    ),
  );
}
