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
    MetricLine("  Angle: ${data.antenna.angle.toStringAsFixed(3)}"),
    MetricLine("  Target Angle: ${data.antenna.targetAngle.toStringAsFixed(3)}"),
    MetricLine("Orientation:",),
		MetricLine("  X: ${data.orientation.x.toStringAsFixed(2)}°"),
		MetricLine("  Y: ${data.orientation.y.toStringAsFixed(2)}°"),
		MetricLine("  Z: ${data.orientation.z.toStringAsFixed(2)}°"),
  ];

  @override
  Version parseVersion(BaseStationData message) => message.version;

  @override
  Version get supportedVersion => Version(major: 1);

  @override
  Message get versionCommand => AntennaCommand(version: supportedVersion);
}
