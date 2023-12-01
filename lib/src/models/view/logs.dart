import "package:flutter/foundation.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

class LogsViewModel with ChangeNotifier {
  Device? deviceFilter;
  BurtLogLevel? levelFilter;

  void setDeviceFilter(Device? input) {
    deviceFilter = input;
    notifyListeners();
  }

  void setLevelFilter(BurtLogLevel? input) {
    levelFilter = input;
    notifyListeners();
  }

  List<BurtLog> get logs {
    final result = <BurtLog>[];
    for (final log in models.logs.allLogs) {
      if (deviceFilter != null && log.device != deviceFilter) continue;
      if (levelFilter != null && log.level.value > levelFilter!.value) continue;
      result.add(log);
    }
    return result;
  }

  void resetDevice(Device device) {
    print("Resetting device... $device");
    // Todo: Implement
  }
}
