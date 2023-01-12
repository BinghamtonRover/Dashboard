import "modes.dart";

/// Metadata about a camera feed. 
class CameraFeed {
  /// The name of this feed.
  final String name;

  /// The page(s) that this feed should appear on.
  /// 
  /// The user can still enable/disable which pages the feeds appear on, 
  /// but these are some reasonable presets. 
  /// 
  /// TODO: Look to move these to Settings.
  final List<OperatingMode> pageTypes;

  /// Whether or not this feed is currently showing.
  bool isActive;

  /// Stores metadata about a camera feed. 
  CameraFeed({
    required this.name, 
    this.pageTypes = const [], 
    this.isActive = true
  });  
}
