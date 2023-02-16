import "dart:typed_data";
import "dart:ui" as ui;
import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

class VideoFeed extends StatefulWidget {
	final CameraFeed initialFeed;
	const VideoFeed(this.initialFeed);

	@override
	VideoFeedState createState() => VideoFeedState();
}

class VideoFeedState extends State<VideoFeed> {
	late CameraFeed feed;
	ui.Image? image;

	bool get hasFrame => feed.frame != null;

	@override
	void initState() {
		super.initState();
		feed = widget.initialFeed;
		models.video.addListener(updateImage);
	}

	@override
	void dispose() {
		models.video.removeListener(updateImage);
		super.dispose();
	}

	Future<ui.Image> loadImage(List<int> bytes) async {
		final ulist = Uint8List.fromList(bytes);
		final buffer = await ui.ImmutableBuffer.fromUint8List(ulist);
		final descriptor = await ui.ImageDescriptor.encoded(buffer);
		final codec = await descriptor.instantiateCodec();
		final frame = await codec.getNextFrame();
		return frame.image;
	}

	Future<void> updateImage() async {
		if (!hasFrame) return;
		final newImage = await loadImage(feed.frame!);
		image?.dispose();
		setState(() => image = newImage);
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
				child: image == null ? Text(errorMessage) 
					: Row(children: [Expanded(child: RawImage(image: image, fit: BoxFit.fill))]),
			),
			Positioned(
				top: 4, 
				right: 4,
				child: PopupMenuButton<CameraFeed>(
					tooltip: "Select a feed",
					icon: const Icon(Icons.more_horiz),
					onSelected: updateFeed,
					itemBuilder: (_) => [
						for (final other in VideoModel.allFeeds) PopupMenuItem(
							value: other,
							child: Text(other.name),
						),
					]
				)
			)
		]
	);

	String get errorMessage {
		final String name = feed.name;
		if (hasFrame) { return "Loading feed for $name..."; }
		else if (!feed.isActive) { return "Camera for $name is off"; }
		else if (!feed.isConnected) { return "Camera $name is not connected"; }
		else { return "Unknown error for camera $name"; }
	}

	Future<void> updateFeed(CameraFeed newFeed) async {
		await models.video.disableFeed(feed);
		await models.video.enableFeed(newFeed);
		print("Switched from ${feed.name} to ${newFeed.name}");
		image?.dispose();
		setState(() {
			feed = newFeed;
			image = null;
		});
		await updateImage();
	}
}
