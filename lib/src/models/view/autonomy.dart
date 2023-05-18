import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/pages.dart";

class AutonomyModel with ChangeNotifier {
	static const blockSize = 1;

	int gridSize = 11;  // choose an odd number
	GridOffset offset = GridOffset(0, 0);
	AutonomyData data = AutonomyData(
		state: AutonomyState.PATHING,
		task: AutonomyTask.VISUAL_MARKER,
		destination: GpsCoordinates(latitude: 525, longitude: 435),
		obstacles: [  // an L shape
			GpsCoordinates(latitude: 525, longitude: 434),
			GpsCoordinates(latitude: 525, longitude: 433),
			GpsCoordinates(latitude: 524, longitude: 434),
		],
		path: [
			GpsCoordinates(latitude: 523, longitude: 433),
			GpsCoordinates(latitude: 523, longitude: 434),
			GpsCoordinates(latitude: 523, longitude: 435),
			GpsCoordinates(latitude: 524, longitude: 435),
		],
	);

	int gpsToBlock(double value) => (value / blockSize).round();

	List<List<AutonomyCell>> get empty => [
		for (int i = 0; i < gridSize; i++) [
			for (int j = 0; j < gridSize; j++) 
				AutonomyCell.empty
		]
	];

	void calculateOffset() {
		// final GpsCoordinates roverGps = models.rover.metrics.position.data.gps;
		print("Remove this ^");
		final int midpoint = ((gridSize - 1) / 2).floor();
		final int offsetX = midpoint - gpsToBlock(roverGps.longitude);
		final int offsetY = midpoint - gpsToBlock(roverGps.latitude);
		grid = empty;
		offset = GridOffset(offsetX, offsetY);
		notifyListeners();
	}

	AutonomyModel() {
		models.sockets.data.registerHandler<AutonomyData>(
			name: AutonomyData().messageName,
			decoder: AutonomyData.fromBuffer,
			handler: onNewData, 
		);
		models.rover.metrics.addListener(calculateOffset);
		calculateOffset();
		onNewData(AutonomyData());
	}

	@override
	void dispose() {
		models.sockets.data.removeHandler(AutonomyData().messageName);
		models.rover.metrics.removeListener(calculateOffset);
		super.dispose();
	}

	void zoom(int newSize) {
		gridSize = newSize;
		calculateOffset();
		onNewData(AutonomyData());
		notifyListeners();
	}

	List<List<AutonomyCell>> grid = [];

	void markCell(GpsCoordinates gps, AutonomyCell value) {
		// Latitude is y-axis, longitude is x-axis
		// The rover will occupy the center of the grid, so
		// - rover.longitude => (gridSize - 1) / 2
		// - rover.latitude => (gridSize - 1) / 2
		// Then, everything else should be offset by that
		// Eg, the rover is at (2, 3) and an obstacle at (1, 2)
		// - rover => (5, 5), so we add 3 to the longitude and 2 to the latitude
		// - so, the obstacle should be painted at (4, 4)
		final int x = gpsToBlock(gps.longitude) + offset.x;
		final int y = gpsToBlock(gps.latitude) + offset.y;
		if (x < 0 || x >= gridSize) return;
		if (y < 0 || y >= gridSize) return;
		grid[y][x] = value;
	}

	GpsCoordinates get roverGps => 
		GpsCoordinates(latitude: 523, longitude: 432);
	// models.rover.metrics.position.data.gps;

	void onNewData(AutonomyData value) {
		data.mergeFromMessage(value);
		grid = empty;	
		markCell(roverGps, AutonomyCell.rover);	
		markCell(data.destination, AutonomyCell.destination);
		for (final obstacle in data.obstacles) {
			markCell(obstacle, AutonomyCell.obstacle);
		}
		for (final path in data.path) {
			markCell(path, AutonomyCell.path);
		}
		notifyListeners();
	}
}
