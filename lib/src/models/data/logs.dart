import "dart:async";
import "dart:collection";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";

/// The maximum amount of logs (to prevent consuming too much memory).
const maxLogCount = 1000;

extension <E> on ListQueue<E> {
  void addWithLimit(E element) {
    if (length > maxLogCount) removeFirst();
    addLast(element);
  }
}

/// A data model that collects and stores logs from the rover.
/// 
/// The logs are kept in-memory in separate lists for subsystems, video, and autonomy, and are also saved to disk for retroactive
/// debugging. To prevent slowing down the dashboard or consuming too much memory, the in-memory
/// list is limited to [maxLogCount], and logs are only saved to disk every [saveToFileInterval].
class LogsModel extends Model {
  /// How often to save the buffered logs to the log file.
  static const saveToFileInterval = Duration(seconds: 5);
  /// The most recent [maxLogCount] logs received.
  final ListQueue<BurtLog> allLogs = ListQueue();
  /// The most recent [maxLogCount] received for [Device.SUBSYSTEMS]
  final ListQueue<BurtLog> subsystemLogs = ListQueue();
  /// The most recent [maxLogCount] received for [Device.SUBSYSTEMS]
  final ListQueue<BurtLog> videoLogs = ListQueue();
  /// The most recent [maxLogCount] received for [Device.SUBSYSTEMS]
  final ListQueue<BurtLog> autonomyLogs = ListQueue();

  /// The logs received since the last flush to disk. See [saveToFileInterval].
  List<BurtLog> saveToFileBuffer = [];
  /// A timer that checks for unsaved logs and flushes them to disk. 
  Timer? saveToFileTimer;
  
  @override
  Future<void> init() async {
    models.messages.registerHandler<BurtLog>(name: BurtLog().messageName, decoder: BurtLog.fromBuffer, handler: handleLog);
    saveToFileTimer = Timer.periodic(saveToFileInterval, saveToFile);
  }

  /// Returns the list of log messages for the corresponding [device]
  ListQueue<BurtLog> fromDevice(Device? device) => switch (device) {
      Device.SUBSYSTEMS =>
        subsystemLogs,
      Device.VIDEO =>
        videoLogs,
      Device.AUTONOMY =>
        autonomyLogs,
      _ => allLogs,
    };

  /// Sends a log message to be shown in the footer.
  void handleLog(BurtLog log) {
    // Save to disk and memory
    saveToFileBuffer.add(log);

    switch (log.device) {
      case Device.SUBSYSTEMS:
        subsystemLogs.addWithLimit(log);
      case Device.VIDEO:
        videoLogs.addWithLimit(log);
      case Device.AUTONOMY:
        autonomyLogs.addWithLimit(log);
      // ignore: no_default_cases
      default:
    }
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
    for (final log in List<BurtLog>.from(saveToFileBuffer)) {
      await services.files.logMessage(log);
    }
    saveToFileBuffer.clear();
  }

  /// Clears all the logs from memory (but not from disk).
  void clear() {
    allLogs.clear();
    subsystemLogs.clear();
    videoLogs.clear();
    autonomyLogs.clear();
    models.home.clear(clearErrors: true);
    notifyListeners();
  }
}
