import "package:rover_dashboard/data.dart";

/// Metadata about a camera feed. 
class CameraFeed {
  /// The name of this feed.
  final String name;

  /// The ID of the camera.
  final CameraName id;

  /// Whether or not this feed is currently showing.
  bool isActive = false;

  /// Whether it is possible to enable this camera.
  bool isConnected = false;

  /// The current image frame, as a JPG buffer.
  List<int>? frame;

  /// Stores metadata about a camera feed. 
  CameraFeed({
    required this.name, 
    required this.id,
  });  
}
