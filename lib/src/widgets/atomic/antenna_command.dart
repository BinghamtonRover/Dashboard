import "package:flutter/material.dart";
import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/src/models/view/builders/antenna_command.dart";
import "package:rover_dashboard/widgets.dart";

/// A widget to edit an [AntennaCommand]
class AntennaCommandEditor extends ReusableReactiveWidget<AntennaCommandBuilder> {
  /// Const constructor for antenna command editor
  const AntennaCommandEditor(super.model);

  @override
  Widget build(BuildContext context, AntennaCommandBuilder model) => Padding(
        padding: const EdgeInsets.all(8),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 400,
          ),
          child: ListView(
            shrinkWrap: true,
            children: [
              Text(
                "Antenna Command",
                style: context.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              SwitchListTile(
                title: const Text("Override Rover Coordinates"),
                subtitle: const Text(
                  "Whether or not to manually specify which coordinates to point towards",
                ),
                value: model.overrideRoverCoordinates,
                onChanged: (value) => model.overrideRoverCoordinates = value,
              ),
              ExpansionTile(
                enabled: model.overrideRoverCoordinates,
                title: const Text("Rover Coordinates Override"),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: GpsEditor(model.roverCoordinatesOverride),
                  ),
                ],
              ),
              const Divider(),
              SwitchListTile(
                title: const Text("Override Base Station Coordinates"),
                subtitle: const Text(
                  "Whether or not to manually specify the coordinates of the base station",
                ),
                value: model.overrideBaseStationCoordinates,
                onChanged: (value) =>
                    model.overrideBaseStationCoordinates = value,
              ),
              ExpansionTile(
                enabled: model.overrideBaseStationCoordinates,
                title: const Text("Base Station Coordinates Override"),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: GpsEditor(model.baseStationCoordinatesOverride),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => model.sendCommand(),
                    child: const Text("Submit"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => model.stop(),
                    label: const Text("Stop Antenna"),
                    icon: const Icon(Icons.warning),
                    style: const ButtonStyle(
                      foregroundColor: WidgetStatePropertyAll(Colors.white),
                      backgroundColor: WidgetStatePropertyAll(Colors.red),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
