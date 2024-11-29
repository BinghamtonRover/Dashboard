import "dart:async";

import "package:flutter/material.dart";
import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";
import "package:rover_dashboard/src/models/view/builders/antenna_command.dart";

/// A view model for the mars page to render a diagram of the antenna position and alignment.
///
/// Shows a bird's-eye map of where the rover is, where the antenna is pointed towards, and where it should be pointed
///
class BaseStationModel with ChangeNotifier {
  /// The rover's current position.
  GpsCoordinates get roverPosition => models.rover.metrics.position.data.gps;

  /// The base station's position
  GpsCoordinates get stationPosition => GpsCoordinates(
        latitude: models.settings.baseStation.latitude,
        longitude: models.settings.baseStation.longitude,
        altitude: models.settings.baseStation.altitude,
      );

  /// The antenna data received from the rover
  BaseStationData data = BaseStationData();

  /// View model to control the command editor
  AntennaCommandBuilder commandBuilder = AntennaCommandBuilder();

  StreamSubscription<BaseStationData>? _dataSubscription;

  /// Constructor for base station model
  BaseStationModel() {
    init();
  }

  /// Initializes the view model
  Future<void> init() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    _dataSubscription = models.messages.stream.onMessage(
      name: BaseStationData().messageName,
      constructor: BaseStationData.fromBuffer,
      callback: onNewData,
    );
    models.rover.metrics.position.addListener(notifyListeners);
    models.settings.addListener(notifyListeners);
  }

  @override
  void dispose() {
    _dataSubscription?.cancel();
    models.settings.removeListener(notifyListeners);
    models.rover.metrics.position.removeListener(notifyListeners);
    super.dispose();
  }

  /// A handler to call when new data arrives. Updates [data] and the UI.
  void onNewData(BaseStationData value) {
    data = value;
    services.files.logData(value);
    notifyListeners();
  }
}
