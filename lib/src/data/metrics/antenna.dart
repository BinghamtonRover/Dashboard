import "package:rover_dashboard/data.dart";

/// Metrics about the antenna received from the Base Station
class BaseStationMetrics extends Metrics<BaseStationData> {
  /// Metrics for the antenna
  BaseStationMetrics() : super(BaseStationData());

  @override
  String get name => "Base Station";

  @override
  List<MetricLine> get allMetrics => [
    MetricLine("Antenna:"),
    MetricLine("  Angle: ${data.antenna.swivel.currentAngle.toStringAsFixed(3)}"),
    MetricLine("  Target Angle: ${data.antenna.swivel.targetAngle.toStringAsFixed(3)}"),
  ];

  @override
  Version parseVersion(BaseStationData message) => message.version;

  @override
  Version get supportedVersion => Version(major: 1);

  @override
  Message get versionCommand => BaseStationCommand(version: supportedVersion);
}
