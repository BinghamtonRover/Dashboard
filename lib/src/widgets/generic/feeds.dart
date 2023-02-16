import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/widgets.dart";

/// A view to contain all the video feeds for a given page. 
/// 
/// Each [CameraFeed] is represented by a [VideoFeed] widget.
class VideoFeeds extends StatelessWidget {
	/// Creates a grid of video feeds.
	const VideoFeeds();

	@override
	Widget build(BuildContext context) => Consumer<VideoModel>(  // update on new layout
		builder: (context, model, _) => Column(
		children: [
			Expanded(child: Row(
				children: [
					if (model.feeds.isNotEmpty) Expanded(child: VideoFeed(model.feeds[0])),
					if (model.feeds.length >= 2) Expanded(child: VideoFeed(model.feeds[1])),
				]
			)),
			if (model.feeds.length > 2) Expanded(child: Row(
				children: [
					if (model.feeds.length >= 3) Expanded(child: VideoFeed(model.feeds[2])),
					if (model.feeds.length >= 4) Expanded(child: VideoFeed(model.feeds[3])),
				],
			)),
		]
	));
}
