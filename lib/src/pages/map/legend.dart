
import "package:flutter/material.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/widgets.dart";

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
