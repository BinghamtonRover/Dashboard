import "package:flutter/material.dart";

import "package:burt_network/serial.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/pages.dart";
import "package:rover_dashboard/widgets.dart";

/// The footer, responsible for showing vitals and logs.
class Footer extends StatelessWidget {
  /// Whether to show logs. Disable this when on the logs page.
  final bool showLogs;
  /// Creates the footer.
  const Footer({this.showLogs = true});

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: Theme.of(context).colorScheme.secondary,
    child: Wrap(
      alignment: WrapAlignment.spaceBetween,
      children: [
        MessageDisplay(showLogs: showLogs),
        Wrap(  // Groups these elements together even when wrapping
          children: [
            GamepadButton(models.rover.controller1),
            const SizedBox(width: 8),
            GamepadButton(models.rover.controller2),
            const SizedBox(width: 8),
            GamepadButton(models.rover.controller3),
            SerialButton(),
            const SizedBox(width: 4),
            StatusIcons(),
          ],
        ),
      ],
    ),
  );
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

  IconData _getNetworkIcon(double percentage) => switch(percentage) {
    >= 0.8 => Icons.signal_wifi_statusbar_4_bar,
    >= 0.6 => Icons.network_wifi_3_bar,
    >= 0.4 => Icons.network_wifi_2_bar,
    >= 0.2 => Icons.network_wifi_1_bar,
    >  0.0 => Icons.signal_wifi_0_bar,
    _ => Icons.signal_wifi_off_outlined,
  };

  @override
  Widget build(BuildContext context, ValueNotifier<double> model) => IconButton(
    tooltip: tooltip,
    icon: Icon(
      _getNetworkIcon(model.value),
      color: StatusIcons.getColor(model.value),
    ),
    onPressed: onPressed,
  );
}

/// A few icons displaying the rover's current status.
class StatusIcons extends ReactiveWidget<FooterViewModel> {
  /// A const constructor.
  StatusIcons() : super(key: UniqueKey());

  @override
  FooterViewModel createModel() => FooterViewModel();

  /// A color representing a meter's fill.
  static Color getColor(double percentage) => switch (percentage) {
    > 0.45 => Colors.green,
    > 0.2 => Colors.orange,
    > 0 => Colors.red,
    _ => Colors.black,
  };

  /// An appropriate battery icon in increments of 1/8 battery level.
  IconData getBatteryIcon(double percentage) => switch (percentage) {
    >= 0.84 => Icons.battery_full,
    >= 0.72 => Icons.battery_6_bar,
    >= 0.60 => Icons.battery_5_bar,
    >= 0.48 => Icons.battery_4_bar,
    >= 0.36 => Icons.battery_3_bar,
    >= 0.24 => Icons.battery_2_bar,
    >= 0.12 => Icons.battery_1_bar,
    _       => Icons.battery_0_bar,
  };

  /// An appropriate battery icon representing the rover's current status.
  IconData getStatusIcon(RoverStatus status) => switch (status) {
    RoverStatus.DISCONNECTED => Icons.power_off,
    RoverStatus.POWER_OFF => Icons.power_off,
    RoverStatus.IDLE => Icons.pause_circle,
    RoverStatus.MANUAL => Icons.play_circle,
    RoverStatus.AUTONOMOUS => Icons.smart_toy,
    RoverStatus.RESTART => Icons.restart_alt,
    _ => throw ArgumentError("Unrecognized rover status: $status"),
  };

  /// The color of the rover's status icon.
  Color getStatusColor(RoverStatus status) => switch(status) {
    RoverStatus.DISCONNECTED => Colors.black,
    RoverStatus.IDLE => Colors.yellow,
    RoverStatus.MANUAL => Colors.green,
    RoverStatus.AUTONOMOUS => Colors.blueGrey,
    RoverStatus.POWER_OFF => Colors.red,
    RoverStatus.RESTART => Colors.yellow,
    _ => throw ArgumentError("Unrecognized rover status: $status"),
  };

  /// Gets the Flutter color for the given Protobuf color.
  Color getLedColor(ProtoColor color) => switch (color) {
    ProtoColor.BLUE => Colors.blue,
    ProtoColor.RED => Colors.red,
    ProtoColor.GREEN => Colors.green,
    ProtoColor.UNLIT => Colors.grey,
    _ => Colors.grey,
  };

