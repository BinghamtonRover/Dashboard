import "dart:async";

import "package:flutter/foundation.dart";
import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:burt_network/burt_network.dart";

/// A view model for the Lidar page
/// 
/// Streams incoming [LidarPointCloud] messages from video to update the corresponding view
class LidarViewModel with ChangeNotifier {
  /// The last received coordinates from the incoming lidar data
  List<LidarCartesianPoint>? coordinates;

  StreamSubscription<LidarPointCloud>? _subscription;

  /// Const constructor for the lidar model
  LidarViewModel() {
    init();
  }

  /// Initializes the lidar view mode.
  void init() {
    _subscription = models.messages.stream.onMessage<LidarPointCloud>(
      name: LidarPointCloud().messageName,
      constructor: LidarPointCloud.fromBuffer,
      callback: handleData,
    );
  }

  @override
  void dispose() { 
    _subscription?.cancel();
    super.dispose();
  }

  /// Handles incoming lidar data
  void handleData(LidarPointCloud newPointCloud) {
    if (newPointCloud.cartesian.isNotEmpty) {
      coordinates = newPointCloud.cartesian;
      notifyListeners();
    }
  }
}
