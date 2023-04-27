import "dart:async";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";

/// A data model to stream video from the rover.
/// 
/// TODO: Separate this from the view model logic.
class VideoModel extends Model {
	/// All the video feeds supported by the rover.
	final Map<CameraName, VideoData> feeds = {
		for (final name in CameraName.values) name: VideoData(
			details: CameraDetails(
				name: name,
				status: CameraStatus.CAMERA_DISCONNECTED,
			)
		)
	};

	/// Triggers when it's time to update a new frame.
	/// 
	/// This is kept here to ensure all widgets are in sync.
	Timer? frameUpdater;

	/// The latest handshake received by the rover.
	VideoCommand? _handshake;

	@override
	Future<void> init() async {
		services.videoSocket.registerHandler<VideoData>(
			name: VideoData().messageName,
			decoder: VideoData.fromBuffer,
			handler: handleData,
		);
		services.videoSocket.registerHandler<VideoCommand>(
			name: VideoCommand().messageName,
			decoder: VideoCommand.fromBuffer,
			handler: (command) => _handshake = command,
		);
		reset();
	}

	@override
	void dispose() {
		frameUpdater?.cancel();
		super.dispose();
	}

	/// Clears all video data and resets the timer.
	void reset() {
		for (final name in CameraName.values) {
			feeds[name]!.details.status = CameraStatus.CAMERA_DISCONNECTED;
		}

		frameUpdater?.cancel();
		frameUpdater = Timer.periodic(
			Duration(milliseconds: (1000/models.settings.video.fps).round()),
			(_) => notifyListeners(),
		);
	}

	/// Updates the data for a given camera.
	void handleData(VideoData newData) {
		final data = feeds[newData.details.name]!;
		data.details = newData.details;
		data.id = newData.id;
		if (newData.frame.isNotEmpty) data.frame = newData.frame;
		if (newData.details.status != CameraStatus.CAMERA_ENABLED) data.frame = [];
	}

	/// Takes a screenshot of the current frame.
	Future<void> saveFrame(CameraName name) async {
		final List<int>? cachedFrame = feeds[name]?.frame;
		if (cachedFrame == null) throw ArgumentError.notNull("Feed for $name"); 
		await services.files.writeImage(cachedFrame, name.humanName);
		models.home.setMessage(severity: Severity.info, text: "Screenshot saved");
	}

	/// Updates settings for the given camera.
	Future<void> updateCamera(int id, CameraDetails details) async { 
		_handshake = null;
		final command = VideoCommand(id: id, details: details);
		services.videoSocket.sendMessage(command);
		await Future.delayed(const Duration(seconds: 2));
		if (_handshake == null) throw RequestNotAccepted();
	}

	Future<void> toggleCamera(CameraName name, {required bool enable}) async {
		final details = feeds[name]!.details;
		if (enable && details.status != CameraStatus.CAMERA_DISABLED) return;
		if (!enable && details.status == CameraStatus.CAMERA_DISCONNECTED) return;

		_handshake = null;
		details.status = enable ? CameraStatus.CAMERA_ENABLED : CameraStatus.CAMERA_DISABLED;
		final command = VideoCommand(id: feeds[name]!.id, details: details);
		services.videoSocket.sendMessage(command);
		await Future.delayed(const Duration(seconds: 2));
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
