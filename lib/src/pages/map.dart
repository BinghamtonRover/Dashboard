import "dart:math";
import "package:burt_network/generated.dart";
import "package:flutter/material.dart";

import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/widgets.dart";

import "map/bad_apple.dart";
import "map/header.dart";
import "map/legend.dart";

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

  /// Places a marker at the given location and closes the dialog opened by [promptForMarker].
  void placeMarker(BuildContext context, AutonomyModel model, GpsCoordinates coordinates) {
    model.placeMarker(model.markerBuilder.value);
    model.markerBuilder.clear();
    Navigator.of(context).pop();
  }

  /// Opens a dialog to prompt the user for GPS coordinates and calls [placeMarker].
  void promptForMarker(BuildContext context, AutonomyModel model) => showDialog<void>(
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
            ? () => placeMarker(context, model, model.markerBuilder.value)
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
    child: DragTarget<AutonomyCell>(
      onAcceptWithDetails: (details) => model.handleDrag(details.data, cell),
      builder: (context, candidates, rejects) => GestureDetector(
        onTap: () => model.toggleMarker(cell),
        child: Container(
          width: 24,
          decoration: BoxDecoration(
            color: getColor(cell.cellType, model),
            border: Border.all(),
          ),
          child: cell.cellType != AutonomyCell.rover ? null : LayoutBuilder(
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
        onPressed: () => promptForMarker(context, model),
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
                  child: (!model.isPlayingBadApple)
                    ? Column(
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
                    )
                    : CustomPaint(
                        painter: BadApplePainter(
                          frameNumber: model.badAppleFrame,
                          obstacles: model.data.obstacles,
                        ),
                      ),
                ),
              ),
              const SizedBox(width: 16),
              const Spacer(),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 250,
                ),
                child: AbsorbPointer(
                  absorbing: model.isPlayingBadApple,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      markerControls(context, model),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Scale:",
                            style: context.textTheme.titleLarge,
                          ),
                          Slider(
                            value: model.gridSize.clamp(1, 41).toDouble(),
                            min: 1,
                            max: 41,
                            divisions: 20,
                            label: "${model.gridSize}x${model.gridSize}",
                            onChanged: (value) => model.zoom(value.toInt()),
                          ),
                        ],
                      ),
                      AutonomyCommandEditor(model.commandBuilder, model),
                    ],
                  ),
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
