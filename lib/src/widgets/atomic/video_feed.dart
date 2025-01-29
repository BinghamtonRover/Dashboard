import "dart:async";
import "dart:typed_data";
import "dart:ui" as ui;
import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/src/widgets/atomic/video_settings.dart";
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
class ImageLoader extends ChangeNotifier {
	ui.Image? _image;

  /// The `dart:ui` instance of the current frame.
  ui.Image? get image => _image;

  /// The `dart:ui` instance of the current frame.
  set image(ui.Image? value) {
    _image = value;
    notifyListeners();
  }

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
  @override
	void dispose() {
		codec?.dispose();
		image?.dispose();
		image = null;
    super.dispose();
	}

  @override
  void notifyListeners() {
    // prevent notifying listeners after the loader is no longer in use
    if (hasListeners) {
      super.notifyListeners();
    }
  }
}

/// Displays frames of a video feed.
class VideoFeed extends StatefulWidget {
  /// The index of this view
  final int index;

  /// The video feed for the viewer
  final VideoFeedModel videoFeed;

  /// Const constructor for 
  const VideoFeed({required this.index, required this.videoFeed, super.key});

  @override
  State<VideoFeed> createState() => _VideoFeedState();
}

/// The logic for updating a [VideoFeed].
/// 
/// This widget listens to [VideoFeedModel] to sync its framerate with other [VideoFeed]s.
/// On every update, this widget grabs the frame from [VideoFeedModel.frameNotifier], decodes it,
/// renders it, then replaces the old frame. The key is that all the image processing logic is
/// done off-screen while the old frame remains on-screen. When the frame is processed, it quickly
/// replaces the old frame. That way, the user sees one continuous video instead of a flickering
/// image.
class _VideoFeedState extends State<VideoFeed> {
  VideoFeedModel get videoFeed => widget.videoFeed;

	/// A helper class responsible for managing and loading an image.
	final imageLoader = ImageLoader();

  late final VideoFeedSettings settings = VideoFeedSettings(
    zoom: videoFeed.details.zoom.toDouble(),
    pan: videoFeed.details.pan.toDouble(),
    tilt: videoFeed.details.tilt.toDouble(),
    focus: videoFeed.details.focus.toDouble(),
    autofocus: videoFeed.details.autofocus,
  );

  /// Whether there is a frame ready to display
  bool get isReady =>
      models.sockets.video.isConnected &&
      imageLoader.hasImage &&
      videoFeed.details.status == CameraStatus.CAMERA_ENABLED;

  /// The error status of the camera
  String get errorMessage {
    if (!models.sockets.video.isConnected) return "The video program is not connected";
    switch (videoFeed.details.status) {
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
        return "Camera has no name\nChange lib/src/utils/constants.dart on the video Pi";
      case CameraStatus.CAMERA_ENABLED:
        if (videoFeed.hasFrame) {
          return "Loading feed...";
        } else {
          return "Starting camera...";
        }
    }
    return "Unknown error";
  }

  @override
  void initState() {
    videoFeed.frameNotifier.addListener(onImageUpdate);
    models.sockets.video.connectionStatus.addListener(onVideoConnectionChanged);
    super.initState();
  }

  @override
  void dispose() {
    videoFeed.frameNotifier.removeListener(onImageUpdate);
    models.sockets.video.connectionStatus.removeListener(onVideoConnectionChanged);

    imageLoader.dispose();
    settings.dispose();
    super.dispose();
  }

  void onVideoConnectionChanged() => setState(() {});

  Future<void> onImageUpdate() async {
    final frame = videoFeed.frameNotifier.value;
    if (videoFeed.details.status != CameraStatus.CAMERA_ENABLED) {
      imageLoader.image = null;
    }
    if (frame == null || frame.isEmpty || imageLoader.isLoading) {
      return;
    }
    await imageLoader.load(frame);
  }

  Widget _buildChild(BuildContext context) => isReady
    ? Row(
        children: [
          ListenableBuilder(
            listenable: settings,
            builder: (context, _) => AnimatedContainer(
              curve: Curves.easeInOut,
              duration: const Duration(milliseconds: 250),
              height: double.infinity,
              width: settings.isOpened ? 200 : 0,
              child: VideoSettingsWidget(
                settings,
                id: videoFeed.id,
                details: videoFeed.details,
              ),
            ),
          ),
          Expanded(
            child: InteractiveViewer(
              child: RawImage(
                image: imageLoader.image,
                fit: BoxFit.contain,
              ),
            ),
          ),
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
        ValueListenableBuilder(
          valueListenable: widget.videoFeed.hasFrameStatus,
          builder: (context, hasFrame, __) => Row(
            children: [
              IconButton(
                onPressed: () => settings.isOpened = !settings.isOpened,
                icon: const Icon(Icons.tune),
              ),
              Text(videoFeed.cameraName.humanName),
              const Spacer(),
              ValueListenableBuilder(
                valueListenable: widget.videoFeed.framesPerSecond,
                builder: (context, fps, _) => Text("$fps FPS"),
              ),
              if (hasFrame) ...[
                const SizedBox(width: 5),
                IconButton(
                  tooltip: "Save current frame (lower quality)",
                  icon: const Icon(Icons.add_a_photo),
                  onPressed: () => models.video.saveFrame(videoFeed.cameraName),
                ),
                const SizedBox(width: 5),
                IconButton(
                  tooltip: "Take onboard screenshot (high quality)",
                  onPressed: () => models.video.takeOnboardScreenshot(
                    widget.videoFeed.id,
                    videoFeed.details,
                  ),
                  icon: const Icon(Icons.add_photo_alternate),
                ),
              ],
              const SizedBox(width: 5),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () async => showDialog(
                  context: context,
                  builder: (_) => CameraDetailsEditor(
                    details: videoFeed.details,
                    id: videoFeed.id,
                  ),
                ),
              ),
              ViewsSelector(index: widget.index),
            ],
          ),
        ),
        Expanded(
          child: ListenableBuilder(
            listenable: imageLoader,
            builder: (context, _) => _buildChild(context),
          ),
        ),
      ],
    ),
  );
}
