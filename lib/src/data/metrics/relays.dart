import "package:rover_dashboard/data.dart";

/// Metrics for the relay devices on the rover
class RelayMetrics extends Metrics<RelaysData> {
  /// Default constructor for Relay Metrics
  RelayMetrics() : super(RelaysData());

  @override
  List<MetricLine> get allMetrics => [
    MetricLine("Override: ${data.mechanicalOverride.displayName}"),
    MetricLine("Front Left: ${data.frontLeftMotor.displayName}"),
    MetricLine("Front Right: ${data.frontRightMotor.displayName}"),
    MetricLine("Back Left: ${data.backLeftMotor.displayName}"),
    MetricLine("Back Right: ${data.backRightMotor.displayName}"),
    MetricLine("Drive: ${data.drive.displayName}"),
    MetricLine("Arm: ${data.arm.displayName}"),
    MetricLine("Science: ${data.science.displayName}"),
  ];

  @override
  String get name => "Relays";

  @override
  Version parseVersion(RelaysData message) => Version();

  @override
  Version get supportedVersion => Version();

  @override
  Message get versionCommand => RelaysCommand();
}
