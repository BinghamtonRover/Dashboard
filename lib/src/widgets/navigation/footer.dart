import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

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
				const RoverStatus(),
				const SizedBox(width: 12),
			]
		)
	);
}

/// A few icons displaying the rover's current status.
class RoverStatus extends StatelessWidget {
	/// Provides a const constructor.
	const RoverStatus();

	/// An appropriate WiFi icon in increments of 1/5 connection strength.
	IconData getNetworkIcon(double percentage) {
		if (percentage      >= 0.9) { return Icons.signal_wifi_4_bar; }
		else if (percentage >= 0.8) { return Icons.network_wifi_outlined; }
		else if (percentage >= 0.6) { return Icons.network_wifi_3_bar; }
		else if (percentage >= 0.4) { return Icons.network_wifi_2_bar; }
		else if (percentage >= 0.2) { return Icons.network_wifi_1_bar; }
		else { return Icons.signal_wifi_0_bar_outlined; }
	}

	@override
	Widget build(BuildContext context) => Consumer<Rover>(
		builder: (_, rover, __) => Row(
			children: [
				const Icon(Icons.battery_4_bar),
				const SizedBox(width: 12),
				Icon(getNetworkIcon(rover.core.connectionStrength)),
				const SizedBox(width: 12),
				Container(  // status indicator
					width: 14, 
					decoration: BoxDecoration(
						color: rover.isConnected ? Colors.green : Colors.red,
						shape: BoxShape.circle
					)
				)
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
