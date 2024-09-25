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
			case GamepadBatteryLevel.empty: return Colors.red;
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
          icon: Stack(
            children: [
              const SizedBox(height: 32),
              Icon(Icons.sports_esports, color: context.colorScheme.onSurface), 
              Positioned(
                bottom: 0,
                right: 4.5,
                child: Text(
                  "${model.gamepadIndex + 1}",
                  style: TextStyle(
                    fontSize: 12,
                    color: context.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          color: isDisabled(status) ? Colors.grey : model.isConnected 
            ? getColor(model.gamepad.battery)
            : Colors.black,
          constraints: const BoxConstraints(maxWidth: 36),
          onPressed: model.connect,
        ),
        DropdownButton<OperatingMode>(
          iconEnabledColor: Colors.black,
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
