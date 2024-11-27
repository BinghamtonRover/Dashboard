import "package:flutter/foundation.dart";
import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// A view model for the footer that updates when needed.
class FooterViewModel with ChangeNotifier {
  /// A list of other listenable models to subscribe to.
  List<Listenable> get otherModels => [
    models.rover.metrics.drive,
    models.rover.status,
    models.sockets.data.connectionStrength,
    models.sockets.video.connectionStrength,
    models.sockets.autonomy.connectionStrength,
  ];

  /// Listens to all the relevant data sources.
  FooterViewModel() {
    for (final model in otherModels) {
      model.addListener(notifyListeners);
    }
  }

  @override
  void dispose() {
    for (final model in otherModels) {
      model.removeListener(notifyListeners);
    }
    super.dispose();
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
  Future<void> resetNetwork() => models.sockets.reset();
}
