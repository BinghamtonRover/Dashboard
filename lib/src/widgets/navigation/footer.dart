import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/pages.dart";
import "package:rover_dashboard/services.dart";
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
            ViewsCounter(),
            const SizedBox(width: 8),
            GamepadButton(models.rover.controller1),
            const SizedBox(width: 8),
            GamepadButton(models.rover.controller2),
            const SizedBox(width: 8),
            GamepadButton(models.rover.controller3),
            SerialButton(),
            const SizedBox(width: 4),
            const StatusIcons(),
          ],
        ),
      ],
    ),
	);
}

/// A few icons displaying the rover's current status.
class StatusIcons extends StatelessWidget {
	/// Provides a const constructor.
	const StatusIcons();

	/// An appropriate WiFi icon in increments of 1/5 connection strength.
	IconData getNetworkIcon(double percentage) {
		if (percentage      >= 0.8) { return Icons.signal_wifi_statusbar_4_bar; }
		else if (percentage >= 0.6) { return Icons.network_wifi_3_bar; }
		else if (percentage >= 0.4) { return Icons.network_wifi_2_bar; }
		else if (percentage >= 0.2) { return Icons.network_wifi_1_bar; }
		else { return Icons.signal_wifi_0_bar; }
	}

	/// An appropriate battery icon in increments of 1/8 battery level.
	IconData getBatteryIcon(double percentage) {
		if (percentage >= 0.84) { return Icons.battery_full; }  // 80-100
		else if (percentage >= 0.72) { return Icons.battery_6_bar; }  // 60-80
		else if (percentage >= 0.60) { return Icons.battery_5_bar; }  // 60-80
		else if (percentage >= 0.48) { return Icons.battery_4_bar; }  // 60-80
		else if (percentage >= 0.36) { return Icons.battery_3_bar; }  // 60-80
		else if (percentage >= 0.24) { return Icons.battery_2_bar; }  // 40-60
		else if (percentage >= 0.12) { return Icons.battery_1_bar; }  // 20-40
		else { return Icons.battery_0_bar; }  // 0-20
	}

	/// An appropriate battery icon representing the rover's current status.
	IconData getStatusIcon(RoverStatus status) {
		switch (status) {
			case RoverStatus.DISCONNECTED: return Icons.power_off;
			case RoverStatus.POWER_OFF: return Icons.power_off;
			case RoverStatus.IDLE: return Icons.pause_circle;
			case RoverStatus.MANUAL: return Icons.play_circle;
			case RoverStatus.AUTONOMOUS: return Icons.smart_toy;
			case RoverStatus.RESTART: return Icons.restart_alt;
		}
		throw ArgumentError("Unrecognized rover status: $status");
	}

	/// A color representing a meter's fill.
	Color getColor(double percentage) {
		if (percentage > 0.45) { return Colors.green; }
		else if (percentage > 0.2) { return Colors.orange; }
		else if (percentage > 0.0) { return Colors.red; }
		else { return Colors.black; }
	}

	/// The color of the rover's status icon.
	Color getStatusColor(RoverStatus status) {
		switch(status) {
			case RoverStatus.DISCONNECTED: return Colors.black;
			case RoverStatus.IDLE: return Colors.yellow;
			case RoverStatus.MANUAL: return Colors.green;
			case RoverStatus.AUTONOMOUS: return Colors.blueGrey;
			case RoverStatus.POWER_OFF: return Colors.red;
			case RoverStatus.RESTART: return Colors.yellow;
		}
		throw ArgumentError("Unrecognized rover status: $status");
	}

	@override
	Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
		children: [
			AnimatedBuilder(  // battery level
				animation: Listenable.merge([models.rover.metrics.drive, models.rover.status]),
				builder: (context, _) => Tooltip(
					message: "Battery: ${models.rover.metrics.drive.batteryVoltage.toStringAsFixed(2)} "
            "(${(models.rover.metrics.drive.batteryPercentage * 100).toStringAsFixed(0)}%)",
					child: Icon(
						models.rover.isConnected
							? getBatteryIcon(models.rover.metrics.drive.batteryPercentage)
							: Icons.battery_unknown,
						color: models.rover.isConnected 
              ? getColor(models.rover.metrics.drive.batteryPercentage)
              : Colors.black,
					),
				),
			),
			ValueListenableBuilder<double>(  // network strength
				valueListenable: models.sockets.data.connectionStrength,
				builder: (context, value, child) => IconButton(
					tooltip: "${models.sockets.connectionSummary}\nClick to reset",
					icon: Icon(
						value > 0 ? getNetworkIcon(value) : Icons.signal_wifi_off_outlined,
						color: getColor(value),
					),
					onPressed: () async {
						await models.sockets.reset();
						models.home.setMessage(severity: Severity.info, text: "Network reset");
					},
				),
			),
			ValueListenableBuilder<RoverStatus>(  // status
				valueListenable: models.rover.status,
				builder: (context, value, child) => PopupMenuButton(
					tooltip: "Change mode",
					onSelected: (value) async {
            if (value == RoverStatus.POWER_OFF) {
              await showDialog<void>(
                context: context, 
                builder: (ctx) => AlertDialog(
                  title: const Text("Are you sure?"),
                  content: const Text("This will turn off the rover and you must physically turn it back on again"),
                  actions: [
                    TextButton(child: const Text("Cancel"), onPressed: () => Navigator.of(context).pop()),
                    ElevatedButton(
                      onPressed: () { models.rover.settings.setStatus(value); Navigator.of(context).pop(); },
                      child: const Text("Continue"), 
                    ),
                  ],
                ),
              );
            } else {
              await models.rover.settings.setStatus(value);
            }
          },
          icon: Icon(
						getStatusIcon(value),
						color: getStatusColor(value),
					),
					itemBuilder: (_) => [
						for (final value in RoverStatus.values)
							if (value != RoverStatus.DISCONNECTED)  // can't select this!
								PopupMenuItem(value: value, child: Text(value.humanName)),
					],
				),
			),
			const SizedBox(width: 4),
		],
	);
}

/// A dropdown to select more or less views.
class ViewsCounter extends ReusableReactiveWidget<ViewsModel> {
	/// Provides a const constructor for this widget.
	ViewsCounter() : super(models.views);

	@override
	Widget build(BuildContext context, ViewsModel model) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Text("Views:"),
      const SizedBox(width: 4),
      DropdownButton<int>(
        iconEnabledColor: Colors.black,
        value: model.views.length,
        onChanged: model.setNumViews,
        items: [
          for (int i = 1; i <= 4; i++) DropdownMenuItem(
            value: i,
            child: Center(child: Text(i.toString())),
          ),
          const DropdownMenuItem(
            value: 8,
            child: Center(child: Text("8")),
          ),
        ],
      ),
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
      for (final String port in SerialDevice.availablePorts) PopupMenuItem(
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
	IconData getIcon(Severity? severity) {
		switch (severity) {
			case Severity.info: return Icons.info;
			case Severity.warning: return Icons.warning;
			case Severity.error: return Icons.error;
			case Severity.critical: return Icons.dangerous;
      case null: return Icons.receipt_long;
		}
	}	

	/// Gets the appropriate color for the given severity.
	Color getColor(Severity? severity) {
		switch (severity) {
			case null: return Colors.transparent;
			case Severity.info: return Colors.transparent;
			case Severity.warning: return Colors.orange;
			case Severity.error: return Colors.red;
			case Severity.critical: return Colors.red.shade900;
		}
	}

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
