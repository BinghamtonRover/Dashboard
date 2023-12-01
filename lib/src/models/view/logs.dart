import "package:flutter/foundation.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

class LogsViewModel with ChangeNotifier {
  Device? deviceFilter;
  BurtLogLevel levelFilter = BurtLogLevel.info;

  LogsViewModel() {
    models.logs.addListener(notifyListeners);
  }

  @override
  void dispose() {
    models.logs.removeListener(notifyListeners);
    super.dispose();
  }

  void setDeviceFilter(Device? input) {
    deviceFilter = input;
    notifyListeners();
  }

  void setLevelFilter(BurtLogLevel? input) {
    if (input == null) return;
    levelFilter = input;
    notifyListeners();
  }

  List<BurtLog> get logs {
    final result = <BurtLog>[];
    for (final log in models.logs.allLogs) {
      if (deviceFilter != null && log.device != deviceFilter) continue;
      if (log.level.value > levelFilter.value) continue;
      result.add(log);
    }
    return result;
  }

  void resetDevice(Device device) {
    print("Resetting device... $device");
    models.home.clear(clearErrors: true);
    // Todo: Implement
  }
}
