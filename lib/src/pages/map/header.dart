
import "package:flutter/material.dart";

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

  @override
  Widget build(BuildContext context) => Container(
    color: context.colorScheme.surface,
    height: 50,
    child: Row(
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
        const Spacer(),
        ViewsSelector(index: index),
      ],
    ),
  );
}
