import "package:flutter/material.dart";

import "package:burt_network/serial.dart";
import "package:rover_dashboard/app.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/pages.dart";
import "package:rover_dashboard/widgets.dart";

/// A menu that allows the user to change the [Controller]s [OperatingMode]s.
class ControllerMenu extends StatelessWidget {
  /// Color to display when no controllers are connected
  final Color disconnectColor;

  /// A const constructor.
  const ControllerMenu({super.key, this.disconnectColor = Colors.black});

  /// Toggles the pop-up menu.
  void toggleMenu(MenuController controller) {
    if (controller.isOpen) {
      controller.close();
    } else {
      controller.open();
    }
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: models.rover.controllersListener,
    builder: (context, _) => MenuAnchor(
      alignmentOffset: const Offset(-48, 0),
      builder: (context, controller, child) => IconButton(
        icon: const Icon(Icons.sports_esports_rounded),
        color: models.rover.controllers.any((controller) => controller.isConnected)
          ? Colors.green : disconnectColor,
        onPressed: () => toggleMenu(controller),
      ),
      menuChildren: [
        for (final controller in models.rover.controllers)
          SubmenuButton(
            menuChildren: [
              for (final mode in OperatingMode.values)
                MenuItemButton(
                  onPressed: () => controller.setMode(mode),
                  closeOnActivate: false,
                  child: Text(mode.name),
                ),
            ],
            leadingIcon: GamepadButton(controller),
            child: Text(controller.mode.name),
          ),
      ],
    ),
  );
}

/// Base class for navigation toolbar components.
abstract class NavigationToolbarComponent extends StatelessWidget {
  /// Creates a navigation toolbar component.
  const NavigationToolbarComponent({super.key});
}

/// Navigation toolbar for the rover dashboard footer.
class NavigationToolbar extends StatelessWidget {
  /// The height of the navigation toolbar.
  static const double toolbarHeight = 48;
  
  /// The background color of the toolbar.
  final Color backgroundColor;
  
  /// The Left component (Logs).
  final NavigationToolbarComponent? leading;
  
  /// The Center component(Battery Indicator).
  final NavigationToolbarComponent? center;
  
  /// The Right component ().
  final NavigationToolbarComponent? trailing;

  /// Creates a navigation toolbar.
  const NavigationToolbar({
    super.key,
    this.backgroundColor = binghamtonGreen,
    this.leading,
    this.center,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: backgroundColor,
    child: SizedBox(
      height: toolbarHeight,
      child: Row(
        children: [
          if (leading != null)
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: leading,
              ),
            ),
          if (center != null)
            Expanded(
              child: Center(
                child: center,
              ),
            ),
          if (trailing != null)
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: trailing,
              ),
            ),
        ],
      ),
    ),
  );
}

/// The footer navigation toolbar, responsible for showing vitals and logs.
class Footer extends StatefulWidget {
  /// Whether to show logs. Disable this when on the logs page.
  final bool showLogs;
  
  /// Creates the footer.
  const Footer({super.key, this.showLogs = true});

  @override
  FooterState createState() => FooterState();
}

/// State for the Footer widget that manages the shared FooterViewModel.
class FooterState extends State<Footer> {
  late FooterViewModel _footerModel;

  @override
  void initState() {
    super.initState();
    _footerModel = FooterViewModel();
  }

