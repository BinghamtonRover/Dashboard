import "dart:async";

import "package:flutter/material.dart";
import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";

/// A non-notifying model representing a single video feed from a camera
/// 
/// The state for this model is not handled as a whole to improve performance,
/// instead, this encompasses multiple state notifiers which can be individually
/// listened to. The state notifiers are updated by a [VideoModel], which will
/// periodically update the video with received network data, as well as update
/// the FPS.
class VideoFeedModel {
  /// The name of the camera for this video feed
  final CameraName cameraName;
  /// The details of the camera
  late CameraDetails details = CameraDetails(
    name: cameraName,
    status: CameraStatus.CAMERA_DISCONNECTED,
  );
  /// The camera ID
  String id = "";

  /// Value notifier for the status of the camera
  ValueNotifier<CameraStatus> status = ValueNotifier(CameraStatus.CAMERA_DISCONNECTED);

  /// Value notifier for the video frame
  ValueNotifier<List<int>?> frameNotifier = ValueNotifier(null);

  /// The last received frame, this is cached here since [frameNotifier]
  /// is updated at a specific rate
  List<int>? frameCache;

  /// A value notifier for whether or not there is a frame present
  /// 
  /// This can be useful if a widget needs to update only when the frame
  /// notifier gets its first frame or disposes its last frame, and not
  /// when a new frame arrives
  ValueNotifier<bool> hasFrameStatus = ValueNotifier(false);

  /// Value notifier for the FPS
  ValueNotifier<int> framesPerSecond = ValueNotifier(0);
  
  /// How many frames came in the network in the past second.
  /// 
  /// This number is updated every frame. Use [framesPerSecond] in the UI.
  int _receivedFrames = 0;

  /// Whether or not there is a valid frame to display
  bool get hasFrame => hasFrameStatus.value;

  /// Constructor for video feed model, initializing camera name
  VideoFeedModel({required this.cameraName}) {
    init();
  }

  /// Initializes this video feed model, resetting the FPS to 0
  void init() {
    resetFps();
  }

  /// Resets this video feed to its initial state as if the dashboard has just started up
  /// 
  /// This will FPS and received frame count to 0, as well as set the status to disconnected
  void resetFps() {
    framesPerSecond.value = 0;
    _receivedFrames = 0;
  }

  /// Sets the FPS of the feed to the number of frames received in the past second
  void updateFps() {
    framesPerSecond.value = _receivedFrames;
    _receivedFrames = 0;
  }

  /// Updates the [frameNotifier] to the previously received
  /// video frame from the network
  void updateFrame() {
    frameNotifier.value = frameCache;
    hasFrameStatus.value = frameNotifier.value != null && frameNotifier.value!.isNotEmpty;
  }

  /// Handles a new incoming [VideoData] packet
  void handleData(VideoData data) {
    if (data.details.name != cameraName) {
      return;
    }
    details = data.details;
    status.value = data.details.status;
    id = data.id;

		// Some [VideoData] packets are just representing metadata, not an empty video frame.
		// If this is one such packet (doesn't have a frame but status == enabled), don't save.
    if (data.hasFrame() && data.details.status == CameraStatus.CAMERA_ENABLED) {
      frameCache = data.frame;
      _receivedFrames++;
    } else if (!data.hasFrame() && data.details.status != CameraStatus.CAMERA_ENABLED) {
      frameCache = null;
    }
  }
}

/// A data model to stream video from the rover.
class VideoModel extends Model {
  /// All the video feeds supported by the rover.
  final Map<CameraName, VideoFeedModel> feeds = {
    for (final name in CameraName.values)
      name: VideoFeedModel(cameraName: name),
  };

	/// Triggers when it's time to update a new frame.
	///
	/// This is kept here to ensure all widgets are in sync.
	Timer? frameUpdater;

	/// A timer to update the FPS counter.
	late final Timer fpsTimer;

	/// The latest handshake received by the rover.
	VideoCommand? _handshake;

	@override
	Future<void> init() async {
		models.messages.stream.onMessage<VideoData>(
			name: VideoData().messageName,
			constructor: VideoData.fromBuffer,
			callback: handleData,
		);
		models.messages.stream.onMessage<VideoCommand>(
			name: VideoCommand().messageName,
			constructor: VideoCommand.fromBuffer,
			callback: (command) => _handshake = command,
		);
		fpsTimer = Timer.periodic(const Duration(seconds: 1), updateFps);
		reset();
	}

