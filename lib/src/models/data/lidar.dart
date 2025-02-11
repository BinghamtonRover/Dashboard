import "dart:math";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:burt_network/burt_network.dart";

class LidarModel extends Model {
  LidarPointCloud? pointCloud;

  @override
  Future<void> init() async {
    print("INIT");
		models.messages.stream.onMessage<LidarPointCloud>(
			name: LidarPointCloud().messageName,
			constructor: LidarPointCloud.fromBuffer,
			callback: handleData,
		);
	}

  void handleData(LidarPointCloud newPointCloud) {
    pointCloud = newPointCloud;
    print("GOT dATA");
    notifyListeners();
  }

  void addFakeData(){
    pointCloud = LidarPointCloud(
      cartesian: [
        for (int i = 0; i < 100; i++)
          LidarCartesianPoint(
            x: Random().nextDouble() * 2,
            y: Random().nextDouble() * 2,
          )
      ]
    );
    notifyListeners();
  }
}
