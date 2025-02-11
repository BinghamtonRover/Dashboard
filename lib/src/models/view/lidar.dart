import "dart:math";

import "package:flutter/foundation.dart";
import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:burt_network/burt_network.dart";

class LidarModel with ChangeNotifier {
  List<LidarCartesianPoint>? coordinates;

  @override
  LidarModel() {
		models.messages.stream.onMessage<LidarPointCloud>(
			name: LidarPointCloud().messageName,
			constructor: LidarPointCloud.fromBuffer,
			callback: handleData,
		);
	}

  void handleData(LidarPointCloud newPointCloud) {
    coordinates = newPointCloud.cartesian;
    double minx = 9999;
    double maxx = -9999;
    double miny = 9999;
    double maxy = -9999;
    for (LidarCartesianPoint point in coordinates!) {
      minx = min(minx, point.x);
      maxx = max(maxx, point.x);
      miny = min(miny, point.y);
      maxy = max(maxy, point.y);
    }
    print("minx: $minx, maxx: $maxx, miny: $miny, maxy: $maxy");
    notifyListeners();
  }

  // void addFakeData(){
  //   pointCloud = LidarPointCloud(
  //     cartesian: [
  //       for (int i = 0; i < 100; i++)
  //         LidarCartesianPoint(
  //           x: Random().nextDouble() * 2,
  //           y: Random().nextDouble() * 2,
  //         )
  //     ]
  //   );
  //   notifyListeners();
  // }
}
