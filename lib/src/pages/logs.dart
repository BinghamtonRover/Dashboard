import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/pages.dart";
import "package:rover_dashboard/widgets.dart";

class LogsPage extends ReactiveWidget<LogsViewModel> {
  @override
  LogsViewModel createModel() => LogsViewModel();

  @override
  Widget build(BuildContext context, LogsViewModel model) => Stack(
    children: [
      Column(children: [
        Row(children: [  // Menu
          for (final device in [Device.SUBSYSTEMS, Device.VIDEO, Device.AUTONOMY])  // Reset devices
            InkWell(
              onTap: () => model.resetDevice(device), 
              child: Card(
                child: ListTile(
                  leading: const Icon(Icons.restart_alt),
                  title: Text("Reset the ${device.humanName}"),
                  subtitle: const Text("The device will reboot and will be unavailable for a minute"),
                ),
              ),
            ),
          const Text("Select device"),
          DropdownMenu<Device?>(
            initialSelection: model.deviceFilter,
            onSelected: model.setDeviceFilter,
            dropdownMenuEntries: [
              for (final device in [Device.SUBSYSTEMS, Device.VIDEO, Device.AUTONOMY, null]) 
                DropdownMenuEntry(label: device?.humanName ?? "All", value: device),
            ],
          ),
          const Text("Select severity"),
          DropdownMenu<BurtLogLevel>(
            initialSelection: model.levelFilter,
            onSelected: model.setLevelFilter,
            dropdownMenuEntries: [
              for (final level in BurtLogLevel.values.filtered)
                DropdownMenuEntry(label: level.humanName, value: level),
            ],
          ),
        ],),
        Expanded(child: 
          ListView.builder(
            itemBuilder: (context, index) => LogWidget(model.logs[index]),
          ),
        ),
      ],),
      Container(
        color: context.colorScheme.surface,
        height: 50,
        child: Row(children: [
          const SizedBox(width: 8),
          Text("Logs", style: context.textTheme.headlineMedium),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.help),
            onPressed: () => showDialog<void>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Logs help"),
                content: Column(children: [
                  const Text("This page contains all logs received by the dashboard. Here's what all the icons mean:"),
                  ListTile(leading: criticalWidget, title: const Text("Critical"), subtitle: const Text("The rover is in a broken state and may shutdown")),
                  const ListTile(leading: errorWidget, title: Text("Error"), subtitle: Text("Something you tried didn't work, but the rover can still function")),
                  const ListTile(leading: warningWidget, title: Text("Warning"), subtitle: Text("Something may have gone wrong, you should check it out")),
                  ListTile(leading: infoWidget, title: const Text("Info"), subtitle: const Text("The rover is functioning normally")),
                  const ListTile(leading: debugWidget, title: Text("Debug"), subtitle: Text("Extra information that shows what the rover's thinking")),
                  const ListTile(leading: traceWidget, title: Text("Trace"), subtitle: Text("Values from the code to debug specific issues")),
                  const Text("Selecting a level means that only messages of that level or higher will be shown."),
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
          const ViewsSelector(currentView: Routes.logs),
        ],),
      ),
    ],
  );
}

final criticalWidget = Icon(Icons.cancel, color: Colors.red.shade900);
const errorWidget = Icon(Icons.error, color: Colors.red);
const warningWidget = Icon(Icons.warning, color: Colors.orange);
final infoWidget = Icon(Icons.info, color: Colors.lightBlue.shade900);
const debugWidget = Icon(Icons.chat, color: Colors.blueGrey);
const traceWidget = Icon(Icons.code, color: Colors.grey);

class LogWidget extends StatelessWidget {
  final BurtLog log;
  const LogWidget(this.log);

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
    subtitle: log.body.isEmpty ? null : Text(log.body),
  );
}
