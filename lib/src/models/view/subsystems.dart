import "dart:async";

import "package:flutter/material.dart";
import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";

/// View model for the Subsystems Page
class SubsystemsViewModel extends ChangeNotifier {
  /// The metrics to listen to for firmware version displaying
  List<Metrics> get supportedMetrics => [
    models.rover.metrics.arm,
    models.rover.metrics.gripper,
    models.rover.metrics.drive,
    models.rover.metrics.science,
    models.rover.metrics.relays,
  ];

  /// The corresponding Metrics for the [device]
  Metrics? metricsForDevice(Device device) => switch (device) {
    Device.ARM => models.rover.metrics.arm,
    Device.GRIPPER => models.rover.metrics.gripper,
    Device.DRIVE => models.rover.metrics.drive,
    Device.SCIENCE => models.rover.metrics.science,
    Device.RELAY => models.rover.metrics.relays,
    _ => null,
  };

  StreamSubscription<SubsystemsData>? _dataSubscription;
  StreamSubscription<RelaysData>? _relaysSubscription;

  /// The last subsystems data received through the network
  SubsystemsData subsystems = SubsystemsData(
    // connectedDevices: [Device.DRIVE, Device.ARM, Device.GRIPPER, Device.SCIENCE],
  );

  /// The current state of the relays as received from the network
  RelaysData relays = RelaysData();

  /// The command for the desired state of the relays
  RelaysCommand desiredRelays = RelaysCommand();

  /// Default constructor for SubsystemsViewModel
  SubsystemsViewModel() {
    init();
  }

  /// Initializes the Subsystems View Model
  void init() {
    _dataSubscription = models.messages.stream.onMessage(
      name: SubsystemsData().messageName,
      constructor: SubsystemsData.fromBuffer,
      callback: onSubsystemsData,
    );
    _relaysSubscription = models.messages.stream.onMessage(
      name: RelaysData().messageName,
      constructor: RelaysData.fromBuffer,
      callback: onRelaysData,
    );

    for (final metrics in supportedMetrics) {
      metrics.addListener(notifyListeners);
    }
  }

  @override
  void dispose() {
    _dataSubscription?.cancel();
    _relaysSubscription?.cancel();
    for (final metrics in supportedMetrics) {
      metrics.removeListener(notifyListeners);
    }
    super.dispose();
  }

  /// Sets the desired relay state specified by the [toggleCommand]
  void toggleRelay(RelaysCommand toggleCommand) {
    models.messages.sendMessage(toggleCommand);
    desiredRelays.mergeFromMessage(toggleCommand);

    notifyListeners();
  }

  /// Sends a command to turn off all the relays
  void turnAllOff() {
    toggleRelay(
      RelaysCommand(
        arm: BoolState.OFF,
        drive: BoolState.OFF,
        science: BoolState.OFF,
        frontLeftMotor: BoolState.OFF,
        frontRightMotor: BoolState.OFF,
        backLeftMotor: BoolState.OFF,
        backRightMotor: BoolState.OFF,
        bypass: BoolState.OFF,
      ),
    );
  }

  /// Sends a command to turn on all the relays
  void turnAllOn() {
    toggleRelay(
      RelaysCommand(
        arm: BoolState.ON,
        drive: BoolState.ON,
        science: BoolState.ON,
        frontLeftMotor: BoolState.ON,
        frontRightMotor: BoolState.ON,
        backLeftMotor: BoolState.ON,
        backRightMotor: BoolState.ON,
        bypass: BoolState.ON,
      ),
    );
  }

  /// Handles an incoming [SubsystemsData]
  void onSubsystemsData(SubsystemsData data) {
    subsystems.mergeFromMessage(data);

    subsystems.connectedDevices.clear();
    subsystems.connectedDevices.addAll(data.connectedDevices);

    services.files.logData(data);

    notifyListeners();
  }

  /// Handles an incoming [RelaysData] message
  void onRelaysData(RelaysData data) {
    services.files.logData(data);
    relays.mergeFromMessage(data);

    notifyListeners();
  }

  /// Sends a command to zero the Rover's IMU
  Future<void> zeroImu() async {
    final command = SubsystemsCommand(
      zeroIMU: true,
      version: Version(major: 1, minor: 0),
    );
    if (await models.sockets.data.tryHandshake(
      message: command,
      timeout: const Duration(seconds: 1),
      constructor: SubsystemsCommand.fromBuffer,
    )) {
      models.home.setMessage(severity: Severity.info, text: "Zeroed IMU");
    } else {
      models.home.setMessage(
        severity: Severity.error,
        text: "No confirmation if the IMU has been zeroed",
      );
    }
  }
}
