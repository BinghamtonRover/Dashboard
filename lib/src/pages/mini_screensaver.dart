import "dart:async";
import "dart:math";

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
        behavior: HitTestBehavior.opaque,
        onDoubleTap: () {
          Navigator.of(context)
            ..pop()
            ..pushNamed(Routes.home);
        },
        child: const SizedBox.expand(child: BouncingRoverLogo()),
      ),
    ),
  );
}

/// A widget for a moving rover logo in the style of the DVD logo
class BouncingRoverLogo extends StatefulWidget {
  /// Default constructor for bouncing rover logo
  const BouncingRoverLogo({super.key});

  @override
  State<BouncingRoverLogo> createState() => _BouncingRoverLogoState();
}

class _BouncingRoverLogoState extends State<BouncingRoverLogo> {
  static const Duration updatePeriod = Duration(milliseconds: 74);

  double x = 0;
  double y = 0;
  int dx = 0;
  int dy = 0;

  bool get hasStarted => dx != 0 && dy != 0;

  final _logoKey = GlobalKey();
  Timer? _updateTimer;

  @override
  void initState() {
    _updateTimer = Timer.periodic(updatePeriod, _update);
    super.initState();
  }

  @override
  void dispose() {
    dy = 0;
    dx = 0;
    _updateTimer?.cancel();
    super.dispose();
  }

  void _update([_]) {
    final availableSize =
        (context.findRenderObject()! as RenderBox).constraints;
    final logoSize =
        (_logoKey.currentContext!.findRenderObject()! as RenderBox).size;

    // Render layout hasn't been fully finished yet
    if (logoSize.width == 0 || logoSize.height == 0) {
      return;
    }

    if (!hasStarted) {
      final random = Random();
      x = random.nextDouble() * (availableSize.maxWidth - logoSize.width + 1);
      y = random.nextDouble() * (availableSize.maxHeight - logoSize.height + 1);

      dx = 1;
      dy = 1;
    }

    if (availableSize.maxWidth <= x + logoSize.width) {
      dx = -1;
    } else if (x < 0) {
      dx = 1;
    }
    if (availableSize.maxHeight <= y + logoSize.height) {
      dy = -1;
    } else if (y < 0) {
      dy = 1;
    }

    setState(() {
      x += dx * 15;
      y += dy * 15;
    });
  }

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      // If we haven't started yet, don't render it positioned, otherwise
      // there will be a visible jump once it generates its random start position
      if (hasStarted)
        AnimatedPositioned(
          top: y,
          left: x,
          duration: updatePeriod,
          child: Image.asset(
            key: _logoKey,
            context.colorScheme.brightness == Brightness.light
                ? "assets/logo-light.png"
                : "assets/logo-dark.png",
            height: 128,
          ),
        )
      else
        // Can't use visibility here since otherwise the underlying widget won't be
        // built, and the size will never be initialized
        Opacity(
          opacity: 0,
          child: Image.asset(
            key: _logoKey,
            context.colorScheme.brightness == Brightness.light
                ? "assets/logo-light.png"
                : "assets/logo-dark.png",
            height: 128,
          ),
        ),
    ],
  );
}
