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
		for (final name in CameraName.values)
			name: VideoData(details: CameraDetails(
				name: name,
				status: CameraStatus.CAMERA_DISCONNECTED,
			)),
	};

	/// The feeds on the screen.
	List<CameraName> feedsOnScreen = [
		CameraName.ROVER_FRONT,
		CameraName.ROVER_REAR,
	];

	/// Triggers when it's time to update a new frame.
	/// 
	/// This is kept here to ensure all widgets are in sync.
	late final Timer frameUpdater;

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
		frameUpdater = Timer.periodic(
			const Duration(milliseconds: 16),  // 60 FPS
			(_) => notifyListeners()
		);
	}

	@override
	void dispose() {
		frameUpdater.cancel();
		super.dispose();
	}

	/// Clears all video data. 
	void clear() {
		for (final name in CameraName.values) {
			feeds[name]!.details.status = CameraStatus.CAMERA_DISCONNECTED;
		}
	}

	/// Updates the data for a given camera.
	void handleData(VideoData newData) {
		final data = feeds[newData.details.name]!;
		data.details = newData.details;
		data.id = newData.id;
		if (newData.frame.isNotEmpty) data.frame = newData.frame;
		if (newData.details.status != CameraStatus.CAMERA_ENABLED) data.frame = [];
	}

	/// Adds or subtracts a number of camera feeds to/from the UI
	void setNumFeeds(int? value) {
		if (value == null || value > 4 || value < 1) return;
		final int currentNum = feedsOnScreen.length;
		if (value < currentNum) {
			feedsOnScreen = feedsOnScreen.sublist(0, value);
		} else {
			for (int i = currentNum; i < value; i++) {
				feedsOnScreen.add(CameraName.ROVER_FRONT);
			}
		}
		notifyListeners();
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

	/// Replaces a video feed in the UI.
	void replaceFeed(int index, CameraName name) {
		feedsOnScreen[index] = name;
		notifyListeners();
	}
}

/// An exception thrown when the rover does not respond to a handshake.
/// 
/// Certain changes require a handshake to ensure the rover has received and applied the change.
/// If the rover fails to acknowledge or apply the change, a response will not be sent. Throw
/// this error to indicate that. 
class RequestNotAccepted implements Exception { }
