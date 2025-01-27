import "dart:async";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// A [ValueBuilder] to modify and send an [BaseStationCommand]
class AntennaCommandBuilder extends ValueBuilder<BaseStationCommand> {
  /// The type of control for the antenna
  AntennaControlMode mode = AntennaControlMode.TRACK_ROVER;

  bool _overrideRoverCoordinates = false;

  /// Whether or not to override the coordinates of the rover
  bool get overrideRoverCoordinates => _overrideRoverCoordinates;

  set overrideRoverCoordinates(bool value) {
    _overrideRoverCoordinates = value;
    notifyListeners();
  }

  /// The View Model for the coordinates to point towards
  GpsBuilder roverCoordinatesOverride = GpsBuilder();

  /// Whether or not to override the base station coordinates
  bool _overrideBaseStationCoordinates = false;

  /// Whether or not to override the base station coordinates
  bool get overrideBaseStationCoordinates => _overrideBaseStationCoordinates;

  set overrideBaseStationCoordinates(bool value) {
    _overrideBaseStationCoordinates = value;
    notifyListeners();
  }

  /// The View Model for the coordinates of the base station
  GpsBuilder baseStationCoordinatesOverride = GpsBuilder();

  /// The latest handshake received by the base station
  BaseStationCommand? _handshake;

  StreamSubscription<BaseStationCommand>? _handshakeSubscription;

  /// Constructor for the view model
  AntennaCommandBuilder() {
    init();
  }

  /// Initializes the view model
  void init() {
    _handshakeSubscription = models.messages.stream.onMessage(
      name: BaseStationCommand().messageName,
      constructor: BaseStationCommand.fromBuffer,
      callback: (command) => _handshake = command,
    );
  }

  @override
  void dispose() {
    _handshakeSubscription?.cancel();
    super.dispose();
  }

  @override
  List<ValueBuilder<dynamic>> get otherBuilders =>
      [roverCoordinatesOverride, baseStationCoordinatesOverride];

  @override
  bool get isValid =>
      (!overrideRoverCoordinates || roverCoordinatesOverride.isValid) &&
      (!overrideBaseStationCoordinates ||
          baseStationCoordinatesOverride.isValid);

  @override
  BaseStationCommand get value => BaseStationCommand(
        version: Version(major: 1),
        mode: mode,
        roverCoordinatesOverrideOverride:
            overrideRoverCoordinates ? roverCoordinatesOverride.value : null,
        baseStationCoordinatesOverride: overrideBaseStationCoordinates
            ? baseStationCoordinatesOverride.value
            : null,
      );

  /// Sends the command to the base station socket
  Future<void> sendCommand() async {
    if (!isValid) {
      return;
    }
    _handshake = null;
    models.sockets.baseStation.sendMessage(value);
    models.home.setMessage(
      severity: Severity.info,
      text: "Submitting antenna command...",
    );
    await Future<void>.delayed(const Duration(seconds: 1));
    if (_handshake != null) {
      models.home.setMessage(severity: Severity.info, text: "Command received");
    } else {
      models.home
          .setMessage(severity: Severity.error, text: "Command not received");
    }
    notifyListeners();
  }

  /// Sends a command to stop the antenna
  Future<void> stop() async {
    _handshake = null;
    models.home.setMessage(severity: Severity.info, text: "Stopping antenna");
    final command = BaseStationCommand(
      mode: AntennaControlMode.MANUAL_CONTROL,
      manualCommand: AntennaFirmwareCommand(stop: true),
    );
    for (var i = 0; i < 3; i++) {
      models.sockets.baseStation.sendMessage(command);
    }
    await Future<void>.delayed(const Duration(seconds: 1));
    if (_handshake != null) {
      models.home.setMessage(severity: Severity.info, text: "Antenna Stopped");
    } else {
      models.home.setMessage(severity: Severity.error, text: "Command not received");
    }
  }
}
