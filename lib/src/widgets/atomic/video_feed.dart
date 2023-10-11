import "dart:async";
import "dart:typed_data";
import "dart:ui" as ui;
import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/widgets.dart";

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
		image = null;
	}
}

/// Displays frames of a video feed.
class VideoFeed extends StatefulWidget {
	/// The feed to show in this widget.
	final CameraName name;

	/// Displays a video feed for the given camera.
	const VideoFeed({required this.name});

	@override
	VideoFeedState createState() => VideoFeedState();
}

/// Class that defines a slider for camera controls
class SliderSettings extends StatelessWidget {
  /// Name of the slider
  final String label;
  /// Valude corresponding to the slider
  final double value;
  /// Value to change the position of the slider
  final ValueChanged<double> onChanged;
  
  /// Constructor for SliderSettings
  const SliderSettings({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Column(
      children: <Widget>[
        Row (
          mainAxisSize: MainAxisSize.min,
          children: <Widget> [
            Text(label),
            const Text(": "),
            // Will this incur some computation cost? is doing .floor().toString() fine?
            Text(value.floor().toString()),
          ],
        ),
        Slider(
          value: value,
          onChanged: onChanged,
          max: 100,
        ),
      ],
    );
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
	late VideoData data;

	/// A helper class responsible for managing and loading an image.
	final imageLoader = ImageLoader();

  /// Checks if the current slider for video camera is open
  bool isOpened = false;

  /// Value for zoom
  double zoom = 0;
  /// Value for pan
  double pan = 0;
  /// Value for focus
  double focus = 0;
  /// Value for brightness
  double brightness = 0;

  /// Controller for the BottomSheet
  PersistentBottomSheetController? controller;

  void _showSettingsPanel() => controller = Scaffold.of(context).showBottomSheet(
    (context) => Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(children: [
            Spacer(),
            Text("Settings for ${data.details.name.humanName}"),
            Spacer(),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                controller!.close();
                isOpened = false;
              },
            ),
          ]),
          SliderSettings(
            label: "Zoom",
            value: zoom,
            onChanged: (val) => setState(() => zoom = val),
          ),
          SliderSettings(
            label: "Pan",
            value: pan,
            onChanged: (val) => setState(() => pan = val),
          ),
          SliderSettings(
            label: "Focus",
            value: focus,
            onChanged: (val) => setState(() => focus = val),
          ),
          SliderSettings(
            label: "Brightness",
            value: brightness,
            onChanged: (val) => setState(() => brightness = val),
          ),
        ],
      ),
    ),
  );

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
		data = models.video.feeds[widget.name]!;
		if (data.details.status != CameraStatus.CAMERA_ENABLED) {
			setState(() => imageLoader.image = null);
		}
		setState(() { });
		if (!data.hasFrame() || imageLoader.isLoading) return;
		await imageLoader.load(data.frame);
		if (mounted) setState(() { });
	}

	@override
	Widget build(BuildContext context) => Stack(
		children: [
			Container(
				color: context.colorScheme.brightness == Brightness.light
					? Colors.blueGrey
					: Colors.blueGrey[700], 
				height: double.infinity,
				width: double.infinity,
				padding: const EdgeInsets.all(4),
				alignment: Alignment.center,
				child: models.sockets.video.isConnected && imageLoader.hasImage && data.details.status == CameraStatus.CAMERA_ENABLED 
					? Row(children: [
							Expanded(child: RawImage(image: imageLoader.image, fit: BoxFit.contain)),
					],)
					: Text(errorMessage, textAlign: TextAlign.center),
			),
			Row(
				mainAxisAlignment: MainAxisAlignment.end,
				children: [
					Text("${models.video.networkFps[data.details.name]!} FPS"),
					if (data.hasFrame()) IconButton(
						icon: const Icon(Icons.add_a_photo), 
						onPressed: () => models.video.saveFrame(widget.name),
					),
					IconButton(
						icon: const Icon(Icons.settings),
						onPressed: () async => showDialog(
							context: context,
							builder: (_) => CameraDetailsEditor(data),
						),
					),
					ViewsSelector(currentView: widget.name.humanName),
				],
			),
			Positioned(
        left: 5, 
        bottom: 5, 
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                print("Is opened? $isOpened");
                if (isOpened) { 
                  controller?.close();
                  controller = null;
                } else {
                  _showSettingsPanel();
                }
                isOpened = !isOpened;
              }, 
              icon: const Icon(Icons.tune),
            ),
            Text(data.details.name.humanName),
          ],
        ),
      ),
		],
	);

	/// Displays an error message describing why `image == null`.
	String get errorMessage {
		if (!models.sockets.video.isConnected) return "The video program is not connected";
		switch (data.details.status) {
			case CameraStatus.CAMERA_LOADING: return "Camera is loading...";
			case CameraStatus.CAMERA_STATUS_UNDEFINED: return "Unknown error";
			case CameraStatus.CAMERA_DISCONNECTED: return "Camera is not connected";
			case CameraStatus.CAMERA_DISABLED: return "Camera is disabled.\nClick the settings icon to enabled it.";
			case CameraStatus.CAMERA_NOT_RESPONDING: return "Camera is not responding";
			case CameraStatus.FRAME_TOO_LARGE: return "Camera is reading too much detail\nReduce the quality or resolution";
			case CameraStatus.CAMERA_HAS_NO_NAME: return "Camera has no name\nChange lib/constants.py on the video Pi";
			case CameraStatus.CAMERA_ENABLED: 
				if (data.hasFrame()) { return "Loading feed..."; }
				else { return "Starting camera..."; }
		}
		return "Unknown error";
	}
}
