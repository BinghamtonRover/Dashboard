import "package:flutter/material.dart";

/// A view model to edit the settings of a video feed
class VideoFeedSettings extends ChangeNotifier {
  bool _isOpened = false;
  double _zoom = 100;
  double _pan = 0;
  double _tilt = 0;
  double _focus = 0;
  bool _autofocus = true;

  /// Constructor the video feed settings, initializes any fields
  /// that are provided and in a valid range
  VideoFeedSettings({
    double? zoom,
    double? pan,
    double? tilt,
    double? focus,
    bool? autofocus,
  }) {
    if (zoom != null) _zoom = zoom.clamp(100, 800);
    if (pan != null) _pan = pan.clamp(-180, 180);
    if (tilt != null) _tilt = tilt.clamp(-180, 180);
    if (focus != null) _focus = focus.clamp(0, 255);
    if (autofocus != null) _autofocus = autofocus;
  }

  /// Checks if the current slider for video camera is open
  bool get isOpened => _isOpened;

  set isOpened(bool value) {
    _isOpened = value;
    notifyListeners();
  }

  /// The zoom level. Camera-specific.
  double get zoom => _zoom;

  /// The zoom level. Camera-specific.
  set zoom(double value) {
    _zoom = value;
    notifyListeners();
  }

  /// The pan level, when zoomed in.
  double get pan => _pan;

  /// The pan level, when zoomed in.
  set pan(double value) {
    _pan = value;
    notifyListeners();
  }

  /// The tilt level, when zoomed in
  double get tilt => _tilt;

  /// The tilt level, when zoomed in.
  set tilt(double value) {
    _tilt = value;
    notifyListeners();
  }

  /// The focus level, if autofocus is disabled.
  double get focus => _focus;

  /// The focus level, if autofocus is disabled.
  set focus(double value) {
    _focus = value;
    notifyListeners();
  }

  /// Whether the camera should autofocus.
  bool get autofocus => _autofocus;

  /// Whether the camera should autofocus.
  set autofocus(bool value) {
    _autofocus = value;
    notifyListeners();
  }
}
