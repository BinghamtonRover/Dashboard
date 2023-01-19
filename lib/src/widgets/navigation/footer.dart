import "package:flutter/material.dart";
import "package:provider/provider.dart";

// import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// The footer, responsible for showing vitals and logs. 
class Footer extends StatelessWidget {
	/// Whether there is a controller currently connected. 
	static const bool isControllerConnected = true;

	@override
	Widget build(BuildContext context) => Container(
		height: 48,
		color: Colors.blue,
		child: Row(
			mainAxisAlignment: MainAxisAlignment.end,
			children: [
				VideoFeedCounter(),
				const Icon(Icons.battery_4_bar),
				const SizedBox(width: 12),
				const Icon(Icons.network_wifi_3_bar),
				const SizedBox(width: 12),
				Container(width: 14, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle)),	
				const SizedBox(width: 12),
			]
		)
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
					DropdownButton<int>(
						value: video.userLayout[home.mode]!.length,
						onChanged: (value) => video.setNumFeeds(value),
						items: [
							for (int i = 1; i <= 4; i++) DropdownMenuItem(
								value: i,
								child: Text(i.toString()),
							)
						]
					)
				]
			)
		)
	);
}
