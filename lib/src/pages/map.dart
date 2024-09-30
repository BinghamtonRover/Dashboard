import "dart:math";
import "package:flutter/material.dart";

import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/widgets.dart";

/// The UI for the autonomy subsystem.
///
/// Displays a bird's-eye view of the rover and its path to the goal.
class MapPage extends ReactiveWidget<AutonomyModel> {
  /// Gets the color for a given [AutonomyCell].
  Color? getColor(AutonomyCell cell) => switch (cell) {
        AutonomyCell.destination => Colors.green,
        AutonomyCell.obstacle => Colors.black,
        AutonomyCell.path => Colors.blueGrey,
        AutonomyCell.empty => Colors.white,
        AutonomyCell.marker => Colors.red,
        AutonomyCell.rover => Colors.transparent,
      };

  /// Opens a dialog to prompt the user for GPS coordinates and places a marker there.
  void placeMarker(BuildContext context, AutonomyModel model) => showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Add a Marker"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [GpsEditor(model.markerBuilder)],
          ),
          actions: [
            TextButton(child: const Text("Cancel"), onPressed: () => Navigator.of(context).pop()),
            ElevatedButton(
              onPressed: model.markerBuilder.isValid
                  ? () {
                      model.placeMarker(model.markerBuilder.value);
                      model.markerBuilder.clear();
                      Navigator.of(context).pop();
                    }
                  : null,
              child: const Text("Add"),
            ),
          ],
        ),
      );

  /// The index of this view.
  final int index;

  /// A const constructor.
  const MapPage({required this.index});

  @override
  AutonomyModel createModel() => AutonomyModel();

  /// Creates a widget to display the cell data for the provided [cell]
  Widget createCell(AutonomyModel model, MapCellData cell) => Expanded(
        child: GestureDetector(
          onTap: () {
            if (cell.cellType == AutonomyCell.marker) {
              model.removeMarker(cell.coordinates);
            } else if (cell.cellType == AutonomyCell.empty) {
              model.placeMarker(cell.coordinates);
            }
          },
          child: Container(
            width: 24,
            decoration: BoxDecoration(color: getColor(cell.cellType), border: Border.all()),
            child: cell.cellType != AutonomyCell.rover
                ? null
                : Container(
                    color: Colors.blue,
                    width: double.infinity,
                    height: double.infinity,
                    margin: const EdgeInsets.all(4),
                    child: Transform.rotate(
                      angle: -model.roverHeading * pi / 180,
                      child: const Icon(Icons.arrow_upward, size: 24),
                    ),
                  ),
          ),
        ),
      );

  /// The controls for creating, placing, and removing markers
  Widget markerControls(BuildContext context, AutonomyModel model) => Row(
        children: [
          // Controls
          const SizedBox(width: 4),
          Text("Place Marker: ", style: context.textTheme.titleLarge),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text("Add Marker"),
            onPressed: () => placeMarker(context, model),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            icon: const Icon(Icons.location_on),
            label: const Text("Drop Marker Here"),
            onPressed: model.placeMarkerOnRover,
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            icon: const Icon(Icons.clear),
            label: const Text("Clear All"),
            onPressed: model.clearMarkers,
          ),
          const Spacer(),
          Text("Zoom: ", style: context.textTheme.titleLarge),
          Expanded(
            flex: 2,
            child: Slider(
              value: model.gridSize.toDouble(),
              min: 1,
              max: 41,
              divisions: 20,
              label: "${model.gridSize}x${model.gridSize}",
              onChanged: (value) => model.zoom(value.toInt()),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context, AutonomyModel model) => Column(
        children: [
          MapPageHeader(model: model, index: index),
          const SizedBox(height: 24),
          Expanded(
            child: Row(
              children: [
                if (!model.isPlayingBadApple) ...[
                  const SizedBox(width: 16),
                  const MapLegend(),
                  const SizedBox(width: 16),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final row in model.grid.reversed)
                        Expanded(
                          child: Row(
                            children: [
                              for (final cell in row) createCell(model, cell),
                            ],
                          ),
                        ),
                      if (!model.isPlayingBadApple) markerControls(context, model),
                      const SizedBox(height: 4),
                      AutonomyCommandEditor(model),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ],
      );
}

/// Displays the legend for what each cell color represents on the map
class MapLegend extends StatelessWidget {
  /// Const constructor for the map legend
  const MapLegend({super.key});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          const SizedBox(height: 4),
          Text("Legend:", style: context.textTheme.titleLarge),
          const SizedBox(height: 8),
          Container(width: 24, height: 24, color: Colors.blue),
          const SizedBox(height: 4),
          Text("Rover", style: context.textTheme.titleMedium),
          const SizedBox(height: 24),
          Container(width: 24, height: 24, color: Colors.green),
          const SizedBox(height: 4),
          Text("Destination", style: context.textTheme.titleMedium),
          const SizedBox(height: 24),
          Container(width: 24, height: 24, color: Colors.black),
          const SizedBox(height: 4),
          Text("Obstacle", style: context.textTheme.titleMedium),
          const SizedBox(height: 24),
          Container(width: 24, height: 24, color: Colors.blueGrey),
          const SizedBox(height: 4),
          Text("Path", style: context.textTheme.titleMedium),
          const SizedBox(height: 24),
          Container(width: 24, height: 24, color: Colors.red),
          const SizedBox(height: 4),
          Text("Marker", style: context.textTheme.titleMedium),
        ],
      );
}

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
            // The header at the top
            const SizedBox(width: 8),
            Text("Map", style: context.textTheme.headlineMedium),
            if (models.settings.easterEggs.badApple)
              IconButton(
                iconSize: 48,
                icon: CircleAvatar(
                  backgroundImage: const AssetImage("assets/bad_apple_thumbnail.webp"),
                  child: model.isPlayingBadApple ? const Icon(Icons.block, color: Colors.red, size: 36) : null,
                ),
                onPressed: model.isPlayingBadApple ? model.stopBadApple : model.startBadApple,
              ),
            const Spacer(),
            ViewsSelector(index: index),
          ],
        ),
      );
}
