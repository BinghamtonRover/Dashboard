import "dart:async";
import "dart:io";
import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";

/// A view model to track options for the logs page.
///
/// This view model is needed to separate the menus from the main logs page as whenever a new log
/// message is added to the page, the currently-selected menu item would flicker.
class LogsOptionsViewModel with ChangeNotifier {
  /// Contains the highest severity that each device emitted.
  final Map<Device, BurtLogLevel> deviceSeverity = {};

  /// Only show logs from this device. If null, show all devices.
  Device? deviceFilter;

  /// The level at which to show logs. All logs at this level or above are shown.
  BurtLogLevel levelFilter = BurtLogLevel.info;

  /// Whether this page should autoscroll.
  ///
  /// When scrolling manually, this will be set to false for convenience.
  bool autoscroll = true;

  /// Whether or not to temporarily pause log updating
  ///
  /// Makes scrolling and viewing past logs significantly easier
  bool paused = false;

  /// Sets [deviceFilter] and updates the UI.
  void setDeviceFilter(Device? input) {
    deviceFilter = input;
    notifyListeners();
  }

  /// Enables or disables [autoscroll].
  // ignore: avoid_positional_boolean_parameters
  void setAutoscroll(bool? input) {
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

  /// Toggles whether new logs are received.
  void togglePause() {
    paused = !paused;
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
    deviceSeverity[device] = BurtLogLevel.info;
    final message = UpdateSetting(status: RoverStatus.RESTART);
    socket?.sendMessage(message);
    notifyListeners();
  }

  /// Gets the highest severity the given device emitted.
  BurtLogLevel getSeverity(Device device) => deviceSeverity[device] ?? BurtLogLevel.info;

  /// Updates [deviceSeverity] when a new message comes in.
  void onNewLog(BurtLog log) {
    final oldSeverity = deviceSeverity[log.device];
    if (oldSeverity == null || log.level.isMoreSevereThan(oldSeverity)) {
      deviceSeverity[log.device] = log.level;
      notifyListeners();
    }
  }

  /// Opens an SSH session (on Windows) for the given device.
  void openSsh(Device device, DashboardSocket socket) {
    if (models.sockets.rover == RoverType.localhost) {
      models.home.setMessage(severity: Severity.error, text: "You can't SSH into your own computer silly!");
    } else if (socket.destination?.address == null) {
      models.home.setMessage(
        severity: Severity.error,
        text: "Unable to find IP Address for ${device.humanName}, try resetting the network.",
      );
    } else {
      Process.run("cmd", [
        // Keep a Powershell window open
        "/k", "start", "powershell", "-NoExit", "-command",
        // SSH to the IP address, and do not care if the device fingerprint has changed
        "ssh pi@${socket.destination!.address.address} -o StrictHostkeyChecking=no",
      ]);
    }
  }

  /// Opens a Command prompt on Windows to ping the device.
  void ping(Device device) {
    final socket = models.sockets.socketForDevice(device);
    if (socket == null || socket.destination == null) {
      models.home.setMessage(severity: Severity.error, text: "Could not determine IP address for ${device.humanName}");
    } else {
      Process.run("cmd", [
        // Keep a CMD window open
        "/k", "start", "cmd", "/k",
        // Ping the IP address. -t means indefinitely
        "ping", "-t", socket.destination!.address.address,
      ]);
    }
  }
}

/// A view model for the logs page to control which logs are shown.
class LogsViewModel with ChangeNotifier {
  /// The options for the log page.
  final options = LogsOptionsViewModel();

  /// The scroll controller used to implement autoscroll.
  late final ScrollController scrollController;

  void _listenForScroll(ScrollPosition position) =>
    position.isScrollingNotifier.addListener(onScroll);

  void _stopListeningForScroll(ScrollPosition position) =>
    position.isScrollingNotifier.removeListener(onScroll);

  /// Listens for incoming logs.
  LogsViewModel() {
    scrollController = ScrollController(
      onAttach: _listenForScroll,
      onDetach: _stopListeningForScroll,
    );
    models.logs.addListener(onNewLog);
    models.sockets.addListener(notifyListeners);
    models.logs.stream.listen(options.onNewLog);
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
      options.setAutoscroll(disableAutoscroll);
    }
  }

  /// Scrolls to the bottom when a new log appears (if [LogsOptionsViewModel.autoscroll] is true).
  void onNewLog() {
    if (options.paused) return;
    notifyListeners();
    if (!scrollController.hasClients) return;
    scrollController.jumpTo(options.autoscroll ? 0 : scrollController.offset + 67);
  }

  /// Jumps to the bottom of the logs.
  void jumpToBottom() {
    if (!scrollController.hasClients) return;
    scrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeOutBack);
  }

  /// The logs that should be shown, according to [LogsOptionsViewModel].
  List<BurtLog> get logs {
    final device = options.deviceFilter;
    final logList = models.logs.logsForDevice(device);
    if (logList == null) return [];
    return logList.toList().reversed
      .where((log) => log.level.isAtLeast(options.levelFilter)).toList();
  }
}
