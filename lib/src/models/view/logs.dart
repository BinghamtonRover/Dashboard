import "dart:async";
import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// A view model to track options for the logs page.
///
/// This view model is needed to separate the menus from the main logs page as whenever a new log
/// message is added to the page, the currently-selected menu item would flicker.
class LogsOptionsViewModel with ChangeNotifier {
  /// Only show logs from this device. If null, show all devices.
  Device? deviceFilter;

  /// The level at which to show logs. All logs at this level or above are shown.
  BurtLogLevel levelFilter = BurtLogLevel.info;

  /// Whether this page should autoscroll.
  ///
  /// When scrolling manually, this will be set to false for convenience.
  bool autoscroll = true;

  /// Sets [deviceFilter] and updates the UI.
  void setDeviceFilter(Device? input) {
    deviceFilter = input;
    notifyListeners();
  }

  /// Enables or disables [autoscroll].
  void setAutoscroll({bool? input}) {
    if (input == null || autoscroll == input) return;
    autoscroll = input;
    Timer.run(notifyListeners);
  }

  /// Sets [levelFilter] and updates the UI.
  void setLevelFilter(BurtLogLevel? input) {
    if (input == null) return;
    levelFilter = input;
    notifyListeners();
  }

  /// Resets the given device by sending [RoverStatus.RESTART].
  void resetDevice(Device device) {
    models.home.clear(clearErrors: true);
    final socket = switch (device) {
      Device.SUBSYSTEMS => models.sockets.data,
      Device.AUTONOMY => models.sockets.autonomy,
      Device.VIDEO => models.sockets.video,
      _ => null,
    };
    final message = UpdateSetting(status: RoverStatus.RESTART);
    socket?.sendMessage(message);
  }
}

/// A view model for the logs page to control which logs are shown.
class LogsViewModel with ChangeNotifier {
  /// The options for the log page.
  final options = LogsOptionsViewModel();

  /// The scroll controller used to implement autoscroll.
  late final ScrollController scrollController;

  void _listenForScroll(ScrollPosition position) => position.isScrollingNotifier.addListener(onScroll);

  void _stopListeningForScroll(ScrollPosition position) => position.isScrollingNotifier.removeListener(onScroll);

  /// Listens for incoming logs.
  LogsViewModel() {
    scrollController = ScrollController(
      onAttach: _listenForScroll,
      onDetach: _stopListeningForScroll,
    );
    models.logs.addListener(onNewLog);
  }

  @override
  void dispose() {
    models.logs.removeListener(onNewLog);
    super.dispose();
  }

  /// Disables [LogsOptionsViewModel.autoscroll] when the user scrolls manually.
  void onScroll() {
    final disableAutoscroll = scrollController.position.pixels > 0;
    if (disableAutoscroll != options.autoscroll && options.autoscroll) {
      options.setAutoscroll(input: disableAutoscroll);
    }
  }

  /// Scrolls to the bottom when a new log appears (if [LogsOptionsViewModel.autoscroll] is true).
  void onNewLog() {
    notifyListeners();
    if (!scrollController.hasClients) return;
    scrollController.jumpTo(options.autoscroll ? 0 : scrollController.offset + 67);
  }

  /// Jumps to the bottom of the logs.
  void jumpToBottom() {
    if (!scrollController.hasClients) return;
    scrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeOutBack);
  }

  /// Updates the UI.
  void update() => notifyListeners();

  /// Returns the lowest log level for all logs in [device]
  ///
  /// If [device] is null, returns the lowest log level of all logs
  BurtLogLevel lowestLevel(Device? device) {
    var lowestLevel = BurtLogLevel.trace;

    for (final log in models.logs.fromDevice(device)) {
      if (log.level.value < lowestLevel.value) {
        lowestLevel = log.level;
      }
    }

    return lowestLevel;
  }

  /// The logs that should be shown, according to [LogsOptionsViewModel].
  List<BurtLog> get logs {
    final logList = models.logs.fromDevice(options.deviceFilter).toList();

    return logList.reversed.where((log) => log.level.value <= options.levelFilter.value).toList();
  }
}
