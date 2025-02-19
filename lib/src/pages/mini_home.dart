import "package:flutter/material.dart";
import "package:rover_dashboard/app.dart";
import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/mini.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/widgets.dart";

/// The homepage for the Mini Dashboard
///
/// Displays voltage/current information, subsystem statuses, gamepad selection,
/// and options to enable/disable the dashboard and rover
class MiniHome extends StatelessWidget {
  /// The mini view model for the dashboard
  final MiniViewModel miniViewModel;

  /// Const constructor for the MiniHome
  const MiniHome({required this.miniViewModel, super.key});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 5,
                  child: MiniHomeVoltage(models.rover.metrics.drive),
                ),
                const Divider(),
                Expanded(
                  flex: 2,
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
            child: MiniHomeSystemStatus(LogsViewModel(), miniViewModel),
          ),
        ],
      );
}

/// The voltage display for the mini home page, listens to drive metrics to update data
///
/// Displays a battery charge icon, voltage, current, and battery temperature
class MiniHomeVoltage extends ReusableReactiveWidget<DriveMetrics> {
  /// Const constructor for the home voltage widget
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
  Widget build(BuildContext context, DriveMetrics model) => FittedBox(
    child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 150,
              height: 150,
              child: FittedBox(
                fit: BoxFit.fill,
                child: Icon(
                  getBatteryIcon(model.batteryPercentage),
                ),
              ),
            ),
            const SizedBox(width: 5),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${model.batteryVoltage.toStringAsFixed(2)} V",
                  style: context.textTheme.displaySmall,
                ),
                Text(
                  "${model.data.batteryCurrent.toStringAsFixed(2)} A",
                  style: context.textTheme.displaySmall,
                ),
                Text(
                  "${model.data.batteryTemperature.toStringAsFixed(2)} °C",
                  style: context.textTheme.displaySmall,
                ),
              ],
            ),
          ],
        ),
  );
}

/// Toggle options that appear at the bottom of the home page
///
/// Displays switches for enabling the dashboard or setting the rover to idle
class MiniHomeToggleOptions extends ReusableReactiveWidget<Sockets> {
  /// Const constructor
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
                  if (enabled) {
                    if (model.rover != RoverType.rover) {
                      await model.setRover(RoverType.rover);
                    }
                  }

                  if (!enabled) {
                    model.disable();
                    await model.reset();
                  } else {
                    model.enable();
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
                  value: value == RoverStatus.IDLE,
                  onChanged: (idle) async {
                    final value = idle ? RoverStatus.IDLE : RoverStatus.MANUAL;

                    await models.rover.settings.setStatus(value);
                  },
                ),
              ),
            ],
          ),
          OutlinedButton.icon(
            icon: const Icon(Icons.wifi),
            label: const Text("Reset"),
            onPressed: () async {
              await model.reset();
            },
          ),
        ],
      );
}

/// Systems status cards for the mini home page
///
/// Displays a color status indicator and a button to restart the system
class MiniHomeSystemStatus extends ReusableReactiveWidget<LogsViewModel> {
  /// The mini view model for the dashboard
  final MiniViewModel miniViewModel;

  /// Const constructor for system status cards
  const MiniHomeSystemStatus(super.model, this.miniViewModel);

  /// Returns the appropriate status icon for the log messages received from [device]
  Widget statusIcon(Device? device) {
    final socket = models.sockets.socketForDevice(device ?? Device.DEVICE_UNDEFINED);
    final lowestLevel = model.getSeverity(device ?? Device.DEVICE_UNDEFINED);

    Color? iconColor = switch (lowestLevel) {
      BurtLogLevel.critical => Colors.red,
      BurtLogLevel.info || BurtLogLevel.debug || BurtLogLevel.trace => Colors.green,
      BurtLogLevel.warning => Colors.yellow, // Separate line in case if we need to change it at any point
      BurtLogLevel.error => Colors.red,
      _ => null,
    };

    if (device == null || socket == null || !socket.isConnected || !socket.isEnabled) {
      iconColor = Colors.black;
    }

    return Icon(Icons.circle, color: iconColor);
  }

  @override
  Widget build(BuildContext context, LogsViewModel model) => Column(
        children: [
          const Spacer(),
          Expanded(
            flex: 8,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: GestureDetector(
                onDoubleTap: () => miniViewModel.showDashboard = false,
                child: Image.asset(
                  context.colorScheme.brightness == Brightness.light ? "assets/logo-light.png" : "assets/logo-dark.png",
                ),
              ),
            ),
          ),
          const Spacer(),
          for (final device in [Device.SUBSYSTEMS, Device.VIDEO, Device.AUTONOMY])
            SizedBox(
              width: 300,
              child: Card(
                color: Colors.white,
                elevation: 3,
                child: Column(
                  children: [
                    ListTile(
                      title: Text(device.humanName, style: const TextStyle(color: Colors.black)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ListenableBuilder(
                          listenable: models.sockets.socketForDevice(device)!.connectionStatus,
                          builder: (context, _) => statusIcon(device),
                        ),
                        TextButton.icon(
                          icon: const Icon(
                            Icons.restart_alt,
                            color: binghamtonGreen,
                          ),
                          onPressed: () {
                            model.resetDevice(device);
                          },
                          label: const Text(
                            "Restart Device",
                            style: TextStyle(color: binghamtonGreen),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 5),
        ],
      );
}
