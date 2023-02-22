import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";

/// The footer, responsible for showing vitals and logs. 
class Footer extends StatelessWidget {
	@override
	Widget build(BuildContext context) => Container(
		height: 48,
		color: Theme.of(context).colorScheme.secondary,
		child: Row(
			mainAxisAlignment: MainAxisAlignment.end,
			children: [
				const MessageDisplay(),
				const Spacer(),
				VideoFeedCounter(),
				const SerialButton(),
				const GamepadIcon(),
				const SizedBox(width: 4),
				const StatusIcons(),
				const SizedBox(width: 12),
			]
		)
	);
}

/// An icon to indicate whether the gamepad is connected.
class GamepadIcon extends StatelessWidget {
	/// Provides a const constructor for this widget.
	const GamepadIcon();

	@override
	Widget build(BuildContext context) => Consumer<Rover>(
		builder: (_, model, __) => IconButton(
			icon: const Icon(Icons.sports_esports), 
			color: services.gamepad.isConnected ? Colors.green : Colors.black,
			onPressed: services.gamepad.isConnected
				? services.gamepad.vibrate
				: services.gamepad.connect,
		),
	);
}

/// A few icons displaying the rover's current status.
class StatusIcons extends StatelessWidget {
	/// Provides a const constructor.
	const StatusIcons();

	/// An appropriate WiFi icon in increments of 1/5 connection strength.
	IconData getNetworkIcon(double percentage) {
		if (percentage      >= 0.8) { return Icons.signal_wifi_statusbar_4_bar; }
		else if (percentage >= 0.6) { return Icons.network_wifi_3_bar; }
		else if (percentage >= 0.4) { return Icons.network_wifi_2_bar; }
		else if (percentage >= 0.2) { return Icons.network_wifi_1_bar; }
		else { return Icons.signal_wifi_0_bar; }
	}

	/// An appropriate battery icon in increments of 1/8 battery level.
	IconData getBatteryIcon(double percentage) {
		if (percentage >= 0.84) { return Icons.battery_full; }  // 80-100
		else if (percentage >= 0.72) { return Icons.battery_6_bar; }  // 60-80
		else if (percentage >= 0.60) { return Icons.battery_5_bar; }  // 60-80
		else if (percentage >= 0.48) { return Icons.battery_4_bar; }  // 60-80
		else if (percentage >= 0.36) { return Icons.battery_3_bar; }  // 60-80
		else if (percentage >= 0.24) { return Icons.battery_2_bar; }  // 40-60
		else if (percentage >= 0.12) { return Icons.battery_1_bar; }  // 20-40
		else { return Icons.battery_0_bar; }  // 0-20
	}

	/// An appropriate battery icon representing the rover's current status.
	IconData getStatusIcon(RoverStatus status) {
		switch (status) {
			case RoverStatus.disconnected: return Icons.power_off;
			case RoverStatus.standby: return Icons.pause_circle;
			case RoverStatus.active: return Icons.play_circle;
		}
	}

	/// A color representing a meter's fill.
	Color getColor(double percentage) {
		if (percentage > 0.75) { return Colors.green; }
		else if (percentage > 0.5) { return Colors.yellow; }
		else if (percentage > 0.25) { return Colors.orange; }
		else if (percentage > 0.0) { return Colors.red; }
		else { return Colors.black; }
	}

	/// The color of the rover's status icon.
	Color getStatusColor(RoverStatus status) {
		switch(status) {
			case RoverStatus.disconnected: return Colors.black;
			case RoverStatus.standby: return Colors.orange;
			case RoverStatus.active: return Colors.green;
		}
	}

	@override
	Widget build(BuildContext context) => Consumer<Rover>(
		builder: (_, rover, __) => Row(
			children: [
				Icon(
					rover.isConnected 
						? getBatteryIcon(rover.metrics.electrical.battery)
						: Icons.battery_unknown,
					color: getColor(rover.metrics.electrical.battery)
				),
				const SizedBox(width: 4),
				Icon(
					rover.isConnected
						? getNetworkIcon(rover.core.connectionStrength)
						: Icons.signal_wifi_off_outlined,
					color: getColor(rover.core.connectionStrength),
				),
				const SizedBox(width: 8),
				Icon(
					rover.isConnected
						? getStatusIcon(rover.status)
						: Icons.power_off,
					color: getStatusColor(rover.status),
				),
				const SizedBox(width: 4),
			]
		),	
	);
}

/// A dropdown to select more or less video feeds.
class VideoFeedCounter extends StatelessWidget {
	@override
	Widget build(BuildContext context) => Consumer<VideoModel>(
		builder: (context, video, _) => Consumer<HomeModel>(
			builder: (context, home, _) => Row(
				children: [
					const Text("Feeds:"),
					const SizedBox(width: 4),
					DropdownButton<int>(
						value: video.userLayout[home.mode]!.length,
						onChanged: (value) => video.setNumFeeds(value),
						items: [
							for (int i = 1; i <= 4; i++) DropdownMenuItem(
								value: i,
								child: Center(child: Text(i.toString())),
							)
						]
					)
				]
			)
		)
	);
}

/// Allows the user to connect to the firmware directly, over Serial.
/// 
/// See [SerialModel] for an implementation.
class SerialButton extends StatelessWidget {
	/// Provides a const constructor.
	const SerialButton();

	@override
	Widget build(BuildContext context) => Consumer<SerialModel>(
		builder: (_, model, __) => model.isConnected 
			? IconButton(
				icon: const Icon(Icons.usb, color: Colors.green),
				onPressed: model.disconnect,
			)
			: PopupMenuButton(
				icon: const Icon(Icons.usb),
				onSelected: model.connect,
				itemBuilder: (_) => [
					for (final String device in model.availableDevices)
						PopupMenuItem(
							value: device,
							child: Text(device),
						)
				],
		)
	);
} 

/// Displays the latest [TaskbarMessage] from [HomeModel.message].
class MessageDisplay extends StatelessWidget {
	/// Provides a const constructor for this widget.
	const MessageDisplay();

	/// Gets the appropriate icon for the given severity.
	IconData getIcon(Severity severity) {
		switch (severity) {
			case Severity.info: return Icons.info;
			case Severity.warning: return Icons.warning;
			case Severity.error: return Icons.error;
			case Severity.critical: return Icons.dangerous;
		}
	}	

	/// Gets the appropriate color for the given severity.
	Color getColor(Severity severity) {
		switch (severity) {
			case Severity.info: return Colors.transparent;
			case Severity.warning: return Colors.yellow;
			case Severity.error: return Colors.orange;
			case Severity.critical: return Colors.red;
		}
	}

	@override
	Widget build(BuildContext context) => Consumer<HomeModel>(
		builder: (_, model, __) => model.message == null 
			? Container()
			: Container(
				height: double.infinity,
				padding: const EdgeInsets.all(2),
				margin: const EdgeInsets.all(2),
				color: getColor(model.message!.severity),
				child: Row(
					children: [
						Icon(getIcon(model.message!.severity)),
						Text(model.message!.text),
				]
			)
		)
	);
}
