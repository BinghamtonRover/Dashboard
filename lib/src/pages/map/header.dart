
import "package:flutter/material.dart";
import "package:rover_dashboard/data.dart";

import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/widgets.dart";

/// The header to appear at the top of the map page, displays a button to play bad apple...
class MapPageHeader extends StatelessWidget {
  /// The model to control the status of bad apple...
  final AutonomyModel model;

  /// Index of the view the header is in
  final int index;

  /// Const constructor for the map page header
  const MapPageHeader({required this.index, required this.model, super.key});

  /// The icon for the status of RTK
  Widget rtkStateIcon(BuildContext context) {
    final rtkMode = model.roverPosition.rtkMode;

    final icon = switch (rtkMode) {
      RTKMode.RTK_FIXED => Icons.signal_wifi_4_bar,
      RTKMode.RTK_FLOAT => Icons.network_wifi_2_bar,
      _ => Icons.signal_wifi_off_outlined,
    };

    return Tooltip(
      message: models.rover.metrics.position.getRTKString(rtkMode),
      waitDuration: const Duration(milliseconds: 500),
      child: Icon(
        icon,
        color: context.colorScheme.onSurface,
        size: 28,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 50,
    child: PageHeader(
      pageIndex: index,
      children: [
        const SizedBox(width: 8),
        Text("Map", style: context.textTheme.headlineMedium),
        if (models.settings.easterEggs.badApple) IconButton(
          iconSize: 48,
          icon: CircleAvatar(
            backgroundImage: const AssetImage("assets/bad_apple_thumbnail.webp"),
            child: model.isPlayingBadApple
              ? const Icon(Icons.block, color: Colors.red, size: 36)
              : null,
          ),
          onPressed: model.isPlayingBadApple
            ? model.stopBadApple
            : model.startBadApple,
        ),
        const SizedBox(width: 5),
        Row(
          children: [
            const Text("RTK Status: "),
            rtkStateIcon(context),
          ],
        ),
        const Spacer(),
        // ViewsSelector(index: index),
      ],
    ),
  );
}
