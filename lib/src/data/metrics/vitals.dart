import "package:flutter/material.dart";
import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// Metrics about the vitals of the rover.
class VitalsMetrics extends Metrics {
  /// A const constructor.
  VitalsMetrics() : super(DriveData());

  @override
  String name = "Vitals";

  @override
  IconData icon = Icons.bolt;

  /// Provides access to the drive data.
  DriveData get drive => models.rover.metrics.drive.data;

  /// The severity of the [DriveData.batteryVoltage] readings.
  Severity? get voltageSeverity {
    if (drive.batteryVoltage == 0) return null;
    if (drive.batteryVoltage <= 20) {
      return Severity.critical;
    } else if (drive.batteryVoltage <= 21.5) {
      return Severity.warning;
    } else {
      return null;
    }
  }

  /// The severity of the [DriveData.batteryTemperature] readings.
  Severity? get temperatureSeverity {
    if (drive.batteryTemperature == 0) {
      return null;
    } else if (drive.batteryTemperature >= 40) {
      return Severity.critical;
    } else if (drive.batteryTemperature >= 30) {
      return Severity.warning;
    } else {
      return null;
    }
  }

  /// Publicly exposes [notifyListeners].
  void notify() => notifyListeners();

  @override
  List<MetricLine> get allMetrics => [
    MetricLine("Voltage: ${drive.batteryVoltage.toStringAsFixed(2)} V", severity: voltageSeverity),
    MetricLine("Current: ${drive.batteryCurrent.toStringAsFixed(2)} A"),
    MetricLine("Temperature: ${drive.batteryTemperature.toStringAsFixed(2)} °C", severity: temperatureSeverity),
  ];

  @override
  Version supportedVersion = Version(major: 0, minor: 0);

  @override
  Version parseVersion(Message message) => Version(major: 0, minor: 0);

  @override
  DriveCommand get versionCommand => DriveCommand(version: supportedVersion);
}
