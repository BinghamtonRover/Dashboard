import "package:flutter/material.dart";

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
	AutonomyModel() {
		models.messages.registerHandler<AutonomyData>(
			name: AutonomyData().messageName,
			decoder: AutonomyData.fromBuffer,
			handler: onNewData, 
		);
		models.rover.metrics.position.addListener(recenterRover);
		// Force the initial update, even with no new data.
		recenterRover();
		onNewData(AutonomyData());
	}

	@override
	void dispose() {
		models.messages.removeHandler(AutonomyData().messageName);
		models.rover.metrics.position.removeListener(recenterRover);
		super.dispose();
	}

	/// An empty grid of size [gridSize].
	List<List<AutonomyCell>> get empty => [
		for (int i = 0; i < gridSize; i++) [
			for (int j = 0; j < gridSize; j++) 
				AutonomyCell.empty,
		],
	];

	/// A list of markers manually placed by the user. Useful for the Extreme Retrieval Mission.
	List<GpsCoordinates> markers = [];
	/// The view model to edit the coordinate of the marker.
	GpsBuilder markerBuilder = GpsBuilder();

	/// The rover's current position.
	GpsCoordinates get roverPosition => models.rover.metrics.position.data.gps;

	/// The autonomy data as received from the rover.
	AutonomyData data = AutonomyData();

	/// The grid of size [gridSize] with the rover in the center, ready to draw on the UI.
	List<List<AutonomyCell>> get grid {
		final result = empty;
		for (final obstacle in data.obstacles) {
			markCell(result, obstacle, AutonomyCell.obstacle);
		}
		for (final path in data.path) {
			markCell(result, path, AutonomyCell.path);
		}
		for (final marker in markers) {
			markCell(result, marker, AutonomyCell.marker);
		}
    // Marks the rover and destination -- these should be last
		markCell(result, data.destination, AutonomyCell.destination);
		markCell(result, roverPosition, AutonomyCell.rover);	
		return result;
	}

	/// Converts a decimal GPS coordinate to an index representing the block in the grid.
	int gpsToBlock(double value) => (value / models.settings.autonomy.blockSize).round();

	/// Calculates a new position for [gps] based on [offset] and adds it to the [list].
	/// 
	/// This function filters out any coordinates that shouldn't be shown based on [gridSize].
	void markCell(List<List<AutonomyCell>> list, GpsCoordinates gps, AutonomyCell value) {
		// Latitude is y-axis, longitude is x-axis
		// The rover will occupy the center of the grid, so
		// - rover.longitude => (gridSize - 1) / 2
		// - rover.latitude => (gridSize - 1) / 2
		// Then, everything else should be offset by that
		final x = gpsToBlock(gps.longitude) + offset.x;
		final y = gpsToBlock(gps.latitude) + offset.y;
		if (x < 0 || x >= gridSize) return;
		if (y < 0 || y >= gridSize) return;
		list[y][x] = value;
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
		final midpoint = ((gridSize - 1) / 2).floor();
		final offsetX = midpoint - gpsToBlock(roverPosition.longitude);
		final offsetY = midpoint - gpsToBlock(roverPosition.latitude);
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
		data.mergeFromMessage(value);
		services.files.logData(value);
		notifyListeners();
	}

	/// Places the marker in [markerBuilder].
	void placeMarker() {
		markers.add(markerBuilder.value);
		markerBuilder.clear();
		notifyListeners();
	}

	/// Deletes all the markers in [markers].
	void clearMarkers() {
		markers.clear();
		markerBuilder.clear();
		notifyListeners();
	}
}
