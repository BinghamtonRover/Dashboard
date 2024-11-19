import "dart:async";
import "dart:ui";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:just_audio/just_audio.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";

/// Represents the state of a cell on the autonomy map.
enum AutonomyCell {
	/// This is where the rover currently is.
	rover,
	/// This is where the rover is trying to go.
	destination,
	/// This cell has an obstacle the rover needs to avoid.
	obstacle,
	/// This cell is along the rover's path to its destination.
	path,
	/// This cell is traversable but otherwise not of interest.
	empty,
	/// THis cell was manually marked as a point of interest.
	marker,
}

/// Like an [Offset] from Flutter, but using integers instead of doubles.
///
/// This is used to represent an offset from a position in a grid. Since the grid is represented
/// as a 2D list, the x and y coordinates must be integers to act as indexes. Use this class to
/// keep the rover centered in the UI.
class GridOffset {
	/// The X offset.
	final int x;
	/// The Y offset.
	final int y;
	/// A const constructor.
	const GridOffset(this.x, this.y);
}

extension _GpsCoordinatesToBlock on GpsCoordinates {
  GpsCoordinates get toGridBlock => GpsCoordinates(
        latitude:
            (latitude / models.settings.dashboard.mapBlockSize).roundToDouble(),
        longitude:
            (longitude / models.settings.dashboard.mapBlockSize).roundToDouble(),
      );
}

/// A record representing data necessary to display a cell in the map
typedef MapCellData = ({GpsCoordinates coordinates, AutonomyCell cellType});

/// A 2D array of [MapCellData] to represent a coordinate grid
typedef AutonomyGrid = List<List<MapCellData>>;

/// A view model for the autonomy page to render a grid map.
///
/// Shows a bird's-eye map of where the rover is, what's around it, where the goal is, and the path
/// to get there. This class uses [AutonomyData] to keep track of the data as reported by the rover.
/// The [grid] is a 2D map of width and height [gridSize] that keeps the [roverPosition] in the
/// center (by keeping track of its [offset]) and filling the other cells with [AutonomyCell]s.
///
class AutonomyModel with ChangeNotifier {
	/// The amount of blocks in the width and height of the grid.
	///
	/// Keep this an odd number to keep the rover in the center.
	int gridSize = 11;

	/// The offset to add to all other coordinates, based on [roverPosition]. See [recenterRover].
	GridOffset offset = const GridOffset(0, 0);

	/// Listens for incoming autonomy or position data.
	AutonomyModel() { init(); }

  StreamSubscription<AutonomyData>? _subscription;

  /// Initializes the view model.
  Future<void> init() async {
		recenterRover();
    await Future<void>.delayed(const Duration(seconds: 1));
		_subscription = models.messages.stream.onMessage<AutonomyData>(
			name: AutonomyData().messageName,
			constructor: AutonomyData.fromBuffer,
			callback: onNewData,
		);
		models.rover.metrics.position.addListener(recenterRover);
    models.settings.addListener(notifyListeners);
		// Force the initial update, even with no new data.
		recenterRover();
		onNewData(AutonomyData());
	}

	@override
	void dispose() {
    _subscription?.cancel();
		models.settings.removeListener(notifyListeners);
		models.rover.metrics.position.removeListener(recenterRover);
    badAppleAudioPlayer.dispose();
		super.dispose();
	}

	/// An empty grid of size [gridSize].
  AutonomyGrid get empty => [
        for (int i = 0; i < gridSize; i++)
          [
            for (int j = 0; j < gridSize; j++)
              (
                coordinates: GpsCoordinates(
                  longitude: (-j.toDouble() + offset.x) *
                      models.settings.dashboard.mapBlockSize,
                  latitude: (i.toDouble() - offset.y) *
                      models.settings.dashboard.mapBlockSize,
                ),
                cellType: AutonomyCell.empty
              ),
          ],
      ];

	/// A list of markers manually placed by the user. Useful for the Extreme Retrieval Mission.
	List<GpsCoordinates> markers = [];
	/// The view model to edit the coordinate of the marker.
	GpsBuilder markerBuilder = GpsBuilder();

	/// The rover's current position.
	GpsCoordinates get roverPosition => models.rover.metrics.position.data.gps;

  /// The cell type of the rover that isn't [AutonomyCell.rover]
  AutonomyCell get roverCellType {
    final roverCoordinates = roverPosition.toGridBlock;

    if (data.hasDestination() && data.destination.toGridBlock == roverCoordinates) {
      return AutonomyCell.destination;
    } else if (markers.any((e) => e.toGridBlock == roverCoordinates)) {
      return AutonomyCell.marker;
    } else if (data.path.map((e) => e.toGridBlock).contains(roverCoordinates.toGridBlock)) {
      return AutonomyCell.path;
    }

    return AutonomyCell.empty;
  }

  /// The rover's heading
  double get roverHeading => models.rover.metrics.position.angle;

	/// The autonomy data as received from the rover.
	AutonomyData data = AutonomyData();

	/// The grid of size [gridSize] with the rover in the center, ready to draw on the UI.
	AutonomyGrid get grid {
		final result = empty;
		for (final obstacle in data.obstacles) {
			markCell(result, obstacle, AutonomyCell.obstacle);
		}
    if (isPlayingBadApple) return result;
    for (final path in data.path) {
      if (!data.obstacles.contains(path)) {
        markCell(result, path, AutonomyCell.path);
      }
    }
		for (final marker in markers) {
      if (!data.obstacles.contains(marker)) {
        markCell(result, marker, AutonomyCell.marker);
      }
		}
    // Marks the rover and destination -- these should be last
    if (data.hasDestination()) markCell(result, data.destination, AutonomyCell.destination);
		markCell(result, roverPosition, AutonomyCell.rover);
		return result;
	}

