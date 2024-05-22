import "dart:async";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";

/// A data model to stream video from the rover.
class VideoModel extends Model {
	/// All the video feeds supported by the rover.
	final Map<CameraName, VideoData> feeds = {
		for (final name in CameraName.values) name: VideoData(
			details: CameraDetails(
				name: name,
				status: CameraStatus.CAMERA_DISCONNECTED,
			),
		),
	};

	/// How many frames came in the network in the past second.
	/// 
	/// This number is updated every frame. Use [networkFps] in the UI.
	Map<CameraName, int> framesThisSecond = {
		for (final name in CameraName.values) 
			name: 0,
	};

	/// How many frames came in the network in the past second.
	Map<CameraName, int> networkFps = {};

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
		models.messages.registerHandler<VideoData>(
			name: VideoData().messageName,
			decoder: VideoData.fromBuffer,
			handler: handleData,
		);
		models.messages.registerHandler<VideoCommand>(
			name: VideoCommand().messageName,
			decoder: VideoCommand.fromBuffer,
			handler: (command) => _handshake = command,
		);
		fpsTimer = Timer.periodic(const Duration(seconds: 1), resetNetworkFps);
		reset();
	}

	/// Saves the frames in the past second ([framesThisSecond]) to [networkFps].
	void resetNetworkFps([_]) {
		networkFps = Map.from(framesThisSecond);
		framesThisSecond = {
			for (final name in CameraName.values) 
				name: 0,
		};
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
		resetNetworkFps();
		for (final name in CameraName.values) {
			feeds[name]!.details.status = CameraStatus.CAMERA_DISCONNECTED;
		}

		frameUpdater?.cancel();
		frameUpdater = Timer.periodic(
			Duration(milliseconds: (1000/models.settings.dashboard.maxFps).round()),
			(_) => notifyListeners(),
		);
	}

	/// Updates the data for a given camera.
	void handleData(VideoData newData) {
		if (
			(newData.hasFrame() && newData.details.name == CameraName.CAMERA_NAME_UNDEFINED) ||
			newData.details.status == CameraStatus.CAMERA_HAS_NO_NAME
		) {
			models.home.setMessage(severity: Severity.critical, text: "Received feed from camera #${newData.id} with no name");
			return;
		}
		final name = newData.details.name;
		final data = feeds[name]!
			..details = newData.details
			..id = newData.id;

		// Some [VideoData] packets are just representing metadata, not an empty video frame.
		// If this is one such packet (doesn't have a frame but status == enabled), don't save.
		if (newData.hasFrame() && newData.details.status == CameraStatus.CAMERA_ENABLED) {
			data.frame = newData.frame;
			framesThisSecond[name] = (framesThisSecond[name] ?? 0) + 1;
		}
	}

	/// Takes a screenshot of the current frame.
	Future<void> saveFrame(CameraName name) async {
		final cachedFrame = feeds[name]?.frame;
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
	/// it'll fail silently. However, if the server simply doesn't respond, it'll show a warning.
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
