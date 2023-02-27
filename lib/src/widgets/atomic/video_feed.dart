import "dart:async";
import "dart:math" as math;
import "dart:typed_data";
import "dart:ui" as ui;
import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// A helper class to load and manage resources used by a [ui.Image].
/// 
/// To use: 
/// - Call [load] with your image data
/// - Pass [image] to a [RawImage] widget, if it isn't null
/// - Call [dispose] to release all resources used by the image.
/// 
/// It is safe to call [load] or [dispose] multiple times, and calling [load]
/// will automatically call [dispose] on the existing resources.
class ImageLoader {
	/// The `dart:ui` instance of the current frame.
	ui.Image? image;

	/// The codec used by [image].
	ui.Codec? codec;

	/// Whether this loader has been initialized.
	bool get hasImage => image != null;

	/// Processes the next frame and stores the result in [image].
	Future<void> load(List<int> bytes) async {
		// if (hasImage) dispose();
		final ulist = Uint8List.fromList(bytes.toList());
		codec = await ui.instantiateImageCodec(ulist);
		final frame = await codec!.getNextFrame();
		image = frame.image;
	}

	/// Disposes all the resources associated with the current frame.
	void dispose() {
		codec?.dispose();
		image?.dispose();
	}
}

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

	/// Whether [feed] has a frame to show.
	bool get hasFrame => feed.frame != null;

	/// A helper class responsible for managing and loading an image.
	final imageLoader = ImageLoader();

	@override
	void initState() {
		super.initState();
		feed = widget.initialFeed;
		models.video.addListener(updateImage);
	}

	@override
	void dispose() {
		models.video.removeListener(updateImage);
		imageLoader.dispose();
		super.dispose();
	}

	/// Grabs the new frame, renders it, and replaces the old frame.
	Future<void> updateImage() async {
		if (!hasFrame) return;
		await imageLoader.load(feed.frame!);
		if (mounted) setState(() { });
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
				child: !imageLoader.hasImage ? Text(errorMessage) 
					: Row(children: [
						// Special case: ARM_BASE camera is flipped, let's unflip it in software
						Expanded(child: feed.id == CameraName.ARM_BASE 
							? Transform.rotate(angle: math.pi, child: RawImage(image: imageLoader.image, fit: BoxFit.fill))
							: RawImage(image: imageLoader.image, fit: BoxFit.fill)
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
		imageLoader.dispose();
		setState(() => feed = newFeed);
		await updateImage();
	}
}
