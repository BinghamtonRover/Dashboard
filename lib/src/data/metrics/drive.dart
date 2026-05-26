import "package:collection/collection.dart";
import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";

/// Metrics reported by the drive subsystem.
class DriveMetrics extends Metrics<DriveData> {
	/// A collection of metrics relevant for monitoring the rover's electrical status.
	DriveMetrics() : super(DriveData());

	@override
	String name = "Drive";

  @override
  Version supportedVersion = Version(major: 1, minor: 2);

  @override
  IconData icon = Icons.drive_eta;

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
    if (data.batteryVoltage <= 20) {
      return Severity.critical;
    } else if (data.batteryVoltage <= 22) {
      return Severity.warning;
    } else {
      return null;
    }
  }

  @override
  List<MetricLine> get allMetrics => [
    MetricLine(
      "Throttle: ${data.throttle.toStringAsFixed(2)}",
      severity: throttleSeverity,
    ),
    MetricLine("Left: ${data.left.toStringAsFixed(2)}"),
    MetricLine("Right: ${data.right.toStringAsFixed(2)}"),
    MetricLine(
      "Left Side: ${data.frontLeftMotor.speed.toStringAsFixed(1)}, ${data.middleLeftMotor.speed.toStringAsFixed(1)}, ${data.backLeftMotor.speed.toStringAsFixed(1)}",
    ),
    MetricLine(
      "Right Side: ${data.frontRightMotor.speed.toStringAsFixed(1)}, ${data.middleRightMotor.speed.toStringAsFixed(1)}, ${data.backRightMotor.speed.toStringAsFixed(1)}",
    ),
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
    if(value.hasFrontLeftMotor()) data.frontLeftMotor = value.frontLeftMotor;
    if(value.hasMiddleLeftMotor()) data.middleLeftMotor = value.middleLeftMotor;
    if(value.hasBackLeftMotor()) data.backLeftMotor = value.backLeftMotor;
    if(value.hasFrontRightMotor()) data.frontRightMotor = value.frontRightMotor;
    if(value.hasMiddleRightMotor()) data.middleRightMotor = value.middleRightMotor;
    if(value.hasBackRightMotor()) data.backRightMotor = value.backRightMotor;
    if (value.color != ProtoColor.PROTO_COLOR_UNDEFINED) data.color = value.color;
    if (value.batteryTemperature != 0) data.batteryTemperature = value.batteryTemperature;

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
  double get batteryPercentage => (batteryVoltage - 19) / (24.5 - 19); // 19-24.5 as a percentage

  @override
  Version parseVersion(DriveData message) => message.version;

  @override
  Message get versionCommand => DriveCommand(version: supportedVersion);
}
