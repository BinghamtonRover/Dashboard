import "dart:async";
import "dart:collection";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";

// TODO: Implement reboot, autoscroll

const maxLogCount = 1000;

extension <E> on ListQueue<E> {
  void addWithLimit(E element) {
    if (length > maxLogCount) removeFirst();
    addLast(element);
  }
}

class LogsModel extends Model {
  /// How often to save the buffered logs to the log file.
  static const saveToFileInterval = Duration(seconds: 5);
  /// The most recent [maxLogCount] logs received.
  final ListQueue<BurtLog> allLogs = ListQueue();
  /// The logs received since the last flush to disk. See [saveToFileInterval].
  List<BurtLog> saveToFileBuffer = [];
  /// A timer that checks for unsaved logs and flushes them to disk. 
  Timer? saveToFileTimer;
  
  @override
  Future<void> init() async {
    models.messages.registerHandler<BurtLog>(name: BurtLog().messageName, decoder: BurtLog.fromBuffer, handler: handleLog);
    saveToFileTimer = Timer.periodic(saveToFileInterval, saveToFile);
  }

  /// Sends a log message to be shown in the footer.
  void handleLog(BurtLog log) {
    // Save to disk and memory
    saveToFileBuffer.add(log);
    allLogs.addWithLimit(log);
    notifyListeners();

    // Show important messages to the footer.
    switch (log.level) {
      case BurtLogLevel.critical: models.home.setMessage(severity: Severity.critical, text: log.title, permanent: true);
      case BurtLogLevel.warning: models.home.setMessage(severity: Severity.warning, text: log.title);
      case BurtLogLevel.error: models.home.setMessage(severity: Severity.error, text: log.title);
      case BurtLogLevel.info:  // Info messages from other devices are not important enough to show here
      case BurtLogLevel.debug: 
      case BurtLogLevel.trace: 
      case BurtLogLevel.BURT_LOG_LEVEL_UNDEFINED: 
    }
  }

  /// Saves all the logs in [saveToFileBuffer] to disk.
  Future<void> saveToFile(_) async {
    if (saveToFileBuffer.isEmpty) return;
    for (final log in saveToFileBuffer) {
      await services.files.logMessage(log);
    }
    saveToFileBuffer.clear();
  }

  /// Clears all the logs from memory (but not from disk).
  void clear() {
    allLogs.clear();
    models.home.clear(clearErrors: true);
    notifyListeners();
  }
}
