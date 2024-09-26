import "package:flutter/foundation.dart";
import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// A view model for the footer that updates when needed.
class FooterViewModel with ChangeNotifier {
  /// Listens to all the relevant data sources.
  FooterViewModel() {
    models.rover.metrics.drive.addListener(notifyListeners);
    models.rover.status.addListener(notifyListeners);
    models.sockets.data.connectionStrength.addListener(notifyListeners);
    models.sockets.video.connectionStrength.addListener(notifyListeners);
    models.sockets.autonomy.connectionStrength.addListener(notifyListeners);
  }

  /// Access to the drive metrics.
  DriveMetrics get driveMetrics => models.rover.metrics.drive;

  String get _batteryVoltage => driveMetrics.batteryVoltage.toStringAsFixed(2);
  String get _batteryPercent => (driveMetrics.batteryPercentage * 100).toStringAsFixed(0);

  /// A message about the rover's battery voltage and percentage.
  String get batteryMessage => "Battery: $_batteryVoltage ($_batteryPercent%)";

  /// Whether the rover is connected.
  bool get isConnected => models.rover.isConnected;

  /// The color of the rover's LED strip.
  ProtoColor get ledColor => driveMetrics.data.color;

  /// The status of the rover.
  RoverStatus get status => models.rover.status.value;

  /// The percentage of the battery.
  double get batteryPercentage => driveMetrics.batteryPercentage;

  /// The connection strengths of all the connected devices.
  String get connectionSummary => models.sockets.connectionSummary;

  /// Resets the network sockets.
  Future<void> resetNetwork() async {
    await models.sockets.reset();
    models.home.setMessage(severity: Severity.info, text: "Network reset");
  }
}
