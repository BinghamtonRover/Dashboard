import "package:flutter/material.dart";
import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/services.dart";

/// Rover metrics for the status of the entire subsystems program
class SubsystemsMetrics extends Metrics<SubsystemsData> {
  /// Default constructor for subsystems metrics
  SubsystemsMetrics() : super(SubsystemsData());

  @override
  String name = "Subsystems";

  @override
  Version supportedVersion = Version(major: 1, minor: 0);

  @override
  IconData icon = Icons.cable;

  /// Utility method to get the display string of a sensor's connection
  String sensorConnectionStatus(String sensorName, BoolState value) =>
      switch (value) {
        BoolState.BOOL_UNDEFINED => "$sensorName Connection Unknown",
        BoolState.YES => "$sensorName: Connected",
        BoolState.NO => "$sensorName: Disconnected",
        BoolState() => "",
      };

  @override
  List<MetricLine> get allMetrics => [
    MetricLine(
      sensorConnectionStatus("GPS", data.gpsConnected),
      severity: data.gpsConnected == BoolState.NO ? Severity.error : null,
    ),
    MetricLine(
      sensorConnectionStatus("IMU", data.imuConnected),
      severity: data.imuConnected == BoolState.NO ? Severity.error : null,
    ),
    MetricLine(""),
    if (data.connectedDevices.isEmpty)
      MetricLine("No Firmware Connected")
    else ...[
      MetricLine("Firmware Devices:"),
      ...data.connectedDevices.map(
        (device) => MetricLine("  ${device.humanName}"),
      ),
    ],
  ];

  @override
  Version parseVersion(SubsystemsData message) => message.version;

  @override
  Message get versionCommand => SubsystemsCommand(version: supportedVersion);

  @override
  void update(SubsystemsData value) {
    if (!checkVersion(value)) return;
    services.files.logData(value);
    if (value.hasGpsConnected()) data.gpsConnected = value.gpsConnected;
    if (value.hasImuConnected()) data.imuConnected = value.imuConnected;

    data.connectedDevices.clear();
    data.connectedDevices.addAll(value.connectedDevices);

    notifyListeners();
  }
}
