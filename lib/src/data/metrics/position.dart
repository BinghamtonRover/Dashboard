import "package:flutter/material.dart";
import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// Metrics about the rover's position and orientation.
/// 
/// For simplicity, these metrics also track the first recorded GPS position as the base station.
class PositionMetrics extends Metrics<RoverPosition> {
  /// A collection of metrics relevant for monitoring the rover's GPS location.
  PositionMetrics() : super(RoverPosition());

	@override
	String name = "Position";

  @override
  Version supportedVersion = Version(major: 1);

  @override
  IconData icon = Icons.gps_fixed;

	/// The position of the base station. Setting this value updates the UI.
	GpsCoordinates get baseStation => models.settings.baseStation.gpsCoordinates;

  /// Gets the severity of the rover's orientation for both pitch and roll.
  Severity? getRotationSeverity(double orientation) {
    final abs = orientation.abs();
    if (abs >= 30) {
      return Severity.critical;
    } else if (abs >= 15) {
      return Severity.warning;
    } else if (abs >= 10) {
      return Severity.info;
    } else {
      return null;
    }
  }

  /// Gets the human friendly name of the RTK fix mode
  String getRTKString(RTKMode mode) => switch(mode) {
    RTKMode.RTK_FIXED => "Fixed",
    RTKMode.RTK_FLOAT => "Float",
    RTKMode.RTK_NONE => "None",
    _ => "None",
  };

	@override
	List<MetricLine> get allMetrics => [  
    MetricLine("GPS: "),
    MetricLine("  Latitude: ${data.gps.latitude.toStringAsFixed(10)}°",),
		MetricLine("  Longitude: ${data.gps.longitude.toStringAsFixed(10)}°",),
		MetricLine("  Altitude: ${data.gps.altitude.toStringAsFixed(2)} m"),
    MetricLine("  RTK Mode: ${getRTKString(data.gps.rtkMode)}"),
		MetricLine("Orientation:",),
		MetricLine("  X: ${data.orientation.x.toStringAsFixed(2)}°", severity: getRotationSeverity(data.orientation.x)),
		MetricLine("  Y: ${data.orientation.y.toStringAsFixed(2)}°", severity: getRotationSeverity(data.orientation.y)),
		MetricLine("  Z: ${data.orientation.z.toStringAsFixed(2)}°"),
    MetricLine("Distance: ${data.gps.distanceTo(baseStation).toStringAsFixed(2)} m",),
	];

  /// The angle to orient the rover on a front view map
  double get roll => data.orientation.y;

  /// The angle to orient the rover on a side view map
  double get pitch => data.orientation.x;

  /// The angle to orient the rover on the top-down map.
	double get angle => data.orientation.z;

  @override
  Version parseVersion(RoverPosition message) => message.version;

  @override
  Message get versionCommand => RoverPosition(version: supportedVersion);
}
