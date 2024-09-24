import "dart:io";

import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/widgets.dart";

/// A widget to show the options for the logs page.
///
/// This is separate from the logs display so that the menu doesn't flicker when new logs arrive.
class LogsOptions extends ReusableReactiveWidget<LogsViewModel> {
  /// Listens to the view model without disposing it.
  const LogsOptions(super.model) : super();

  /// An appropriate WiFi for the connection strength of [device]
  IconData connectionStrength(Device device) {
    final socket = models.sockets.fromDevice(device);
    final percentage = (socket?.connectionStrength.value ?? 0) * 100;

    // Can't use a switch statement since socket?.isConnected isn't constant :(
    if (percentage >= 0.8) {
      return Icons.signal_wifi_statusbar_4_bar;
    } else if (percentage >= 0.6) {
      return Icons.network_wifi_3_bar;
    } else if (percentage >= 0.4) {
      return Icons.network_wifi_2_bar;
    } else if (percentage >= 0.2) {
      return Icons.network_wifi_1_bar;
    } else if (socket?.isConnected ?? false) {
      return Icons.signal_wifi_0_bar;
    } else {
      return Icons.signal_wifi_off_outlined;
    }
  }

  /// Returns the appropriate status icon for the log messages received from [device]
  Widget statusIcon(Device? device) {
    final socket = models.sockets.fromDevice(device);
    final lowestLevel = model.lowestLevel(device);

    Color? iconColor = switch (lowestLevel) {
      BurtLogLevel.critical => Colors.red,
      BurtLogLevel.info || BurtLogLevel.debug || BurtLogLevel.trace => Colors.green,
      BurtLogLevel.warning => Colors.yellow, // Separate line in case if we need to change it at any point
      BurtLogLevel.error => Colors.red,
      _ => null,
    };

    if (device == null || socket == null || !socket.isConnected) {
      iconColor = Colors.black;
    }

    return Icon(Icons.circle, color: iconColor);
  }

  /// Returns a button to open an SSH connection to [device]
  Widget sshButton(Device? device) {
    final socket = models.sockets.fromDevice(device);

    return TextButton.icon(
      onPressed: () {
        if (!Platform.isWindows || device == null) {
          return;
        }

        if (models.sockets.rover == RoverType.localhost) {
          models.home.setMessage(
            severity: Severity.error,
            text: "You can't SSH into your own computer silly!",
          );
          return;
        }

        if (socket == null || socket.destination?.address == null) {
          models.home.setMessage(
            severity: Severity.error,
            text: "Unable to find IP Address for ${device.humanName}, try resetting the network.",
          );
          return;
        }

        if (!socket.isConnected) {
          models.home.setMessage(severity: Severity.error, text: "${device.humanName} is not connected");
          return;
        }

        Process.run("cmd", [
          "/k",
          "start",
          "powershell",
          "-NoExit",
          "-command",
          "ssh pi@${socket.destination!.address.address} -o StrictHostkeyChecking=no",
        ]);
      },
      label: const Text("Open SSH"),
      icon: const Icon(Icons.lan),
    );
  }

