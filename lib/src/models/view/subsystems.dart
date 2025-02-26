import "dart:async";

import "package:flutter/material.dart";
import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

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

  /// The last subsystems data received through the network
  SubsystemsData get subsystems => models.rover.metrics.subsystems.data;

  /// The current state of the relays as received from the network
  RelaysData get relays => models.rover.metrics.relays.data;

  /// The command for the desired state of the relays
  RelaysCommand desiredRelays = RelaysCommand();

  /// Default constructor for SubsystemsViewModel
  SubsystemsViewModel() {
    init();
  }

  /// Initializes the Subsystems View Model
  void init() {
    for (final metrics in supportedMetrics) {
      metrics.addListener(notifyListeners);
    }
    models.rover.metrics.subsystems.addListener(notifyListeners);
    models.rover.metrics.relays.addListener(notifyListeners);
  }

  @override
  void dispose() {
    for (final metrics in supportedMetrics) {
      metrics.removeListener(notifyListeners);
    }
    models.rover.metrics.subsystems.removeListener(notifyListeners);
    models.rover.metrics.relays.removeListener(notifyListeners);
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
