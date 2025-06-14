import "dart:async";
import "dart:collection";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";

/// The maximum amount of logs (to prevent consuming too much memory).
const maxLogCount = 1000;

extension <E> on ListQueue<E> {
  /// Adds the given element to this queue, treating it like a ring buffer.
  ///
  /// If the length of the list exceeds [maxLogCount], the first element is removed to make space
  /// for the element at the tail. Since [addLast] and [removeFirst] are O(1), this is efficient.
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

  /// The most recent [maxLogCount] of messages from the base station
  final ListQueue<BurtLog> baseStationLogs = ListQueue();

  /// The most recent [maxLogCount] of messages from the dashboard
  final ListQueue<BurtLog> dashboardLogs = ListQueue();

  /// Contains the highest severity that each device emitted.
  final Map<Device, BurtLogLevel> deviceSeverity = {};

  /// The logs received since the last flush to disk. See [saveToFileInterval].
  List<BurtLog> saveToFileBuffer = [];

  /// A timer that checks for unsaved logs and flushes them to disk.
  Timer? saveToFileTimer;

  @override
  Future<void> init() async {
    models.messages.stream.onMessage<BurtLog>(
      name: BurtLog().messageName,
      constructor: BurtLog.fromBuffer,
      callback: handleLog,
    );
    saveToFileTimer = Timer.periodic(saveToFileInterval, saveToFile);
  }

  /// Returns the list of log messages for the corresponding [device]
  ListQueue<BurtLog>? logsForDevice(Device? device) => switch (device) {
    Device.SUBSYSTEMS => subsystemLogs,
    Device.VIDEO => videoLogs,
    Device.AUTONOMY => autonomyLogs,
    Device.BASE_STATION => baseStationLogs,
    Device.DASHBOARD => dashboardLogs,
    null => allLogs,
    _ => null,
  };

  /// Sends a log message to be shown in the footer.
  void handleLog(BurtLog log, {bool display = true}) {
    // Update device severity
    final oldSeverity = deviceSeverity[log.device];
    if (oldSeverity == null || log.level.isMoreSevereThan(oldSeverity)) {
      deviceSeverity[log.device] = log.level;
    }
    // Save to disk and memory
    saveToFileBuffer.add(log);
    logsForDevice(log.device)?.addWithLimit(log);
    _controller.add(log);
    allLogs.addWithLimit(log);
    notifyListeners();

    // Show important messages to the footer.
    if (display) {
      // Prevents showing dashboard messages that have already been shown
      switch (log.level) {
        case BurtLogLevel.critical:
          models.home.setMessage(
            severity: Severity.critical,
            text: log.title,
            permanent: true,
            logMessage: false,
          );
        case BurtLogLevel.warning:
          models.home.setMessage(
            severity: Severity.warning,
            text: log.title,
            logMessage: false,
          );
        case BurtLogLevel.error:
          models.home.setMessage(
            severity: Severity.error,
            text: log.title,
            logMessage: false,
          );
        case BurtLogLevel.info:
          models.home.setMessage(
            severity: Severity.info,
            text: "${log.device.humanName}: ${log.title}",
            logMessage: false,
          );
        case BurtLogLevel.debug:
        case BurtLogLevel.trace:
        case BurtLogLevel.BURT_LOG_LEVEL_UNDEFINED:
      }
    }
  }

  final _controller = StreamController<BurtLog>.broadcast();

  /// A stream of incoming logs.
  Stream<BurtLog> get stream => _controller.stream;

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
    baseStationLogs.clear();
    dashboardLogs.clear();
    deviceSeverity.clear();
    models.home.clear(clearErrors: true);
    notifyListeners();
  }
}