  @override
  Widget build(BuildContext context, LogsViewModel model) => Column(
      children: [
        // Menu
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (final device in [Device.SUBSYSTEMS, Device.VIDEO, Device.AUTONOMY]) // Reset devices
              SizedBox(
                width: 250,
                child: Card(
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () => model.options.resetDevice(device),
                        leading: const Icon(Icons.restart_alt),
                        title: Text("Reset ${device.humanName}"),
                        subtitle: const Text("The device will reboot"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            statusIcon(device),
                            Icon(connectionStrength(device)),
                            sshButton(device),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownMenu<Device?>(
              label: const Text("Select device"),
              initialSelection: model.options.deviceFilter,
              onSelected: (input) {
                model.options.setDeviceFilter(input);
                model.update();
              },
              dropdownMenuEntries: [
                for (final device in [Device.SUBSYSTEMS, Device.VIDEO, Device.AUTONOMY, null])
                  DropdownMenuEntry(label: device?.humanName ?? "All", value: device),
              ],
            ),
            const SizedBox(width: 8),
            DropdownMenu<BurtLogLevel>(
              label: const Text("Select severity"),
              initialSelection: model.options.levelFilter,
              onSelected: (input) {
                model.options.setLevelFilter(input);
                model.update();
              },
              dropdownMenuEntries: [
                for (final level in BurtLogLevel.values.filtered)
                  DropdownMenuEntry(label: level.humanName, value: level),
              ],
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 250,
              child: CheckboxListTile(
                title: const Text("Autoscroll"),
                subtitle: const Text("Scroll to override"),
                value: model.options.autoscroll,
                onChanged: (input) {
                  model.options.setAutoscroll(input: input);
                  if (input ?? false) model.jumpToBottom();
                  model.update();
                },
              ),
            ),
          ],
        ),
      ],
    );
}

/// The logs page, containing the [LogsOptions] and [LogsBody] widgets.
///
/// This page lets the user view logs, set filters, and reboot the rover.
class LogsPage extends StatefulWidget {
  @override
  LogsState createState() => LogsState();
}

/// The state of the logs page. Used to ensure that the [LogsViewModel] is only created once.
class LogsState extends State<LogsPage> {
  /// The view model for this page.
  final model = LogsViewModel();

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Column(children: [
      const SizedBox(height: 12),
      LogsOptions(model),
      const Divider(),
      Expanded(child: LogsBody(model)),
    ],),
    appBar: AppBar(
      title: const Text("Logs"),
      actions: [
        IconButton(
          icon: const Icon(Icons.help),
          tooltip: "Help",
          onPressed: () => showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Logs help"),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                const Text("This page contains all logs received by the dashboard.\nSelecting a level means that only messages of that level or higher will be shown.", textAlign: TextAlign.center,),
                const SizedBox(height: 4),
                ListTile(leading: criticalWidget, title: const Text("Critical"), subtitle: const Text("The rover is in a broken state and may shutdown")),
                const ListTile(leading: errorWidget, title: Text("Error"), subtitle: Text("Something you tried didn't work, but the rover can still function")),
                const ListTile(leading: warningWidget, title: Text("Warning"), subtitle: Text("Something may have gone wrong, you should check it out")),
                ListTile(leading: infoWidget, title: const Text("Info"), subtitle: const Text("The rover is functioning normally")),
                const ListTile(leading: debugWidget, title: Text("Debug"), subtitle: Text("Extra information that shows what the rover's thinking")),
                const ListTile(leading: traceWidget, title: Text("Trace"), subtitle: Text("Values from the code to debug specific issues")),
                const SizedBox(height: 12),
              ],),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Close"),
                ),
              ],
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.vertical_align_bottom),
          onPressed: model.jumpToBottom,
          tooltip: "Jump to bottom",
        ),
        IconButton(
          icon: const Icon(Icons.delete_forever),
          onPressed: models.logs.clear,
          tooltip: "Clear logs",
        ),
      ],
    ),
    bottomNavigationBar: const Footer(showLogs: false),
  );
}

/// The widget that actually contains the logs for the page.
///
/// This is a separate widget to prevent updating the rest of the page when new logs come in.
class LogsBody extends ReusableReactiveWidget<LogsViewModel> {
  /// Listens to the given view model.
  const LogsBody(super.model);

  @override
  Widget build(BuildContext context, LogsViewModel model) => model.logs.isEmpty
    ? const Center(child: Text("No logs yet"))
    : ListView.builder(
      itemCount: model.logs.length,
      controller: model.scrollController,
      reverse: true,
      itemBuilder: (context, index) => LogWidget(model.logs[index]),
    );
}

/// The icon to show for logs with [BurtLogLevel.critical].
final criticalWidget = Icon(Icons.cancel, color: Colors.red.shade900);
/// The icon to show for logs with [BurtLogLevel.error].
const errorWidget = Icon(Icons.error, color: Colors.red);
/// The icon to show for logs with [BurtLogLevel.warning].
const warningWidget = Icon(Icons.warning, color: Colors.orange);
/// The icon to show for logs with [BurtLogLevel.info].
final infoWidget = Icon(Icons.info, color: Colors.lightBlue.shade900);
/// The icon to show for logs with [BurtLogLevel.debug].
const debugWidget = Icon(Icons.chat, color: Colors.blueGrey);
/// The icon to show for logs with [BurtLogLevel.trace].
const traceWidget = Icon(Icons.code, color: Colors.grey);

/// A widget that shows a [BurtLog].
class LogWidget extends StatelessWidget {
  /// The log message being shown in this widget.
  final BurtLog log;
  /// Creates a widget to display the given log message.
  const LogWidget(this.log);

  /// Gets an icon for the given [BurtLogLevel].
  Widget get icon => switch(log.level) {
    BurtLogLevel.critical => criticalWidget,
    BurtLogLevel.error => errorWidget,
    BurtLogLevel.warning => warningWidget,
    BurtLogLevel.info => infoWidget,
    BurtLogLevel.debug => debugWidget,
    BurtLogLevel.trace => traceWidget,
    _ => const Icon(Icons.question_mark),
  };

  @override
  Widget build(BuildContext context) => ListTile(
    leading: icon,
    title: Text(log.title),
    subtitle: log.body.isEmpty ? Text(log.device.humanName) : Text("${log.device.humanName}\n${log.body}".trim()),
  );
}
