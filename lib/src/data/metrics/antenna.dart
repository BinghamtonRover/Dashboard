import "package:rover_dashboard/data.dart";

/// Metrics about the antenna received from the Base Station
class BaseStationMetrics extends Metrics<BaseStationData> {
  /// Metrics for the antenna
  BaseStationMetrics() : super(BaseStationData());

  @override
  String get name => "Base Station";

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
  Version get supportedVersion => Version(major: 1);

  @override
  Message get versionCommand => BaseStationCommand(version: supportedVersion);
}
