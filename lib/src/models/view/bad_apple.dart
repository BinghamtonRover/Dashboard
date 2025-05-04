import "dart:async";

import "package:archive/archive.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:image/image.dart";
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

  /// The decompressed archive of the bad apple images
  Archive? imagesArchive;

  /// Cleans up any resources used by Bad Apple.
  void disposeBadApple() {
    badAppleAudioPlayer.dispose();
    imagesArchive?.clear();
    imagesArchive = null;
  }

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
    final zipBytes = await rootBundle.load("assets/bad_apple.zip");
    imagesArchive = ZipDecoder().decodeBytes(zipBytes.buffer.asUint8List());

    isPlayingBadApple = true;
    notifyListeners();
    _originalZoom = gridSize;
    zoom(50);
    badAppleFrame = 0;
    Timer.run(() async {
      await badAppleAudioPlayer.setAsset(
        "assets/bad_apple2.mp3",
        preload: false,
      );
      badAppleAudioPlayer.play().ignore();
      _badAppleStopwatch.start();
    });

    while (isPlayingBadApple) {
      await Future<void>.delayed(Duration.zero);
      var sampleTime = _badAppleStopwatch.elapsed;
      if (badAppleAudioPlayer.position != Duration.zero) {
        sampleTime = badAppleAudioPlayer.position;
      }
      badAppleFrame =
          ((sampleTime.inMicroseconds.toDouble() / 1e6) * 30.0).round();
      if (badAppleFrame >= badAppleLastFrame || imagesArchive == null) {
        stopBadApple();
        break;
      }
      final obstacles = _loadBadAppleFrame(imagesArchive!, badAppleFrame);
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

  List<GpsCoordinates>? _loadBadAppleFrame(Archive archive, int videoFrame) {
    final filename = "image_$videoFrame.jpg";
    final buffer =
        archive.files.firstWhere((file) => file.name == filename).readBytes();
    if (buffer == null) {
      return null;
    }
    final imageData = decodeJpg(buffer);
    if (imageData == null) {
      models.home.setMessage(
        severity: Severity.error,
        text: "Could not load Bad Apple frame",
      );
      stopBadApple();
      return null;
    }
    if (imageData.height != 50 || imageData.width != 50) {
      models.home.setMessage(
        severity: Severity.error,
        text: "Wrong Bad Apple frame size",
      );
      stopBadApple();
      return null;
    }
    final obstacles = <GpsCoordinates>[];
    for (final pixel in imageData) {
      // dealing with lossy compression, not 255 and 0
      final isBlack = pixel.luminance < 100;
      final coordinate = GpsCoordinates(
        latitude: (pixel.y - imageData.height).abs().toDouble(),
        longitude: (imageData.width - pixel.x - 1).abs().toDouble(),
      );
      if (isBlack) obstacles.add(coordinate);
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
    imagesArchive?.clear();
    imagesArchive = null;
    zoom(_originalZoom);
    notifyListeners();
  }
}
