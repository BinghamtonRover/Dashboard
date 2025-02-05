import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";
import "package:rover_dashboard/widgets.dart";

/// A widget to show the gamepad state and allow the user to switch its mode.
///
/// - Clicking on the icon connects to the gamepad
/// - The icon shows the battery level/connection of the gamepad
/// - The dropdown menu allows the user to switch [OperatingMode]s
class GamepadButton extends ReusableReactiveWidget<Controller> {
	/// A const constructor for this widget.
	const GamepadButton(super.model);

	/// Returns a color representing the gamepad's battery level.
	Color getColor(GamepadBatteryLevel battery) {
		switch (battery) {
			case GamepadBatteryLevel.low: return Colors.red;
			case GamepadBatteryLevel.medium: return Colors.orange;
			case GamepadBatteryLevel.full: return Colors.green;
			case GamepadBatteryLevel.unknown: return Colors.black;
		}
	}

  /// Whether the gamepad should be disabled in this mode.
  bool isDisabled(RoverStatus status) => status == RoverStatus.AUTONOMOUS || status == RoverStatus.IDLE;

	@override
	Widget build(BuildContext context, Controller model) => ValueListenableBuilder(
    valueListenable: models.rover.status,
    builder: (context, status, _) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          padding: const EdgeInsets.all(4),
          icon: Stack(
            alignment: Alignment.topCenter,
            children: [
              const SizedBox(height: 32),
              const Icon(Icons.sports_esports), 
              Positioned(
                bottom: 0,
                right: 8,
                child: Text(
                  "${model.index + 1}",
                  style: TextStyle(
                    fontSize: 12,
                    color: context.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          color: isDisabled(status) || !model.isConnected
              ? context.colorScheme.onSurface
              : getColor(model.gamepad.batteryLevel),
          constraints: const BoxConstraints(maxWidth: 36),
          onPressed: model.connect,
        ),
        const SizedBox(width: 2.5),
        DropdownButton<OperatingMode>(
          value: model.mode,
          onChanged: isDisabled(status) ? null : model.setMode,
          items: [
            for (final mode in OperatingMode.values) DropdownMenuItem(
              value: mode,
              child: Text(mode.name),
            ),
          ],
        ),
      ],
    ),
  );
}
