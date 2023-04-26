import "dart:async";
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

	/// Whether an image is currently loading.
	bool isLoading = false;

	/// Processes the next frame and stores the result in [image].
	Future<void> load(List<int> bytes) async {
		isLoading = true;
		final ulist = Uint8List.fromList(bytes.toList());
		codec = await ui.instantiateImageCodec(ulist);
		final frame = await codec!.getNextFrame();
		image = frame.image;
		isLoading = false;
	}

	/// Disposes all the resources associated with the current frame.
	void dispose() {
		codec?.dispose();
		image?.dispose();
	}
}

/// Displays frames of a video feed.
class VideoFeed extends StatefulWidget {
	/// The feed to show in this widget.
	final CameraName name;

	/// The index of this feed in the UI.
	final int index;

	/// Displays a video feed for the given camera.
	const VideoFeed({required this.index, required this.name});

	@override
	VideoFeedState createState() => VideoFeedState();
}

/// The logic for updating a [VideoFeed].
/// 
/// This widget listens to [VideoModel.frameUpdater] to sync its framerate with other [VideoFeed]s.
/// On every update, this widget grabs the frame from [VideoData.frame], decodes it, renders it, 
/// then replaces the old frame. The key is that all the image processing logic is done off-screen
/// while the old frame remains on-screen. When the frame is processed, it quickly replaces the old
/// frame. That way, the user sees one continuous video instead of a flickering image.
class VideoFeedState extends State<VideoFeed> {
	/// The data being streamed.
	late final VideoData data;

	/// A helper class responsible for managing and loading an image.
	final imageLoader = ImageLoader();

	@override
	void initState() {
		super.initState();
		data = models.video.feeds[widget.name]!;
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
		if (!data.hasFrame() || imageLoader.isLoading) return;
		await imageLoader.load(data.frame);
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
							Expanded(child: RawImage(image: imageLoader.image, fit: BoxFit.fill))
					]),
			),
			Row(
				mainAxisAlignment: MainAxisAlignment.end,
				children: [
					if (data.hasFrame()) IconButton(
						icon: const Icon(Icons.camera_alt), 
						onPressed: () => models.video.saveFrame(widget.name),
					),
					PopupMenuButton<CameraName>(
						tooltip: "Select a feed",
						icon: const Icon(Icons.more_horiz),
						onSelected: (name) => models.video.replaceFeed(widget.index, name),
						itemBuilder: (_) => [
							for (final name in CameraName.values) PopupMenuItem(
								value: name,
								child: Text(name.humanName),
							),
						]
					)
				]
			),
			Positioned(left: 5, bottom: 5, child: Text(widget.name.humanName)),
		]
	);

	/// Displays an error message describing why `image == null`.
	String get errorMessage {
		switch (data.details.status) {
			case CameraStatus.CAMERA_STATUS_UNDEFINED: return "Unknown error";
			case CameraStatus.CAMERA_DISCONNECTED: return "Camera [${widget.name}] is off";
			case CameraStatus.CAMERA_DISABLED: return "Camera is disabled.\nClick the settings icon to enabled it.";
			case CameraStatus.CAMERA_ENABLED: 
				if (data.hasFrame()) { return "Loading feed..."; }
				else { return "Starting camera..."; }
		}
		return "Unknown error";
	}
}
