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

  Iterable<BurtLog> get logs sync* {
    for (final log in models.logs.allLogs) {
      if (deviceFilter != null && log.device != deviceFilter) continue;
      if (levelFilter != null && log.level.value > levelFilter!.value) continue;
      yield log;
    }
  }
}
