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
class GamepadButton extends StatelessWidget {
	/// The controller being displayed.
	final Controller controller;

	/// A const constructor for this widget.
	const GamepadButton({
		required this.controller,
	});

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

	@override
	Widget build(BuildContext context) => ProviderConsumer<Controller>.value(
		value: controller,
		builder: (model) => Row(
      mainAxisSize: MainAxisSize.min,
			children: [
				IconButton(
					icon: Stack(
						children: [
							const Icon(Icons.sports_esports), 
							Positioned(
								bottom: -2,
								right: -2,
								child: Text("${controller.gamepadIndex + 1}", style: const TextStyle(fontSize: 12, color: Colors.white)),
							),
						],
					),
					color: model.isConnected 
						? getColor(model.gamepad.battery)
						: Colors.black,
					constraints: const BoxConstraints(maxWidth: 36),
					onPressed: controller.connect,
				),
				DropdownButton<OperatingMode>(
					iconEnabledColor: Colors.black,
					value: controller.mode,
					onChanged: controller.setMode,
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

/// An icon to indicate whether the gamepad is connected.
class GamepadButtons extends StatelessWidget {
	/// Provides a const constructor for this widget.
	const GamepadButtons();

	@override
	Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
		children: [
			GamepadButton(controller: models.rover.controller1),
			const SizedBox(width: 8),
			GamepadButton(controller: models.rover.controller2),
      const SizedBox(width: 8),
			GamepadButton(controller: models.rover.controller3),
		],
	);
}
