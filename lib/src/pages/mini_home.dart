import "package:flutter/material.dart";
import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/widgets.dart";

class MiniHome extends StatelessWidget {
  const MiniHome({super.key});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: MiniHomeVoltage(models.rover.metrics),
                ),
                const Divider(),
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GamepadButton(models.rover.controller1),
                      GamepadButton(models.rover.controller2),
                      GamepadButton(models.rover.controller3),
                    ],
                  ),
                ),
                const Divider(),
                SizedBox(
                  height: 75,
                  child: MiniHomeToggleOptions(models.sockets),
                ),
              ],
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            flex: 2,
            child: MiniHomeSystemStatus(LogsViewModel()),
          ),
        ],
      );
}

class MiniHomeVoltage extends ReusableReactiveWidget<RoverMetrics> {
  const MiniHomeVoltage(super.model);

  /// An appropriate battery icon in increments of 1/8 battery level.
  IconData getBatteryIcon(double percentage) {
    if (percentage >= 0.84) {
      return Icons.battery_full;
    } // 80-100
    else if (percentage >= 0.72) {
      return Icons.battery_6_bar;
    } // 60-80
    else if (percentage >= 0.60) {
      return Icons.battery_5_bar;
    } // 60-80
    else if (percentage >= 0.48) {
      return Icons.battery_4_bar;
    } // 60-80
    else if (percentage >= 0.36) {
      return Icons.battery_3_bar;
    } // 60-80
    else if (percentage >= 0.24) {
      return Icons.battery_2_bar;
    } // 40-60
    else if (percentage >= 0.12) {
      return Icons.battery_1_bar;
    } // 20-40
    else {
      return Icons.battery_0_bar;
    } // 0-20
  }

  @override
  Widget build(BuildContext context, RoverMetrics model) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 150,
            height: 150,
            child: FittedBox(
              fit: BoxFit.fill,
              child: Icon(
                getBatteryIcon(model.drive.batteryVoltage),
              ),
            ),
          ),
          const SizedBox(width: 5),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${model.drive.batteryVoltage.toStringAsFixed(2)} V",
                style: context.textTheme.displaySmall,
              ),
              Text(
                "${model.drive.data.batteryCurrent.toStringAsFixed(2)} A",
                style: context.textTheme.displaySmall,
              ),
              Text(
                "${model.drive.data.batteryTemperature.toStringAsFixed(2)} °C",
                style: context.textTheme.displaySmall,
              ),
            ],
          ),
        ],
      );
}

class MiniHomeToggleOptions extends ReusableReactiveWidget<Sockets> {
  const MiniHomeToggleOptions(super.model);

  @override
  Widget build(BuildContext context, Sockets model) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              const Text("Dashboard Enabled"),
              const SizedBox(width: 5),
              Switch(
                value: model.isEnabled,
                onChanged: (enabled) async {
                  if (model.rover != RoverType.localhost) {
                    await model.setRover(RoverType.localhost);
                  }

                  if (!enabled) {
                    await model.disable();
                  } else {
                    await model.init();
                  }
                },
              ),
            ],
          ),
          Row(
            children: [
              const Text("Idle"),
              const SizedBox(width: 5),
              ValueListenableBuilder(
                valueListenable: models.rover.status,
                builder: (context, value, child) => Switch(
                  value: value != RoverStatus.IDLE,
                  onChanged: (idle) async {
                    final value = idle ? RoverStatus.IDLE : RoverStatus.MANUAL;

                    await models.rover.settings.setStatus(value);
                  },
                ),
              ),
            ],
          ),
        ],
      );
}

class MiniHomeSystemStatus extends ReusableReactiveWidget<LogsViewModel> {
  const MiniHomeSystemStatus(super.model);

  /// Returns the appropriate status icon for the log messages received from [device]
  Widget statusIcon(Device? device) {
    final socket =
        models.sockets.sockets.firstWhere((socket) => socket.device == device); //models.sockets.fromDevice(device);
    final lowestLevel = BurtLogLevel.info; //model.lowestLevel(device);

    Color? iconColor = switch (lowestLevel) {
      BurtLogLevel.critical => Colors.red,
      BurtLogLevel.info || BurtLogLevel.debug || BurtLogLevel.trace => Colors.green,
      BurtLogLevel.warning => Colors.yellow, // Separate line in case if we need to change it at any point
      BurtLogLevel.error => Colors.red,
      _ => null,
    };

    if (device == null || /*socket == null ||*/ !socket.isConnected) {
      iconColor = Colors.black;
    }

    return Icon(Icons.circle, color: iconColor);
  }

  @override
  Widget build(BuildContext context, LogsViewModel model) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (final device in [Device.SUBSYSTEMS, Device.VIDEO, Device.AUTONOMY])
            SizedBox(
              width: 300,
              child: Card(
                child: Column(
                  children: [
                    ListTile(
                      title: Text(device.humanName),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        statusIcon(device),
                        TextButton.icon(
                          icon: const Icon(Icons.restart_alt),
                          onPressed: () {
                            model.options.resetDevice(device);
                          },
                          label: const Text("Restart Device"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      );
}
