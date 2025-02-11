

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

  void handleData(LidarPointCloud pointCloud) {
    this.pointCloud = pointCloud;
    print("GOT dATA");
    notifyListeners();
  }
}