  @override
  void dispose() {
    _footerModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => NavigationToolbar(
    leading: MessageDisplayComponent(showLogs: widget.showLogs),
    center: BatteryWarningDisplayComponent(footerModel: _footerModel),
    trailing: StatusIconsComponent(footerModel: _footerModel),
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
class StatusIcons extends StatelessWidget {
  /// The footer view model to use for data.
  final FooterViewModel? footerModel;

  /// A const constructor.
  const StatusIcons({super.key, this.footerModel});

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
  Widget build(BuildContext context) {
    if (footerModel != null) {
      return ListenableBuilder(
        listenable: footerModel!,
        builder: (context, _) => _buildStatusIcons(context, footerModel!),
      );
    } else {
      // Fallback to creating model internally for backward compatibility
      return _ReactiveStatusIcons();
    }
  }

  Widget _buildStatusIcons(BuildContext context, FooterViewModel model) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      const ControllerMenu(),
      SerialButton(),
      IconButton(
        tooltip: model.batteryMessage,
        onPressed: null,
        icon: Icon(
          model.isConnected
            ? getBatteryIcon(model.batteryPercentage)
            : Icons.battery_unknown,
          color:  model.isConnected
            ? StatusIcons.getColor(model.batteryPercentage)
            : Colors.black,
        ),
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
      NetworkStatusIcon(  // network icon
        device: Device.SUBSYSTEMS,
        tooltip: "${model.connectionSummary}\nClick to reset",
        onPressed: model.resetNetwork,
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

/// Reactive version of StatusIcons for backward compatibility.
class _ReactiveStatusIcons extends ReactiveWidget<FooterViewModel> {
  @override
  FooterViewModel createModel() => FooterViewModel();

  @override
  Widget build(BuildContext context, FooterViewModel model) => StatusIcons(footerModel: model)._buildStatusIcons(context, model);
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
      color: model.hasDevice ? Colors.green : Colors.black,
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
      onTap: showLogs ? () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (context) => LogsPage())) : null,
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

/// Displays a flashing battery warning when voltage is too low.
class BatteryWarningDisplay extends StatefulWidget {
  /// The footer view model to use for data.
  final FooterViewModel footerModel;

  /// Creates the battery warning display.
  const BatteryWarningDisplay({required this.footerModel, super.key});

  @override
  BatteryWarningDisplayState createState() => BatteryWarningDisplayState();
}

/// State for the battery warning display with flashing animation.
class BatteryWarningDisplayState extends State<BatteryWarningDisplay>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );
    _animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: 1)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 37.5,
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(1),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1, end: 0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 37.5,
      ),
    ]).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.footerModel,
    builder: (context, _) {
      final message = widget.footerModel.batteryWarningMessage;
      final severity = widget.footerModel.batteryWarningSeverity;
      
      if (message == null || severity == null) {
        _animationController.stop();
        return const SizedBox.shrink();
      }

      if (severity == Severity.warning) {
        _animationController.repeat();
      } else if (severity == Severity.critical) {
        _animationController.repeat();
      } else {
        _animationController.stop();
        _animationController.value = 1.0;
      }

      return AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final baseColor = severity.color ?? Colors.black;
          Color cardColor;
          
          if (severity == Severity.warning) {
            // For warnings, opacity animation (fade in/out)
            return Opacity(
              opacity: _animation.value,
              child: Card(
                color: baseColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          } else if (severity == Severity.critical) {
            // For critical, brightness animation (bright to dark)
            final brightness = 0.3 + (_animation.value * 0.7); // Range from 0.3 to 1.0
            cardColor = Color.lerp(baseColor.withValues(alpha: 0.3), baseColor, brightness) ?? baseColor;
          } else {
            cardColor = baseColor;
          }
          
          return Card(
            color: cardColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

/// Navigation toolbar component for displaying status icons.
class StatusIconsComponent extends NavigationToolbarComponent {
  /// The footer view model to use for data.
  final FooterViewModel footerModel;

  /// Creates a status icons component.
  const StatusIconsComponent({required this.footerModel, super.key});

  @override
  Widget build(BuildContext context) => StatusIcons(footerModel: footerModel);
}

/// Navigation toolbar component for displaying messages.
class MessageDisplayComponent extends NavigationToolbarComponent {
  /// Whether to show logs. Disable this when on the logs page.
  final bool showLogs;

  /// Creates a message display component.
  const MessageDisplayComponent({required this.showLogs, super.key});

  @override
  Widget build(BuildContext context) => MessageDisplay(showLogs: showLogs);
}

/// Navigation toolbar component for displaying battery warnings.
class BatteryWarningDisplayComponent extends NavigationToolbarComponent {
  /// The footer view model to use for data.
  final FooterViewModel footerModel;

  /// Creates a battery warning display component.
  const BatteryWarningDisplayComponent({required this.footerModel, super.key});

  @override
  Widget build(BuildContext context) => BatteryWarningDisplay(footerModel: footerModel);
}
