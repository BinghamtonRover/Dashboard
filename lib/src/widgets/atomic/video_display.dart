import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// A video stream based on a [CameraFeed].
class VideoDisplay extends StatefulWidget {
	/// The video feed to display.
	final CameraFeed? feed;

	/// A callback to run when the user selects a new feed.
	final ValueChanged<CameraFeed> onChanged;

	/// Displays a video stream.
	const VideoDisplay({
		required this.feed,
		required this.onChanged
	});

	@override
	VideoDisplayState createState() => VideoDisplayState();
}

/// The state for the video display.
/// 
/// Responsible for updating each frame of the video.
class VideoDisplayState extends State<VideoDisplay> {
	/// The backend for getting videos.
	VideoModel get model => models.video;

	@override
	Widget build(BuildContext context) => Stack(
		children: [
			if (widget.feed != null) Container(  // TODO: Implement video player
				color: Colors.blueGrey, 
				margin: const EdgeInsets.all(1),
				child: Center(child: Text(widget.feed!.name)),
			) else Container(
				color: Colors.blueGrey,
				margin: const EdgeInsets.all(1),
				child: const Center(child: Text("Select a feed")),
			),
			Positioned(
				top: 4, 
				right: 4, 
				child: PopupMenuButton<CameraFeed>(
					icon: const Icon(Icons.more_horiz),
					onSelected: widget.onChanged,
					itemBuilder: (_) => [
						for (final CameraFeed otherFeed in VideoModel.allFeeds) PopupMenuItem(
							value: otherFeed,
							child: Text(otherFeed.name),
						),
					]
				)
			)
		],
	);
}
