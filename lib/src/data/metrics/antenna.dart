import "package:flutter/material.dart";
import "package:rover_dashboard/data.dart";

/// Metrics about the antenna received from the Base Station
class BaseStationMetrics extends Metrics<BaseStationData> {
  /// Metrics for the antenna
  BaseStationMetrics() : super(BaseStationData());

  @override
  String name = "Base Station";

  @override
  Version supportedVersion = Version(major: 1);

  @override
  IconData icon = Icons.settings_input_antenna;

  String _controlModeName(AntennaControlMode mode) => switch(mode) {
    AntennaControlMode.ANTENNA_CONTROL_MODE_UNDEFINED => "Unknown",
    AntennaControlMode.TRACK_ROVER => "Track Rover",
    AntennaControlMode.MANUAL_CONTROL => "Manual",
    _ => "Unknown",
  };

  @override
  List<MetricLine> get allMetrics => [
    MetricLine("Control Mode: ${_controlModeName(data.mode)}"),
    MetricLine("Antenna:"),
    MetricLine(
      "  Is Moving: ${data.antenna.swivel.isMoving.displayName}",
      severity: data.antenna.swivel.isMoving.toBool() ? Severity.info : null,
    ),
		MetricLine("  Direction: ${data.antenna.swivel.direction.humanName}"),
		MetricLine("  Steps: ${data.antenna.swivel.currentStep} --> ${data.antenna.swivel.targetStep}"),
		MetricLine("  Angle: ${data.antenna.swivel.currentAngle.toDegrees() % 360}°"),
		MetricLine("  Target Angle: ${data.antenna.swivel.targetAngle.toDegrees() % 360}°"),    
  ];

  @override
  Version parseVersion(BaseStationData message) => message.version;

  @override
  Message get versionCommand => BaseStationCommand(version: supportedVersion);

  /// Updates the base station metrics with only firmware data
  void updateFromFirmware(AntennaFirmwareData firmwareData) =>
      update(BaseStationData(antenna: firmwareData));
}
