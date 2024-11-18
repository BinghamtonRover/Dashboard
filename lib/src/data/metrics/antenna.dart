import "package:rover_dashboard/data.dart";

/// Metrics about the antenna received from the Base Station
class AntennaMetrics extends Metrics<AntennaData> {
  /// Metrics for the antenna
  AntennaMetrics() : super(AntennaData());

  @override
  String get name => "Antenna";

  @override
  List<MetricLine> get allMetrics => [
    MetricLine("Angle: ${data.angle.toStringAsFixed(3)}"),
    MetricLine("Target Angle: ${data.targetAngle.toStringAsFixed(3)}"),
  ];

  @override
  Version parseVersion(AntennaData message) => message.version;

  @override
  Version get supportedVersion => Version(major: 1);

  @override
  Message get versionCommand => AntennaCommand(version: supportedVersion);
}
