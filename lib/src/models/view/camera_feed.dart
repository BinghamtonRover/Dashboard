/// Camera Feed Class
class CameraFeed {
  /// complete name of the camera feed ex "Science Video Feed"
  final String fullName;
  /// shortened name of the camera feed ex "Science"
  final String shortName;
  /// the page that the video feed will appear on
  final int page;
  /// boolean value of whether or not this particular camera feed is pinned
  bool pinned;
  /// boolean value of whether or not this particular camera feed is showing
  bool showing;

  /// CameraFeed constructor
  CameraFeed(this.fullName, this.shortName, this.page, {this.pinned = false, this.showing = true});
  
}