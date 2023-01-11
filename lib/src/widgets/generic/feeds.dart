import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/widgets.dart";

/// A view to contain all the video feeds for a given page. 
/// 
/// Each [CameraFeed] is represented by a [VideoDisplay] widget.
class VideoFeeds extends StatelessWidget {
	/// The list of feeds to display.
	final List<CameraFeed> feeds;

	/// Displays all the relevant video feeds on the page. 
	const VideoFeeds(this.feeds);

	@override
	Widget build(BuildContext context) => feeds.isEmpty 
		? const Text("Select a camera feed below") : feeds.length > 4 
		? const Text("Select less than four camera feeds") : Column(
		children: [
			Expanded(child: Row(
				children: [
					if (feeds.isNotEmpty) VideoDisplay(feeds[0]),
					if (feeds.length >= 2) VideoDisplay(feeds[1]),
				],
			)),
			Expanded(child: Row(
				children: [
					if (feeds.length >= 3) VideoDisplay(feeds[2]),
					if (feeds.length >= 4) VideoDisplay(feeds[3]),
				],
			)),
		]
	);
}
