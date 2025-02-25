import "dart:math";

import "package:flutter/material.dart";
import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/src/models/view/subsystems.dart";
import "package:rover_dashboard/widgets.dart";

/// A page displaying the status of Subsystems and Relays
///
/// In addition, there are also buttons and toggles for the relays and IMU
class SubsystemsPage extends ReactiveWidget<SubsystemsViewModel> {
  /// The index of this page
  final int index;

  /// Const constructor for subsystems page, initializing the page index
  const SubsystemsPage({required this.index, super.key});

  @override
  SubsystemsViewModel createModel() => SubsystemsViewModel();

  // if (model.subsystems.connectedDevices.isNotEmpty)
  // SizedBox(
  //   width: 250,
  //   height: min(
  //     constraints.maxHeight - 60,
  //     model.subsystems.connectedDevices.length * 100,
  //   ),
  //   child: FirmwareStatuses(model: model),
  // ),

  /// A widget to represent the connection status of a sensor
  Widget sensorConnectionStatus(String name, BoolState connectionStatus) {
    Widget text;
    Widget icon;
    if (connectionStatus == BoolState.BOOL_UNDEFINED) {
      text = Text("$name Connection Unknown");
      icon = const Icon(Icons.question_mark, color: Colors.grey);
    } else if (connectionStatus == BoolState.YES) {
      text = Text("$name Connected");
      icon = const Icon(Icons.check, color: Colors.green);
    } else {
      text = Text("$name Disconnected");
      icon = const Icon(Icons.close, color: Colors.red);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [text, const SizedBox(width: 5), icon],
    );
  }

  @override
  Widget build(BuildContext context, SubsystemsViewModel model) => LayoutBuilder(
    builder:
        (context, constraints) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PageHeader(
              pageIndex: index,
              children: [
                const SizedBox(width: 8),
                Text("Subsystems", style: context.textTheme.headlineMedium),
                const Spacer(),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: SizedBox(
                    height: constraints.maxHeight - 48,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Card(
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: RelaysView(model: model),
                            ),
                          ),
                          Card(
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Wrap(
                                runSpacing: 5,
                                alignment: WrapAlignment.center,
                                spacing: 15,
                                runAlignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  FilledButton(
                                    onPressed: () => model.zeroImu(),
                                    child: const Text("Zero IMU"),
                                  ),
                                  sensorConnectionStatus("GPS", model.subsystems.gpsConnected),
                                  sensorConnectionStatus("IMU", model.subsystems.imuConnected),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (model.subsystems.connectedDevices.isNotEmpty) ...[
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 225,
                    height: min(
                      constraints.maxHeight - 48,
                      model.subsystems.connectedDevices.length * 100,
                    ),
                    child: FirmwareStatuses(model: model),
                  ),
                ],
              ],
            ),
          ],
        ),
  );
}

/// A widget to display the status and toggle switches of the Relays
class RelaysView extends StatelessWidget {
  /// The [SubsystemsViewModel] containing the relay statuses
  final SubsystemsViewModel model;

  /// Const constructor for RelaysView
  const RelaysView({required this.model, super.key});

  /// A widget to display an icon representing whether or not the
  /// state received by the rover is the same as desired by the dashboard
  Widget desiredIcon(BoolState current, BoolState desired) {
    if (current != desired) {
      return const Tooltip(
        message: "Waiting for relay to respond",
        child: Icon(Icons.close, color: Colors.red),
      );
    } else {
      return const Tooltip(
        message: "Relay is in sync",
        child: Icon(Icons.check),
      );
    }
  }

