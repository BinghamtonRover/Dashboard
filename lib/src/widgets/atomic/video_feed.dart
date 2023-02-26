import "dart:async";
import "dart:math" as math;
import "dart:typed_data";
import "dart:ui" as ui;
import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// Displays frames of a [CameraFeed].
class VideoFeed extends StatefulWidget {
	/// The feed to show in this widget.
	/// 
	/// May be changed by the user. See [VideoFeedState.feed] for the actual value.
	final CameraFeed initialFeed;

	/// Displays a [CameraFeed] on the screen.
	const VideoFeed(this.initialFeed);

	@override
	VideoFeedState createState() => VideoFeedState();
}

/// The logic for updating for updating a [VideoFeed].
/// 
/// This widget listens to [VideoModel.frameUpdater] to sync its framerate with other [VideoFeed]s.
/// On every update, this widget grabs the frame from [CameraFeed.frame], decodes it, renders it, 
/// then replaces the old frame. The key is that all the image processing logic is done off-screen
/// while the old frame remains on-screen. That way, the user sees one continuous video instead
/// of a flickering image.
class VideoFeedState extends State<VideoFeed> {
	/// The feed being streamed.
	late CameraFeed feed;

	/// The `dart:ui` instance of the current frame.
	ui.Image? image;

	ui.ImmutableBuffer? buffer;

	ui.ImageDescriptor? descriptor;

	ui.Codec? codec;

	/// Whether [feed] has a frame to show.
	bool get hasFrame => feed.frame != null;

	@override
	void initState() {
		super.initState();
		feed = widget.initialFeed;
		models.video.addListener(updateImage);
	}

	void disposeImage() {
		image?.dispose();
		codec?.dispose();
		descriptor?.dispose();
		buffer?.dispose();
	}

	@override
	void dispose() {
		models.video.removeListener(updateImage);
		disposeImage();
		super.dispose();
	}

	/// Decodes and renders the next frame.
	/// 
	/// This process happens off-screen. To display the resulting image, use a [RawImage] widget.
	Future<ui.Image> loadImage(List<int> bytes) async {
		final ulist = Uint8List.fromList(bytes.toList());
		buffer = await ui.ImmutableBuffer.fromUint8List(ulist);
		descriptor = await ui.ImageDescriptor.encoded(buffer!);
		codec = await descriptor!.instantiateCodec();
		final frame = await codec!.getNextFrame();
		return frame.image;
	}

	/// Grabs the new frame, renders it, and replaces the old frame.
	Future<void> updateImage() async {
		if (!hasFrame) return;
		// disposeImage();
		final newImage = await loadImage(feed.frame!);
		if (mounted) setState(() => image = newImage);
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
					: Row(children: [
						Expanded(child: feed.id == CameraName.ARM_BASE 
							? Transform.rotate(angle: math.pi, child: RawImage(image: image, fit: BoxFit.fill))
							: RawImage(image: image, fit: BoxFit.fill)
						)
					]),
			),
			Row(
				mainAxisAlignment: MainAxisAlignment.end,
				children: [
					if (feed.isActive) IconButton(
						icon: const Icon(Icons.camera_alt), 
						onPressed: () => models.video.saveFrame(feed),
					), 
					PopupMenuButton<CameraFeed>(
						tooltip: "Select a feed",
						icon: const Icon(Icons.more_horiz),
						onSelected: selectNewFeed,
						itemBuilder: (_) => [
							for (final other in VideoModel.allFeeds) PopupMenuItem(
								value: other,
								child: Text(other.name),
							),
						]
					)
				]
			),
		]
	);

	/// Displays an error message describing why `image == null`.
	String get errorMessage {
		final String name = feed.name;
		if (hasFrame) { return "Loading feed for $name..."; }
		else if (!feed.isActive) { return "Camera for $name is off"; }
		else if (!feed.isConnected) { return "Camera $name is not connected"; }
		else { return "Unknown error for camera $name"; }
	}

	/// Switches this widget to a new [CameraFeed].
	Future<void> selectNewFeed(CameraFeed newFeed) async {
		await models.video.disableFeed(feed);
		await models.video.enableFeed(newFeed);
		setState(() {
			feed = newFeed;
			image = null;
		});
		await updateImage();
	}
}