	/// Updates the FPS for each individual video feed to its
  /// number of frames received in the past second
	void updateFps([_]) {
    for (final feed in feeds.values) {
      feed.updateFps();
    }
		notifyListeners();
	}

	@override
	void dispose() {
		frameUpdater?.cancel();
		fpsTimer.cancel();
		super.dispose();
	}

	/// Clears all video data and resets the timer.
	void reset() {
		updateFps();
    for (final feed in feeds.values) {
      feed.resetFps();
      feed.details.status = CameraStatus.CAMERA_DISCONNECTED;
    }

		frameUpdater?.cancel();
    frameUpdater = Timer.periodic(
      Duration(milliseconds: 1000 ~/ models.settings.dashboard.maxFps),
      (_) {
        for (final feed in feeds.values) {
          feed.updateFrame();
        }
        notifyListeners();
      },
    );
	}

	/// Updates the data for a given camera.
	void handleData(VideoData newData) {
    if ((newData.hasFrame() && newData.details.name == CameraName.CAMERA_NAME_UNDEFINED) ||
        newData.details.status == CameraStatus.CAMERA_HAS_NO_NAME) {
      models.home.setMessage(
          severity: Severity.critical,
        text: "Received feed from camera #${newData.id} with no name",
      );
      return;
    }
    feeds[newData.details.name]!.handleData(newData);
	}

  /// Sends a command to the video program to take a screenshot
  /// onboard the video program
  /// 
  /// This will result in a much higher quality image, but will
  /// take much longer to capture, and will pause the video feed
  /// for several seconds
  Future<void> takeOnboardScreenshot(String id, CameraDetails details) async {
    final command = VideoCommand(id: id, details: details, takeSnapshot: true);
    if (await models.sockets.video.tryHandshake(
      message: command,
      timeout: const Duration(seconds: 1),
      constructor: VideoCommand.fromBuffer,
    )) {
      models.home.setMessage(
        severity: Severity.info,
        text: "Screenshot request received, video stream may pause",
      );
    } else {
      models.home.setMessage(
        severity: Severity.error,
        text: "Screenshot command not received",
      );
    }
  }

	/// Takes a screenshot of the current frame.
	Future<void> saveFrame(CameraName name) async {
	final cachedFrame = feeds[name]?.frameCache;
		if (cachedFrame == null) throw ArgumentError.notNull("Feed for $name");
		await services.files.writeImage(cachedFrame, name.humanName);
		models.home.setMessage(severity: Severity.info, text: "Screenshot saved");
	}

	/// Updates settings for the given camera.
	Future<void> updateCamera(String id, CameraDetails details, {bool verify = true}) async {
		_handshake = null;
		final command = VideoCommand(id: id, details: details);
		models.sockets.video.sendMessage(command);
    if (!verify) return;
		await Future<void>.delayed(const Duration(seconds: 2));
		if (_handshake == null) throw RequestNotAccepted();
	}

	/// Enables or disables the given camera.
	///
	/// This function is called automatically, so if the camera is not connected or otherwise available,
	/// it will fail silently. However, if the server simply doesn't respond, it will show a warning.
	Future<void> toggleCamera(CameraName name, {required bool enable}) async {
		final details = feeds[name]!.details;
		if (enable && details.status != CameraStatus.CAMERA_DISABLED) return;
		if (!enable && details.status == CameraStatus.CAMERA_DISCONNECTED) return;

		_handshake = null;
		details.status = enable ? CameraStatus.CAMERA_ENABLED : CameraStatus.CAMERA_DISABLED;
		final command = VideoCommand(id: feeds[name]!.id, details: details);
		models.sockets.video.sendMessage(command);
		await Future<void>.delayed(const Duration(seconds: 2));
		if (_handshake == null) {
			models.home.setMessage(
				severity: Severity.warning,
				text: "Could not ${enable ? 'enable' : 'disable'} the ${name.humanName} camera",
			);
		}
	}
}

/// An exception thrown when the rover does not respond to a handshake.
///
/// Certain changes require a handshake to ensure the rover has received and applied the change.
/// If the rover fails to acknowledge or apply the change, a response will not be sent. Throw
/// this error to indicate that.
class RequestNotAccepted implements Exception { }
