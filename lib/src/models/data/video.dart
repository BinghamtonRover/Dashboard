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
			name: VideoData(details: CameraDetails(status: CameraStatus.CAMERA_DISCONNECTED)),
	};

	/// The feeds on the screen.
	List<CameraName> feedsOnScreen = [
		CameraName.ROVER_FRONT,
		CameraName.ROVER_REAR,
		CameraName.ARM_BASE,
		CameraName.ARM_GRIPPER,
	];

	/// Triggers when it's time to update a new frame.
	/// 
	/// This is kept here to ensure all widgets are in sync.
	late final Timer frameUpdater;

	@override
	Future<void> init() async {
		services.videoSocket.registerHandler<VideoData>(
			name: VideoData().messageName,
			decoder: VideoData.fromBuffer,
			handler: handleData,
		);
		frameUpdater = Timer.periodic(
			const Duration(milliseconds: 33),  // 30 FPS
			(_) => notifyListeners()
		);
	}

	@override
	void dispose() {
		frameUpdater.cancel();
		super.dispose();
	}

	/// Updates the data for a given camera.
	void handleData(VideoData data) => feeds[data.name]!.mergeFromMessage(data);

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

	/// Tells the rover to enable the given camera.
	Future<void> updateCamera(CameraName name, CameraDetails details) async { 
		final details = feeds[name]?.details.deepCopy() ?? CameraDetails();
		final command = VideoCommand(name: name, details: details);
		services.videoSocket.sendMessage(command);
	}

	/// Replaces a video feed in the UI.
	void replaceFeed(int index, CameraName name) {
		feedsOnScreen[index] = name;
		notifyListeners();
	}
}
