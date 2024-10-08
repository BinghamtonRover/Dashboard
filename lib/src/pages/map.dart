import "dart:math";
import "package:flutter/material.dart";

import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/widgets.dart";

/// The UI for the autonomy subsystem.
/// 
/// Displays a bird's-eye view of the rover and its path to the goal.
class MapPage extends ReactiveWidget<AutonomyModel> {
	/// Gets the color for a given [AutonomyCell].
	Color? getColor(AutonomyCell cell) => switch(cell) {
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
        children: [ GpsEditor(model.markerBuilder) ],
      ),
      actions: [
        TextButton(child: const Text("Cancel"), onPressed: () => Navigator.of(context).pop()),
        ElevatedButton(
          onPressed: model.markerBuilder.isValid ? () { model.placeMarker(); Navigator.of(context).pop(); } : null,
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

	@override
	Widget build(BuildContext context, AutonomyModel model) => Stack(children: [
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      const SizedBox(height: 48),
      for (final row in model.grid.reversed) Expanded(
        child: Row(children: [
          for (final cell in row) Expanded(
            child: GestureDetector(
              onTap: () => cell.$2 != AutonomyCell.marker ? () : model.updateMarker(cell.$1),
              child: Container(
                width: 24,
                decoration: BoxDecoration(color: getColor(cell.$2), border: Border.all()),
                child: cell.$2 != AutonomyCell.rover ? null : Container(
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
          ),
        ],),
      ),
      const SizedBox(height: 4),
      if (!model.isPlayingBadApple) Row(children: [  // Legend
        const SizedBox(width: 4),
        Text("Legend:", style: context.textTheme.titleLarge),
        const SizedBox(width: 8),
        Container(width: 24, height: 24, color: Colors.blue),
        const SizedBox(width: 4),
        Text("Rover", style: context.textTheme.titleMedium),
        const SizedBox(width: 24),
        Container(width: 24, height: 24, color: Colors.green),
        const SizedBox(width: 4),
        Text("Destination", style: context.textTheme.titleMedium),
        const SizedBox(width: 24),
        Container(width: 24, height: 24, color: Colors.black),
        const SizedBox(width: 4),
        Text("Obstacle", style: context.textTheme.titleMedium),
        const SizedBox(width: 24),
        Container(width: 24, height: 24, color: Colors.blueGrey),
        const SizedBox(width: 4),
        Text("Path", style: context.textTheme.titleMedium),
        const SizedBox(width: 24),
        Container(width: 24, height: 24, color: Colors.red),
        const SizedBox(width: 4),
        Text("Marker", style: context.textTheme.titleMedium),
        const Spacer(),
        Text("Zoom: ", style: context.textTheme.titleLarge),
        Expanded(flex: 2, child: Slider(
          value: model.gridSize.toDouble(),
          min: 1,
          max: 41,
          divisions: 20,
          label: "${model.gridSize}x${model.gridSize}",
          onChanged: (value) => model.zoom(value.toInt()),
        ),),
      ],),
      if (!model.isPlayingBadApple) Row(children: [  // Controls
        const SizedBox(width: 4),
        Text("Place marker: ", style: context.textTheme.titleLarge),
        const SizedBox(width: 8),
        ElevatedButton.icon(
          icon: const Icon(Icons.add), 
          label: const Text("Add Marker"), 
          onPressed: () => placeMarker(context, model),
        ),
        const SizedBox(width: 8),
        ElevatedButton.icon(
          icon: const Icon(Icons.location_on), 
          label: const Text("Drop marker here"), 
          onPressed: model.placeMarkerOnRover,
        ),
        const SizedBox(width: 8),
        ElevatedButton.icon(icon: const Icon(Icons.clear), label: const Text("Clear all"), onPressed: model.clearMarkers),
        const Spacer(),
      ],),
      const SizedBox(height: 8),
      AutonomyCommandEditor(model),
      const VerticalDivider(),
      const SizedBox(height: 4),
    ],),
    Container(
      color: context.colorScheme.surface, 
      height: 50, 
      child: Row(children: [  // The header at the top
        const SizedBox(width: 8),
        Text("Map", style: context.textTheme.headlineMedium), 
        if (models.settings.easterEggs.badApple) IconButton(
          iconSize: 48,
            icon: CircleAvatar(
            backgroundImage: const AssetImage("assets/bad_apple_thumbnail.webp"),
            child: model.isPlayingBadApple ? const Icon(Icons.block, color: Colors.red, size: 36) : null,
          ),
          onPressed: model.isPlayingBadApple ? model.stopBadApple : model.startBadApple,
        ),
        const Spacer(),
        ViewsSelector(index: index),
      ],),
    ),
  ],);
}
