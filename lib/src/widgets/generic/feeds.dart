import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/widgets.dart";

/// A view to contain all the video feeds for a given page. 
/// 
/// Each [CameraFeed] is represented by a [VideoDisplay] widget.
class VideoFeeds extends StatelessWidget {
	/// Creates a grid of video feeds.
	const VideoFeeds();

	@override
	Widget build(BuildContext context) => Consumer<VideoModel>(  // update on new layout
		builder: (context, model, _) => Column(
		children: [
			Expanded(child: Row(
				children: [
					if (model.feeds.isNotEmpty) Expanded(child: VideoDisplay(
						feed: model.feeds[0],
						onChanged: (feed) => models.video.selectNewFeed(0, feed),
					)),
					if (model.feeds.length >= 2) Expanded(child: VideoDisplay(
						feed: model.feeds[1],
						onChanged: (feed) => models.video.selectNewFeed(1, feed),
					)),
				],
			)),
			if (model.feeds.length > 2) Expanded(child: Row(
				children: [
					if (model.feeds.length >= 3) Expanded(child: VideoDisplay(
						feed: model.feeds[2],
						onChanged: (feed) => models.video.selectNewFeed(2, feed),
					)),
					if (model.feeds.length >= 4) Expanded(child: VideoDisplay(
						feed: model.feeds[3],
						onChanged: (feed) => models.video.selectNewFeed(3, feed),
					)),
				],
			)),
		]
	));
}