	/// Converts a decimal GPS coordinate to an index representing the block in the grid.
	int gpsToBlock(double value) => (value / models.settings.dashboard.mapBlockSize).round();

	/// Calculates a new position for [gps] based on [offset] and adds it to the [grid].
	///
	/// This function filters out any coordinates that shouldn't be shown based on [gridSize].
	void markCell(AutonomyGrid grid, GpsCoordinates gps, AutonomyCell value) {
		// Latitude is y-axis, longitude is x-axis
		// The rover will occupy the center of the grid, so
		// - rover.longitude => (gridSize - 1) / 2
		// - rover.latitude => (gridSize - 1) / 2
		// Then, everything else should be offset by that
		final x = -1 * gpsToBlock(gps.longitude) + offset.x;
		final y = gpsToBlock(gps.latitude) + offset.y;
		if (x < 0 || x >= gridSize) return;
		if (y < 0 || y >= gridSize) return;
		grid[y][x] = (coordinates: gps, cellType: value);
	}

	/// Determines the new [offset] based on the current [roverPosition].
	///
	/// The autonomy grid is inherently unbounded, meaning we have to choose *somewhere* to bound the
	/// grid. We chose to draw a grid of size [gridSize] with the rover in the center. This means we
	/// need to add an offset to every other coordinates to draw it relative to the rover on-screen.
	///
	/// For example, say the rover is at `(2, 3)`, and there is an obstacle at `(1, 2)`, with a grid
	/// size of `11`. The rover should be at the center, `(5, 5)`, so we need to add an offset of
	/// `(3, 2)` to get it there. That means we should also add `(3, 2)` to the obstacle's position
	/// so it remains `(-1, -1)` away from the rover's new position, yielding `(4, 4)`.
	void recenterRover() {
    // final position = isPlayingBadApple ? GpsCoordinates() : roverPosition;
    final position = isPlayingBadApple ? GpsCoordinates(latitude: (gridSize ~/ 2).toDouble(), longitude: (gridSize ~/ 2).toDouble()) : roverPosition;
		final midpoint = ((gridSize - 1) / 2).floor();
		final offsetX = midpoint - -1 * gpsToBlock(position.longitude);
		final offsetY = midpoint - gpsToBlock(position.latitude);
		offset = GridOffset(offsetX, offsetY);
		notifyListeners();
	}

	/// Zooms in or out by modifying [gridSize].
	void zoom(int newSize) {
		gridSize = newSize;
		recenterRover();
	}

	/// A handler to call when new data arrives. Updates [data] and the UI.
	void onNewData(AutonomyData value) {
    if (!isPlayingBadApple) {
      data = value;
    }
		services.files.logData(value);
		notifyListeners();
	}

	/// Places the marker at [coordinates].
	void placeMarker(GpsCoordinates coordinates) {
		markers.add(coordinates.deepCopy());
		notifyListeners();
	}

  /// Places a marker at the rover's current position.
  void placeMarkerOnRover() {
    if (!markers.any((e) => e.toGridBlock == roverPosition.toGridBlock)) {
      placeMarker(roverPosition);
    }
  }

  /// Removes a marker from [gps]
	void removeMarker(GpsCoordinates gps) {
		if (markers.remove(gps)) {
		  notifyListeners();
    } else {
      models.home.setMessage(severity: Severity.info, text: "Marker not found");
    }
	}

	/// Deletes all the markers in [markers].
	void clearMarkers() {
		markers.clear();
		markerBuilder.clear();
		notifyListeners();
	}

  /// Builder for autonomy commands
  final AutonomyCommandBuilder commandBuilder = AutonomyCommandBuilder();

  /// Adds or removes a marker at the given location.
  void toggleMarker(MapCellData cell) {
    if (markers.contains(cell.coordinates)) {
      removeMarker(cell.coordinates);
    } else {
      placeMarker(cell.coordinates);
    }
  }

  /// Handles when a specific tile was dropped onto a grid cell.
  ///
  /// - If it's a destination tile, then the rover will go there
  /// - If it's an obstacle tile, the rover will avoid it
  /// - If it's a marker tile, draws or removes a Dashboard marker
  void handleDrag(AutonomyCell data, MapCellData cell) {
    switch (data) {
      case AutonomyCell.destination:
        if (models.rover.isConnected && RoverStatus.AUTONOMOUS != models.rover.status.value) {
          models.home.setMessage(severity: Severity.error, text: "You must be in autonomy mode");
          return;
        }
        commandBuilder.gps.latDecimal.value = cell.coordinates.latitude;
        commandBuilder.gps.longDecimal.value = cell.coordinates.longitude;
        commandBuilder.submit();
      case AutonomyCell.obstacle:
        final obstacleData = AutonomyData(obstacles: [cell.coordinates]);
        models.sockets.autonomy.sendMessage(obstacleData);
      case AutonomyCell.marker: toggleMarker(cell);
      case AutonomyCell.rover: break;
      case AutonomyCell.path: break;
      case AutonomyCell.empty: break;
    }
  }

  // ==================== Bad Apple Easter Egg ====================
  //
  // This Easter Egg renders the Bad Apple video in the map page by grabbing
  // each frame and assigning an obstacle to each black pixel.

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
