import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/widgets.dart";

/// A view to contain all the video feeds for a given page using [VideoFeed] widgets.
class VideoFeeds extends StatelessWidget {
	/// Creates a grid of video feeds.
	const VideoFeeds();

	@override
	Widget build(BuildContext context) => Consumer<VideoModel>(  // update on new layout
		builder: (context, model, _) => Column(
		children: [
			Expanded(child: Row(
				children: [
					if (model.feedsOnScreen.isNotEmpty) Expanded(child: VideoFeed(index: 0, name: model.feedsOnScreen[0])),
					if (model.feedsOnScreen.length >= 3) Expanded(child: VideoFeed(index: 1, name: model.feedsOnScreen[1])),
				]
			)),
			if (model.feedsOnScreen.length > 1) Expanded(child: Row(
				children: [
					if (model.feedsOnScreen.length >= 2) Expanded(child: model.feedsOnScreen.length >= 3
						? VideoFeed(index: 2, name: model.feedsOnScreen[2])
						: VideoFeed(index: 1, name: model.feedsOnScreen[1])
					),
					if (model.feedsOnScreen.length >= 4) Expanded(child: VideoFeed(index: 3, name: model.feedsOnScreen[3])),
				],
			)),
		]
	));
}