  /// Widget for a single relay switch
  Widget relaySwitch(
    BuildContext context, {
    required String name,
    required BoolState Function(RelaysData relays) relayState,
    BoolState Function(RelaysCommand desired)? desiredState,
    RelaysCommand Function({required BoolState value})? toggleCommand,
  }) {
    final current = relayState(model.relays);
    final desired = desiredState?.call(model.desiredRelays);

    return SizedBox(
      width: 75,
      child: Column(
        children: [
          Text(
            name,
            style: context.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          RotatedBox(
            quarterTurns: -1,
            child: Switch(
              value: (desired ?? current).toBool(),
              onChanged: (value) {
                if (toggleCommand == null) {
                  return;
                }
                model.toggleRelay(
                  toggleCommand(value: value ? BoolState.ON : BoolState.OFF),
                );
              },
            ),
          ),
          if (current == BoolState.BOOL_UNDEFINED &&
              (desired == null || desired == BoolState.BOOL_UNDEFINED))
            const Tooltip(
              message: "Unknown Relay State",
              child: Icon(Icons.question_mark),
            )
          else if (desiredState != null)
            desiredIcon(
              relayState(model.relays),
              desiredState(model.desiredRelays),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text("Relays", style: context.textTheme.headlineSmall),
      const SizedBox(height: 5),
      Row(
        spacing: 5,
        mainAxisSize: MainAxisSize.min,
        children: [
          relaySwitch(
            context,
            name: "Front Left",
            relayState: (data) => data.frontLeftMotor,
            desiredState: (desired) => desired.frontLeftMotor,
            toggleCommand:
                ({required BoolState value}) =>
                    RelaysCommand(frontLeftMotor: value),
          ),
          relaySwitch(
            context,
            name: "Front Right",
            relayState: (data) => data.frontRightMotor,
            desiredState: (desired) => desired.frontRightMotor,
            toggleCommand:
                ({required BoolState value}) =>
                    RelaysCommand(frontRightMotor: value),
          ),
          relaySwitch(
            context,
            name: "Back Left",
            relayState: (data) => data.backLeftMotor,
            desiredState: (desired) => desired.backLeftMotor,
            toggleCommand:
                ({required BoolState value}) =>
                    RelaysCommand(backLeftMotor: value),
          ),
          relaySwitch(
            context,
            name: "Back Right",
            relayState: (data) => data.backRightMotor,
            desiredState: (desired) => desired.backRightMotor,
            toggleCommand:
                ({required BoolState value}) =>
                    RelaysCommand(backRightMotor: value),
          ),
        ],
      ),
      const SizedBox(height: 5),
      Row(
        spacing: 5,
        mainAxisSize: MainAxisSize.min,
        children: [
          relaySwitch(
            context,
            name: "Drive",
            relayState: (data) => data.drive,
            desiredState: (desired) => desired.drive,
            toggleCommand:
                ({required BoolState value}) => RelaysCommand(drive: value),
          ),
          relaySwitch(
            context,
            name: "Arm",
            relayState: (data) => data.arm,
            desiredState: (desired) => desired.arm,
            toggleCommand:
                ({required BoolState value}) => RelaysCommand(arm: value),
          ),
          relaySwitch(
            context,
            name: "Science",
            relayState: (data) => data.science,
            desiredState: (desired) => desired.science,
            toggleCommand:
                ({required BoolState value}) => RelaysCommand(science: value),
          ),
          SizedBox(
            width: 75,
            child: Column(
              children: [
                const Text("Mechanical Override", textAlign: TextAlign.center),
                Icon(
                  Icons.circle,
                  size: 36,
                  color: switch (model.relays.mechanicalOverride) {
                    BoolState.ON => Colors.green,
                    BoolState.OFF => Colors.red,
                    BoolState.BOOL_UNDEFINED => Colors.grey,
                    _ => Colors.grey,
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 5),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: model.turnAllOff,
            child: const Text("Turn All Off"),
          ),
          const SizedBox(width: 10),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            onPressed: model.turnAllOn,
            child: const Text("Turn All On"),
          ),
        ],
      ),
    ],
  );
}

/// Widget displaying the firmware statuses and supported version
class FirmwareStatuses extends StatelessWidget {
  /// The [SubsystemsViewModel] containing the connected firmware devices
  final SubsystemsViewModel model;

  /// Const constructor for Firmware Statuses
  const FirmwareStatuses({required this.model, super.key});

  /// Displays a card of the Firmware device's versions
  Widget firmwareCard(BuildContext context, Device device) => SizedBox(
    width: 100,
    child: Card(
      elevation: 5,
      margin: const EdgeInsets.all(4),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text(device.humanName, style: context.textTheme.headlineMedium),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Rover Version: ${model.metricsForDevice(device)!.version.format()}",
                ),
                Text(
                  "Supported Version: ${model.metricsForDevice(device)!.supportedVersion.format()}",
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => ListView(
    shrinkWrap: true,
    children: [
      for (final device in model.subsystems.connectedDevices)
        if (model.metricsForDevice(device) != null)
          firmwareCard(context, device),
    ],
  );
}
