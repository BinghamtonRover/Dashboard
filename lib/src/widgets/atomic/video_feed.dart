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
		final buffer = Uint8List.fromList(bytes.toList());
		codec = await ui.instantiateImageCodec(buffer);
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

  /// The index of this view.
  final int index;

	/// Displays a video feed for the given camera.
	const VideoFeed({required this.name, required this.index});

	@override
	VideoFeedState createState() => VideoFeedState();
}

/// Class that defines a slider for camera controls
class SliderSettings extends StatelessWidget {
  /// Name of the slider
  final String label;

  /// Value corresponding to the slider
  final double value;

  /// Value to change the position of the slider
  final ValueChanged<double> onChanged;

  /// The min value on this slider.
  final double min;

  /// The max value on this slider.
  final double max;

  /// Constructor for SliderSettings
  const SliderSettings({
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 100,
  });

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      Text("$label: ${value.floor()}"),
      Slider(
        value: value,
        onChanged: onChanged,
        max: max,
        min: min,
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
		setState(() {});
		if (!data.hasFrame() || imageLoader.isLoading) return;
		await imageLoader.load(data.frame);
		if (mounted) setState(() {});
	}

  /// Whether there is a frame ready to display.
  bool get isReady => models.sockets.video.isConnected
    && imageLoader.hasImage
    && data.details.status == CameraStatus.CAMERA_ENABLED;

  /// Builds the inside of the video feed. Either a video frame or an error message.
  Widget buildChild(BuildContext context) => isReady
    ? Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: double.infinity,
          width: isOpened ? 200 : 0,
          child: VideoSettingsWidget(
            id: data.id,
            details: data.details,
          ),
        ),
        Expanded(child: RawImage(image: imageLoader.image, fit: BoxFit.contain)),
      ],
    )
    : Center(child: Text(errorMessage, textAlign: TextAlign.center));

  @override
  Widget build(BuildContext context) => Container(
    color: context.colorScheme.brightness == Brightness.light
      ? Colors.blueGrey
      : Colors.blueGrey[700],
    child: Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: toggleSettings,
              icon: const Icon(Icons.tune),
            ),
            Text(data.details.name.humanName),
            const Spacer(),
            Text("${models.video.networkFps[data.details.name]!} FPS"),
            if (data.hasFrame())
              IconButton(
                icon: const Icon(Icons.add_a_photo),
                onPressed: () => models.video.saveFrame(data.id, data.details),
              ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () async => showDialog(
                context: context,
                builder: (_) => CameraDetailsEditor(data),
              ),
            ),
            ViewsSelector(index: widget.index),
          ],
        ),
        Expanded(child: buildChild(context)),
      ],
    ),
  );

  /// Opens or closes the settings panel.
  void toggleSettings() => setState(() => isOpened = !isOpened);

  /// Displays an error message describing why `image == null`.
  String get errorMessage {
    if (!models.sockets.video.isConnected) return "The video program is not connected";
    switch (data.details.status) {
      case CameraStatus.CAMERA_LOADING:
        return "Camera is loading...";
      case CameraStatus.CAMERA_STATUS_UNDEFINED:
        return "Unknown error";
      case CameraStatus.CAMERA_DISCONNECTED:
        return "Camera is not connected";
      case CameraStatus.CAMERA_DISABLED:
        return "Camera is disabled.\nClick the settings icon to enabled it.";
      case CameraStatus.CAMERA_NOT_RESPONDING:
        return "Camera is not responding";
      case CameraStatus.FRAME_TOO_LARGE:
        return "Camera is reading too much detail\nReduce the quality or resolution";
      case CameraStatus.CAMERA_HAS_NO_NAME:
        return "Camera has no name\nChange lib/constants.py on the video Pi";
      case CameraStatus.CAMERA_ENABLED:
        if (data.hasFrame()) {
          return "Loading feed...";
        } else {
          return "Starting camera...";
        }
    }
    return "Unknown error";
  }
}

/// A widget to edit camera settings.
class VideoSettingsWidget extends StatefulWidget {
  /// The details being sent to the camera.
  final CameraDetails details;
  /// The ID of the camera being edited.
  final String id;
  /// Creates the video settings widget.
  const VideoSettingsWidget({
    required this.details, 
    required this.id,
  });

  @override
  VideoSettingsState createState() => VideoSettingsState();
}

/// A state for [VideoSettingsWidget].
class VideoSettingsState extends State<VideoSettingsWidget> {
  /// The zoom level. Camera-specific.
  double zoom = 100;
  /// The pan level, when zoomed in.
  double pan = 0;
  /// The tilt level, when zoomed in.
  double tilt = 0;
  /// The focus level, if autofocus is disabled.
  double focus = 0;
  /// Whether the camera should autofocus.
  bool autofocus = true;

	@override
	Widget build(BuildContext context) => ListView(
    children: [
			SliderSettings(
				label: "Zoom",
				value: zoom,
				min: 100,
				max: 800,
				onChanged: (val) async {
					setState(() => zoom = val);
					await models.video.updateCamera(
            verify: false,
            widget.id,
            CameraDetails(name: widget.details.name, zoom: val.round()),
					);
				},
      ),
			SliderSettings(
				label: "Pan",
				value: pan,
				min: -180,
				max: 180,
				onChanged: (val) async {
					setState(() => pan = val);
					await models.video.updateCamera(
            verify: false,
					widget.id,
					CameraDetails(name: widget.details.name, pan: val.round()),
					);
				},
      ),
			SliderSettings(
				label: "Tilt",
				value: tilt,
				min: -180,
				max: 180,
				onChanged: (val) async {
					setState(() => tilt = val);
					await models.video.updateCamera(
            verify: false,
					widget.id,
					CameraDetails(name: widget.details.name, tilt: val.round()),
					);
				},
      ),
			SliderSettings(
				label: "Focus",
				value: focus,
				max: 255,
				onChanged: (val) async {
					setState(() => focus = val);
					await models.video.updateCamera(
            verify: false,
					widget.id,
					CameraDetails(name: widget.details.name, focus: val.round()),
					);
				},
      ),
			// Need to debug bool conversion to 1.0 and 2.0
			SwitchListTile(
        title: const Text("Autofocus"),
				value: autofocus,
				onChanged: (bool value) async {
					setState(() => autofocus = value);
					await models.video.updateCamera(
            verify: false,
            widget.id,
            CameraDetails(name: widget.details.name, autofocus: autofocus),
          );
        },
      ),
    ],
  );
}
