import "dart:math";
import "package:burt_network/generated.dart";
import "package:flutter/material.dart";

import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/widgets.dart";

/// The UI for the autonomy subsystem.
///
/// Displays a bird's-eye view of the rover and its path to the goal.
class MapPage extends ReactiveWidget<AutonomyModel> {
  /// Gets the color for a given [AutonomyCell].
  Color? getColor(AutonomyCell cell, AutonomyModel model) => switch (cell) {
        AutonomyCell.destination => Colors.green,
        AutonomyCell.obstacle => Colors.black,
        AutonomyCell.path => Colors.blueGrey,
        AutonomyCell.empty => Colors.white,
        AutonomyCell.marker => Colors.red,
        AutonomyCell.rover => getColor(model.roverCellType, model),
      };

  /// Opens a dialog to prompt the user for GPS coordinates and places a marker there.
  void placeMarker(BuildContext context, AutonomyModel model) =>
      showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Add a Marker"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [GpsEditor(model.markerBuilder)],
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
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

  /// Builder for autonomy commands
  final AutonomyCommandBuilder commandBuilder = AutonomyCommandBuilder();

  /// A const constructor.
  MapPage({required this.index});

  @override
  AutonomyModel createModel() => AutonomyModel();

  /// Creates a widget to display the cell data for the provided [cell]
  Widget createCell(AutonomyModel model, MapCellData cell) => Expanded(
        child: DragTarget<AutonomyCell>(
          onAcceptWithDetails: (details) {
            switch (details.data) {
              case AutonomyCell.destination:
                {
                  commandBuilder.gps.latDecimal.value =
                      cell.coordinates.latitude;
                  commandBuilder.gps.longDecimal.value =
                      cell.coordinates.longitude;

                  commandBuilder.submit();
                  break;
                }
              case AutonomyCell.obstacle:
                {
                  final obstacleData =
                      AutonomyData(obstacles: [cell.coordinates]);
                  models.sockets.autonomy.sendMessage(obstacleData);
                  break;
                }
              case AutonomyCell.marker:
                {
                  if (model.markers.contains(cell.coordinates)) {
                    model.removeMarker(cell.coordinates);
                  } else {
                    model.placeMarker(cell.coordinates);
                  }
                  break;
                }
              // ignore: no_default_cases
              default:
                break;
            }
          },
          builder: (context, candidates, rejects) => GestureDetector(
            onTap: () {
              if (model.markers.contains(cell.coordinates)) {
                model.removeMarker(cell.coordinates);
              } else {
                model.placeMarker(cell.coordinates);
              }
            },
            child: Container(
              width: 24,
              decoration: BoxDecoration(
                color: getColor(cell.cellType, model),
                border: Border.all(),
              ),
              child: cell.cellType != AutonomyCell.rover
                  ? null
                  : LayoutBuilder(
                      builder: (context, constraints) => Container(
                        color: Colors.blue,
                        width: double.infinity,
                        height: double.infinity,
                        margin: EdgeInsets.all(constraints.maxWidth / 15),
                        child: Transform.rotate(
                          angle: -model.roverHeading * pi / 180,
                          child: Icon(
                            Icons.arrow_upward,
                            size: constraints.maxWidth * 24 / 30,
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ),
      );

  /// The controls for creating, placing, and removing markers
  Widget markerControls(BuildContext context, AutonomyModel model) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Controls
          Text("Place Marker: ", style: context.textTheme.titleLarge),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text("Add Marker"),
            onPressed: () => placeMarker(context, model),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            icon: const Icon(Icons.location_on),
            label: const Text("Drop Marker Here"),
            onPressed: model.placeMarkerOnRover,
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            icon: const Icon(Icons.clear),
            label: const Text("Clear All"),
            onPressed: model.clearMarkers,
          ),
        ],
      );

  @override
  Widget build(BuildContext context, AutonomyModel model) => LayoutBuilder(
        builder: (context, constraints) => Column(
          children: [
            MapPageHeader(model: model, index: index),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (constraints.maxWidth > 700) ...[
                    const SizedBox(width: 16),
                    const MapLegend(),
                  ],
                  const SizedBox(width: 16),
                  Flexible(
                    flex: 10,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Column(
                        children: [
                          for (final row in model.grid.reversed)
                            Expanded(
                              child: Row(
                                children: [
                                  for (final cell in row)
                                    createCell(model, cell),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Spacer(),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 250,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        markerControls(context, model),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Zoom:", style: context.textTheme.titleLarge),
                            AbsorbPointer(
                              absorbing: model.isPlayingBadApple,
                              child: Slider(
                                value: model.gridSize.clamp(1, 41).toDouble(),
                                min: 1,
                                max: 41,
                                divisions: 20,
                                label: "${model.gridSize}x${model.gridSize}",
                                onChanged: (value) => model.zoom(value.toInt()),
                              ),
                            ),
                          ],
                        ),
                        AutonomyCommandEditor(commandBuilder, model),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            ),
          ],
        ),
      );
}

/// Displays the legend for what each cell color represents on the map
class MapLegend extends StatelessWidget {
  /// Const constructor for the map legend
  const MapLegend({super.key});

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("Legend:", style: context.textTheme.titleLarge),
          Column(
            children: [
              Container(width: 24, height: 24, color: Colors.blue),
              const SizedBox(height: 2),
              Text("Rover", style: context.textTheme.titleMedium),
            ],
          ),
          Draggable<AutonomyCell>(
            data: AutonomyCell.destination,
            dragAnchorStrategy: (draggable, context, position) =>
                const Offset(12, 12),
            feedback: Container(
              width: 24,
              height: 24,
              color: Colors.green.withOpacity(0.75),
            ),
            child: Column(
              children: [
                Container(width: 24, height: 24, color: Colors.green),
                const SizedBox(height: 2),
                Text("Destination", style: context.textTheme.titleMedium),
              ],
            ),
          ),
          Draggable<AutonomyCell>(
            data: AutonomyCell.obstacle,
            dragAnchorStrategy: (draggable, context, position) =>
                const Offset(12, 12),
            feedback: Container(
              width: 24,
              height: 24,
              color: Colors.black.withOpacity(0.75),
            ),
            child: Column(
              children: [
                Container(width: 24, height: 24, color: Colors.black),
                const SizedBox(height: 2),
                Text("Obstacle", style: context.textTheme.titleMedium),
              ],
            ),
          ),
          Column(
            children: [
              Container(width: 24, height: 24, color: Colors.blueGrey),
              const SizedBox(height: 2),
              Text("Path", style: context.textTheme.titleMedium),
            ],
          ),
          Draggable<AutonomyCell>(
            data: AutonomyCell.marker,
            dragAnchorStrategy: (draggable, context, position) =>
                const Offset(12, 12),
            feedback: Container(
              width: 24,
              height: 24,
              color: Colors.red.withOpacity(0.75),
            ),
            child: Column(
              children: [
                Container(width: 24, height: 24, color: Colors.red),
                const SizedBox(height: 2),
                Text("Marker", style: context.textTheme.titleMedium),
              ],
            ),
          ),
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
                  backgroundImage:
                      const AssetImage("assets/bad_apple_thumbnail.webp"),
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
