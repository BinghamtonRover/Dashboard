import "dart:async";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";

import "model.dart";

/// A data model to stream video from the rover.
class VideoModel extends Model {
	/// list of the camera feeds
	static final allFeeds = [
		CameraFeed(id: CameraName.SCIENCE_CAROUSEL, name: "Science"),
		CameraFeed(id: CameraName.SCIENCE_MICROSCOPE, name: "Microscope"), 
		CameraFeed(id: CameraName.ROVER_FRONT, name: "Rover 1"),
		CameraFeed(id: CameraName.ROVER_REAR, name: "Rover 2"), 
		CameraFeed(id: CameraName.ARM_BASE, name: "Arm 1"), 
		CameraFeed(id: CameraName.ARM_GRIPPER, name: "Arm 2"), 
	];

	/// The current layout of video feeds.
	Map<OperatingMode, List<CameraFeed?>> userLayout = {
		OperatingMode.science: [allFeeds[0], allFeeds[1], allFeeds[2], allFeeds[3]],
		OperatingMode.arm: [allFeeds[4], allFeeds[5], allFeeds[2], allFeeds[3]],
		OperatingMode.autonomy: [allFeeds[2], allFeeds[3]],
		OperatingMode.drive: [allFeeds[2], allFeeds[3]],
	};

	/// The camera feeds for the current operating mode.
	List<CameraFeed?> get feeds => userLayout[models.home.mode]!;

	late final Timer updater;

	@override
	Future<void> init() async {
		// TODO: Establish link with the rover and stream video
		services.videoStreamer.registerHandler<VideoFrame>(
			name: VideoFrame().messageName,
			decoder: VideoFrame.fromBuffer,
			handler: updateFrame,
		);
		updater = Timer.periodic(const Duration(milliseconds: 500), (_) => notifyListeners());
		// TODO: Read the layout from Settings
		models.home.addListener(notifyListeners);
	}

	@override
	void dispose() {
		models.home.removeListener(notifyListeners);
		updater.cancel();
		super.dispose();
	}

	void updateFrame(VideoFrame message) {
		final feed = getCameraFeed(message.name);
		feed.isConnected = true;
		feed.isActive = true;
		feed.frame = message.frame;
	}

	/// Adds or subtracts a number of camera feeds to/from the UI
	void setNumFeeds(int? value) {
		final mode = models.home.mode;
		if (value == null || value > 4 || value < 1) return;
		final int currentNum = userLayout[mode]!.length;
		if (value < currentNum) {
			userLayout[mode] = userLayout[mode]!.sublist(0, value);
		} else {
			for (int i = currentNum; i < value; i++) {
				userLayout[mode]!.add(null);
			}
		}
		notifyListeners();
	}

	/// Gets the camera feed with the given ID.
	CameraFeed getCameraFeed(CameraName id) => allFeeds.firstWhere((feed) => feed.id == id);

	/// Toggles a video feed on or off. 
	void toggleFeed(CameraFeed? feed) {
		if (feed == null) return;  // user cancelled action
		if (feed.isActive) {  
			// TODO: turn off the camera 
			feed.isActive = false;
		} else {
			// TODO: turn on the camera
			feed.isActive = true;
		}
		notifyListeners();
	}

	/// Replaces a video feed at a given index.
	void selectNewFeed(int index, CameraFeed feed) {
		userLayout[models.home.mode]![index] = feed;
		notifyListeners();
	}
}
