import "dart:async";
import "dart:math" as math;
import "dart:typed_data";
import "dart:ui" as ui;
import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// Displays frames of a [CameraFeed].
class Feed extends StatefulWidget {
	/// The feed to show in this widget.
	/// 
	/// May be changed by the user. See [VideoFeedState.feed] for the actual value.
	final CameraFeed cameraFeed;

	/// Need to be able to do this with UI Autonomy as well
	final AutonomyModel? autonomy = null;


	/// Displays a [CameraFeed] on the screen.
	const Feed(this.cameraFeed);

	@override
	FeedState createState() => FeedState();
}

/// The logic for updating for updating a [VideoFeed].
/// 
/// This widget listens to [VideoModel.frameUpdater] to sync its framerate with other [VideoFeed]s.
/// On every update, this widget grabs the frame from [CameraFeed.frame], decodes it, renders it, 
/// then replaces the old frame. The key is that all the image processing logic is done off-screen
/// while the old frame remains on-screen. That way, the user sees one continuous video instead
/// of a flickering image.
class FeedState extends State<Feed> {
	/// The feed being streamed.
	Feed feed;

	@override
	void initState() {
		super.initState();
		//feed = widget.feed;
	}

	@override
	void dispose() {
		super.dispose();
	}

	@override
	Widget build(BuildContext context) => Stack(
		children: [
			Container(
				color: Colors.blueGrey, 
				height: double.infinity,
				width: double.infinity,
				margin: const EdgeInsets.all(1),
				alignment: Alignment.center,
				child: const Text("Placeholder"),
			),
			Row(
				mainAxisAlignment: MainAxisAlignment.end,
				children: [
					PopupMenuButton<Feed>(
						tooltip: "Select a feed",
						icon: const Icon(Icons.more_horiz),
						onSelected: selectNewFeed,
						itemBuilder: (_) => [
							for (final other in VideoModel.allFeeds) PopupMenuItem(
								value: other,
								child: Text(other.name),
							),
						]
					),
					PopupMenuButton<AutonomyModel>(
						tooltip: "Select a feed",
						icon: const Text("UI"), //Icon(Icons.more_horiz),
						//onSelected: ,
						itemBuilder: (_) => [
							for (final other in VideoModel.uiFeeds) PopupMenuItem(
								value: other,
								child: Text(other.name),
							),
						]
					),
				]
			),
			Positioned(left: 5, bottom: 5,
				child: Text(feed.name),
			),
		]
	);

	/// Switches this widget to a new [CameraFeed].
	Future<void> selectNewFeed(Feed newFeed) async {
		await models.video.disableFeed(feed);
		await models.video.enableFeed(newFeed);
		setState(() => feed = newFeed);
	}
}
