import "package:flutter/material.dart";

/// A view model for autonomy mode.
class AutonomyModel with ChangeNotifier {
	/// The name of this feed.
  final String name = "Autonomy";

  /// Whether or not this feed is currently showing.
  bool isActive = false;

  /// Whether it is possible to enable this camera.
  bool isConnected = false;

  /// The current image frame, as a JPG buffer.
  List<int>? frame;

  /// Stores metadata about a camera feed. 
  AutonomyModel(); 	
}
