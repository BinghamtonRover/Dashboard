import "package:rover_dashboard/data.dart";

import "model.dart";

/// list of the camera feeds
final feeds = [
	CameraFeed(name: "Science", pageTypes: [OperatingMode.science]),
	CameraFeed(name: "Microscope", pageTypes: [OperatingMode.science]), 
	CameraFeed(name: "Rover 1"),
	CameraFeed(name: "Rover 2"), 
	CameraFeed(name: "Arm 1", pageTypes: [OperatingMode.arm]), 
	CameraFeed(name: "Arm 2", pageTypes: [OperatingMode.arm]), 
	CameraFeed(name: "Autonomy", pageTypes: [OperatingMode.autonomy]),
];

/// A data model to stream video from the rover.
class VideoModel extends Model {
	CameraFeed? _pinnedFeed = feeds.first;

	@override
	Future<void> init() async {
		// TODO: Establish link with the rover and stream video
	}

	/// The pinned video feed. 
	CameraFeed? get pinnedFeed => _pinnedFeed;
	set pinnedFeed(CameraFeed? feed) {
		_pinnedFeed = feed;
		notifyListeners();
	}

	/// Gets the video feeds that should be shown for a given page. 
	List<CameraFeed> getFeedsForPage(OperatingMode mode) => [
		for (final CameraFeed feed in feeds) 
			if (feed.pageTypes.contains(mode)) 
				feed
	];

	/// Toggles a video feed on or off. 
	void toggleFeed(CameraFeed? feed) {
		if (feed == null) return;  // user cancelled action
		if (feed.isActive) {  
			// turn off the camera 
			feed.isActive = false;
			if (feed == pinnedFeed) pinnedFeed = null;
		} else {
			// turn on the camera
			feed.isActive = true;
		}
		notifyListeners();
	}
}
