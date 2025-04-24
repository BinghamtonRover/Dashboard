import "dart:async";
import "dart:ui";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:just_audio/just_audio.dart";
import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// The Bad Apple Easter Egg.
///
/// This Easter Egg renders the Bad Apple video in the map page by grabbing
/// each frame and assigning an obstacle to each black pixel.
mixin BadAppleViewModel on ChangeNotifier {
  /// Whether the UI is currently playing Bad Apple
  bool isPlayingBadApple = false;

  /// Which frame in the Bad Apple video we are up to right now
  int badAppleFrame = 0;

  /// The zoom of the map before playing bad apple
  late int _originalZoom = gridSize;

  /// The audio player for the Bad Apple music
  final badAppleAudioPlayer = AudioPlayer();

  /// How many frames in a second are being shown
  static const badAppleFps = 1;

  /// The last frame of Bad Apple
  static const badAppleLastFrame = 6570;

  /// A stopwatch to track the current time in the bad apple video
  final Stopwatch _badAppleStopwatch = Stopwatch();

  /// Cleans up any resources used by Bad Apple.
  void disposeBadApple() => badAppleAudioPlayer.dispose();

	/// The amount of blocks in the width and height of the grid.
	///
	/// Keep this an odd number to keep the rover in the center.
  int get gridSize;

  /// Sets the zoom of the map.
  void zoom(int newSize);

  /// Sets the grid data of the map.
  set data(AutonomyData value);

  /// Starts playing Bad Apple.
  Future<void> startBadApple() async {
    isPlayingBadApple = true;
    notifyListeners();
    _originalZoom = gridSize;
    zoom(50);
    badAppleFrame = 0;
    Timer.run(() async {
      await badAppleAudioPlayer.setAsset("assets/bad_apple2.mp3", preload: false);
      badAppleAudioPlayer.play().ignore();
      _badAppleStopwatch.start();
    });

    while (isPlayingBadApple) {
      await Future<void>.delayed(Duration.zero);
      var sampleTime = _badAppleStopwatch.elapsed;
      if (badAppleAudioPlayer.position != Duration.zero) {
        sampleTime = badAppleAudioPlayer.position;
      }
      badAppleFrame = ((sampleTime.inMicroseconds.toDouble() / 1e6) * 30.0).round();
      if (badAppleFrame >= badAppleLastFrame) {
        stopBadApple();
        break;
      }
      final obstacles = await _loadBadAppleFrame(badAppleFrame);
      if (obstacles == null) {
        continue;
      }
      if (!isPlayingBadApple) {
        break;
      }
      data = AutonomyData(obstacles: obstacles);
      notifyListeners();
    }
  }

  Future<List<GpsCoordinates>?> _loadBadAppleFrame(int videoFrame) async {
    // final filename = "assets/bad_apple/image_480.jpg";
    final filename = "assets/bad_apple/image_$videoFrame.jpg";
    final buffer = await rootBundle.loadBuffer(filename);
    final codec = await instantiateImageCodecWithSize(buffer);
    final frame = await codec.getNextFrame();
    final image = frame.image;
    if (image.height != 50 || image.width != 50) {
      models.home.setMessage(severity: Severity.error, text: "Wrong Bad Apple frame size");
      stopBadApple();
      return null;
    }
    final imageData = await image.toByteData();
    if (imageData == null) {
      models.home.setMessage(severity: Severity.error, text: "Could not load Bad Apple frame");
      stopBadApple();
      return null;
    }
    var offset = 0;
    final obstacles = <GpsCoordinates>[];
    for (var row = 0; row < image.height; row++) {
      for (var col = 0; col < image.width; col++) {
        final pixel = imageData.getUint8(offset++);
        imageData.getUint8(offset++);
        imageData.getUint8(offset++);
        imageData.getUint8(offset++);
        final isBlack = pixel < 100;  // dealing with lossy compression, not 255 and 0
        final coordinate = GpsCoordinates(latitude: (row - image.height).abs().toDouble(), longitude: (image.width - col - 1).abs().toDouble());
        if (isBlack) obstacles.add(coordinate);
      }
    }
    if (!isPlayingBadApple) {
      return null;
    }
    return obstacles;
  }

  /// Stops playing Bad Apple and resets the UI.
  void stopBadApple() {
    isPlayingBadApple = false;
    data = AutonomyData();
    badAppleAudioPlayer.stop();
    _badAppleStopwatch.stop();
    _badAppleStopwatch.reset();
    zoom(_originalZoom);
    notifyListeners();
  }
}
