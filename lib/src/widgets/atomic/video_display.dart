import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";

/// A video stream based on a [CameraFeed].
class VideoDisplay extends StatelessWidget {
	/// The feed to display.
	final CameraFeed feed;

	/// Displays a video stream.
	const VideoDisplay(this.feed);

	@override
	Widget build(BuildContext context) => Container(color: Colors.blueGrey, child: Center(child: Text(feed.name)));
}
