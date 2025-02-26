import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rover_dashboard/data.dart';
import 'package:rover_dashboard/models.dart';
import 'package:rover_dashboard/pages.dart';
import 'package:rover_dashboard/widgets.dart';

class MessageDisplay extends StatelessWidget {
  final bool showLogs;
  const MessageDisplay({required this.showLogs});
  @override
  Widget build (BuildContext context)
  {
    return Text(showLogs ? 'Logs are shown' : 'Logs are hidden');
  }
}
class ButtonExpander extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Icon(Icons.expand_more);
  }
}
/// The footer, responsible for showing vitals and logs.
class Footer extends StatelessWidget {
  /// Whether to show logs. Disable this when on the logs page.
  final bool showLogs;

  /// Creates the footer.
  const Footer({this.showLogs = true});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.secondary,
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        children: [
          MessageDisplay(showLogs: showLogs),
          Wrap(
            children: [
              ButtonExpander(),
              const SizedBox(width: 2),
              SerialButton(),
              const SizedBox(width: 2),
              const StatusIcons(),
            ],
          ),
        ],
      ),
    );
  }
}

/// A network status icon for the given device.
class NetworkStatusIcon extends ReusableReactiveWidget<ValueNotifier<double>> {
  /// What to do when the button is pressed.
  final VoidCallback? onPressed;

  /// What to show as the tooltip.
  final String tooltip;

  /// A const constructor.
  NetworkStatusIcon({
    required Device device,
    required this.onPressed,
    required this.tooltip,
  }) : super(models.sockets.socketForDevice(device)!.connectionStrength);

  IconData _getNetworkIcon(double percentage) {
    return switch (percentage) {
      >= 0.8 => Icons.signal_wifi_statusbar_4_bar,
      >= 0.6 => Icons.network_wifi_3_bar,
      >= 0.4 => Icons.network_wifi_2_bar,
      >= 0.2 => Icons.network_wifi_1_bar,
      > 0.0 => Icons.signal_wifi_0_bar,
      _ => Icons.signal_wifi_off_outlined,
    };
  }

  @override
  Widget build(BuildContext context, ValueNotifier<double> model) {
    return IconButton(
      tooltip: tooltip,
      icon: Icon(
        _getNetworkIcon(model.value),
        color: StatusIcons.getColor(model.value),
      ),
      onPressed: onPressed,
    );
  }
}

/// A few icons displaying the rover's current status.
class StatusIcons extends ReactiveWidget<FooterViewModel> {
  /// A const constructor.
  const StatusIcons();

  @override
  FooterViewModel createModel() => FooterViewModel();

  /// A color representing a meter's fill.
  static Color getColor(double percentage) {
    return switch (percentage) {
      > 0.45 => Colors.green,
      > 0.2 => Colors.orange,
      > 0 => Colors.red,
      _ => Colors.black,
    };
  }

  /// An appropriate battery icon in increments of 1/8 battery level.
  IconData getBatteryIcon(double percentage) {
    return switch (percentage) {
      >= 0.84 => Icons.battery_full,
      >= 0.72 => Icons.battery_6_bar,
      >= 0.60 => Icons.battery_5_bar,
      >= 0.48 => Icons.battery_4_bar,
      >= 0.36 => Icons.battery_3_bar,
      >= 0.24 => Icons.battery_2_bar,
      >= 0.12 => Icons.battery_1_bar,
      _       => Icons.battery_0_bar,
    };
  }

  /// An appropriate battery icon representing the rover's current status.
  IconData getStatusIcon(RoverStatus status) {
    return switch (status) {
      RoverStatus.DISCONNECTED => Icons.power_off,
      RoverStatus.POWER_OFF => Icons.power_off,
      RoverStatus.IDLE => Icons.pause_circle,
      RoverStatus.MANUAL => Icons.play_circle,
      RoverStatus.AUTONOMOUS => Icons.smart_toy,
      RoverStatus.RESTART => Icons.restart_alt,
      _ => throw ArgumentError("Unrecognized rover status: $status"),
    };
  }

  /// The color of the rover's status icon.
  Color getStatusColor(RoverStatus status) {
    return switch (status) {
      RoverStatus.DISCONNECTED => Colors.black,
      RoverStatus.IDLE => Colors.yellow,
      RoverStatus.MANUAL => Colors.green,
      RoverStatus.AUTONOMOUS => Colors.blueGrey,
      RoverStatus.POWER_OFF => Colors.red,
      RoverStatus.RESTART => Colors.yellow,
      _ => throw ArgumentError("Unrecognized rover status: $status"),
    };
  }

  /// Gets the Flutter color for the given Protobuf color.
  Color getLedColor(ProtoColor color) {
    return switch (color) {
      ProtoColor.BLUE => Colors.blue,
      ProtoColor.RED => Colors.red,
      ProtoColor.GREEN => Colors.green,
      ProtoColor.UNLIT => Colors.grey,
      _ => Colors.grey,
    };
  }

  /// Change the mode of the rover, confirming if the user wants to shut it off.
  Future<void> changeMode(BuildContext context, RoverStatus input) async {
    if (input == RoverStatus.POWER_OFF) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Are you sure?"),
          content: const Text("This will turn off the rover and you must physically turn it back on again"),
          actions: [
            TextButton(child: const Text("Cancel"), onPressed: () => Navigator.of(context).pop()),
            ElevatedButton(
              onPressed: () { 
                models.rover.settings.setStatus(input);
                Navigator.of(context).pop(); 
              },
              child: const Text("Continue"),
            ),
          ],
        ),
      );
    } else {
      models.rover.settings.setStatus(input);
    }
  }

  @override
  Widget build(BuildContext context, FooterViewModel model) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Tooltip(
          message: model.batteryMessage,
          child: Icon(
            model.isConnected
                ? getBatteryIcon(model.batteryPercentage)
                : Icons.battery_unknown,
            color: model.isConnected
                ? getColor(model.batteryPercentage)
                : Colors.black,
          ),
        ),
        NetworkStatusIcon(
          device: Device.SUBSYSTEMS,
          tooltip: "${model.connectionSummary}\nClick to reset",
          onPressed: model.resetNetwork,
        ),
        PopupMenuButton(
          tooltip: "Change mode",
          onSelected: (input) => changeMode(context, input),
          icon: Icon(
            getStatusIcon(model.status),
            color: getStatusColor(model.status),
          ),
          itemBuilder: (_) => [
            for (final value in RoverStatus.values)
              if (value != RoverStatus.DISCONNECTED)
                PopupMenuItem(value: value, child: Text(value.humanName)),
          ],
        ),
        IconButton(
          icon: Icon(
            Icons.circle,
            color: model.isConnected
                ? getLedColor(model.ledColor)
                : Colors.black,
          ),
          onPressed: () => showDialog<void>(context: context, builder: (_) => ColorEditor(ColorBuilder())),
          tooltip: "Change LED strip",
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}

/// Allows the user to connect to the firmware directly, over Serial.
class SerialButton extends ReusableReactiveWidget<SerialModel> {
  /// Provides a const constructor.
  SerialButton() : super(models.serial);

  @override
  Widget build(BuildContext context, SerialModel model) {
    return PopupMenuButton(
      icon: Icon(
        Icons.usb,
        color: model.hasDevice ? Colors.green : context.colorScheme.onSecondary,
      ),
      tooltip: "Select device",
      onSelected: model.toggle,
      itemBuilder: (_) => [
        for (final String port in DelegateSerialPort.allPorts) ...[
          PopupMenuItem(
            value: port,
            child: Text(port),
          ),
        ],
      ],
    );
  }
}
