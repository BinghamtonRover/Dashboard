import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// Metrics about the vitals of the rover.
class VitalsMetrics extends Metrics {
  /// A const constructor.
  VitalsMetrics() : super(DriveData()) {
    models.rover.metrics.drive.addListener(notifyListeners);
  }

  @override
  Version parseVersion(Message message) => Version(major: 0, minor: 0);

  /// Provides access to the drive data.
  DriveData get drive => models.rover.metrics.drive.data;

  /// The severity of the [DriveData.batteryVoltage] readings.
  Severity? get voltageSeverity {
    if (drive.batteryVoltage == 0) return null;
    if (drive.batteryVoltage <= 25) {
      return Severity.critical;
    } else if (drive.batteryVoltage <= 26) {
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

  @override
  List<MetricLine> get allMetrics => [
    MetricLine("Voltage: ${drive.batteryVoltage.toStringAsFixed(2)} V", severity: voltageSeverity),
    MetricLine("Current: ${drive.batteryCurrent.toStringAsFixed(2)} A"),
    MetricLine("Temperature: ${drive.batteryTemperature.toStringAsFixed(2)} °C", severity: temperatureSeverity),
  ];

  @override
  String get name => "Vitals";

  @override
  Version get supportedVersion => Version(major: 0, minor: 0);

  @override
  DriveCommand get versionCommand => DriveCommand(version: supportedVersion);
}