  /// Change the mode of the rover, confirming if the user wants to shut it off.
  Future<void> changeMode(BuildContext context, RoverStatus input) => input == RoverStatus.POWER_OFF
    ? showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Are you sure?"),
        content: const Text("This will turn off the rover and you must physically turn it back on again"),
        actions: [
          TextButton(child: const Text("Cancel"), onPressed: () => Navigator.of(context).pop()),
          ElevatedButton(
            onPressed: () { models.rover.settings.setStatus(input); Navigator.of(context).pop(); },
            child: const Text("Continue"),
          ),
        ],
      ),
    )
    : models.rover.settings.setStatus(input);

  @override
  Widget build(BuildContext context, FooterViewModel model) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Tooltip(  // battery level
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
      NetworkStatusIcon(  // network icon
        device: Device.SUBSYSTEMS,
        tooltip: "${model.connectionSummary}\nClick to reset",
        onPressed: model.resetNetwork,
      ),
      PopupMenuButton(  // rover mode
        tooltip: "Change mode",
        onSelected: (input) => changeMode(context, input),
        icon: Icon(
          getStatusIcon(model.status),
          color: getStatusColor(model.status),
        ),
        itemBuilder: (_) => [
          for (final value in RoverStatus.values)
            if (value != RoverStatus.DISCONNECTED)  // can't select this!
              PopupMenuItem(value: value, child: Text(value.humanName)),
        ],
      ),
      IconButton(  // LED strip
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

/// Allows the user to connect to the firmware directly, over Serial.
///
/// See [SerialModel] for an implementation.
class SerialButton extends ReusableReactiveWidget<SerialModel> {
  /// Provides a const constructor.
  SerialButton() : super(models.serial);

  @override
  Widget build(BuildContext context, SerialModel model) => PopupMenuButton(
    icon: Icon(
      Icons.usb,
      color: model.hasDevice ? Colors.green : context.colorScheme.onSecondary,
    ),
    tooltip: "Select device",
    onSelected: model.toggle,
    itemBuilder: (_) => [
      for (final String port in DelegateSerialPort.allPorts) PopupMenuItem(
        value: port,
        child: ListTile(
          title: Text(port),
          leading: model.isConnected(port) ? const Icon(Icons.check) : null,
        ),
      ),
    ],
  );
}

/// Displays the latest [TaskbarMessage] from [HomeModel.message].
class MessageDisplay extends ReusableReactiveWidget<HomeModel> {
  /// Whether to show an option to open the logs page.
  final bool showLogs;

  /// Provides a const constructor for this widget.
  MessageDisplay({required this.showLogs}) : super(models.home);

  /// Gets the appropriate icon for the given severity.
  IconData getIcon(Severity? severity) => switch (severity) {
    Severity.info => Icons.info,
    Severity.warning => Icons.warning,
    Severity.error => Icons.error,
    Severity.critical => Icons.dangerous,
    null => Icons.receipt_long,
  };

  /// Gets the appropriate color for the given severity.
  Color getColor(Severity? severity) => switch (severity) {
    Severity.info => Colors.transparent,
    Severity.warning => Colors.orange,
    Severity.error => Colors.red,
    Severity.critical => Colors.red.shade900,
    null => Colors.transparent,
  };

  @override
  Widget build(BuildContext context, HomeModel model) => SizedBox(
    height: 48,
    child: InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (context) => LogsPage())),
      child: Card(
        shadowColor: Colors.transparent,
        color: getColor(model.message?.severity),
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: (model.message == null && !showLogs) ? const SizedBox() : Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 4),
            Icon(getIcon(model.message?.severity), color: Colors.white),
            const SizedBox(width: 4),
            if (model.message == null) const Text("Open logs", style: TextStyle(color: Colors.white))
            else Tooltip(
              message: "Click to open logs",
              child: models.settings.easterEggs.enableClippy
                ? Row(children: [
                  Image.asset("assets/clippy.webp", width: 36, height: 36),
                  const Text(" -- "),
                  Text(model.message!.text, style: const TextStyle(color: Colors.white)),
                ],)
                : Text(model.message!.text, style: const TextStyle(color: Colors.white)),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    ),
  );
}
