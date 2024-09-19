import "package:collection/collection.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";

/// Metrics reported by the drive subsystem.
class DriveMetrics extends Metrics<DriveData> {
	/// A collection of metrics relevant for monitoring the rover's electrical status.
	DriveMetrics() : super(DriveData());

	@override
	String get name => "Drive";

  /// The severity based on the throttle speed.
  Severity? get throttleSeverity {
    if (data.throttle == 0) {
      return null;
    } else if (data.throttle <= 0.3) {
      return Severity.info;
    } else if (data.throttle <= 0.75) {
      return Severity.warning;
    } else {
      return Severity.critical;
    }
  }

  /// The severity for the electrical metrics.
  Severity? get electricalSeverity {
    if (data.batteryVoltage == 0) return null;
    if (data.batteryVoltage <= 25) {
      return Severity.critical;
    } else if (data.batteryVoltage <= 26) {
      return Severity.warning;
    } else {
      return null;
    }
  }

	@override
	List<MetricLine> get allMetrics => [
		MetricLine("Throttle: ${data.throttle.toStringAsFixed(2)}", severity: throttleSeverity),
		MetricLine("Left: ${data.left.toStringAsFixed(2)}"),
		MetricLine("Right: ${data.right.toStringAsFixed(2)}"),
    MetricLine("Left Side: ${data.frontLeft.toStringAsFixed(1)}, ${data.middleLeft.toStringAsFixed(1)}, ${data.backLeft.toStringAsFixed(1)}"),
    MetricLine("Right Side: ${data.frontRight.toStringAsFixed(1)}, ${data.middleRight.toStringAsFixed(1)}, ${data.backRight.toStringAsFixed(1)}"),
  ];

	@override
	void update(DriveData value) {
		// Since the newValues are often zero, [Metrics.merge] won't work.
    if (!checkVersion(value)) return;
		services.files.logData(value);
    final oldThrottle = data.throttle;
		if (value.setLeft) data.left = value.left;
		if (value.setRight) data.right = value.right;
		if (value.setThrottle) data.throttle = value.throttle;
    if (value.hasBatteryCurrent()) data.batteryCurrent = value.batteryCurrent;
    if (value.hasBatteryVoltage()) data.batteryVoltage = value.batteryVoltage;
    if (value.hasBatteryTemperature()) data.batteryTemperature = value.batteryTemperature;
    if(value.hasFrontLeft()) data.frontLeft = value.frontLeft;
    if(value.hasMiddleLeft()) data.middleLeft = value.middleLeft;
    if(value.hasBackLeft()) data.backLeft = value.backLeft;
    if(value.hasFrontRight()) data.frontRight = value.frontRight;
    if(value.hasMiddleRight()) data.middleRight = value.middleRight;
    if(value.hasBackRight()) data.backRight = value.backRight;
    if (value.color != ProtoColor.PROTO_COLOR_UNDEFINED) data.color = value.color;

    if (
      (data.throttle > 0.05 && oldThrottle < 0.05) ||
      (data.throttle < 0.05 && oldThrottle > 0.05)
    ) {
      models.rover.controllers.firstWhereOrNull(
        (controller) => controller.mode == OperatingMode.drive || controller.mode == OperatingMode.modernDrive,
      )?.gamepad.pulse();
    }
    notifyListeners();
	}

  /// The battery voltage.
  double get batteryVoltage => data.batteryVoltage;

  /// The charge of the battery, as a percentage.
  double get batteryPercentage => (batteryVoltage - 24) / 6;  // 24-30 as a percentage

  @override
  Version get supportedVersion => Version(major: 1);

  @override
  Version parseVersion(DriveData message) => message.version;

  @override
  Message get versionCommand => DriveCommand(version: supportedVersion);
}
