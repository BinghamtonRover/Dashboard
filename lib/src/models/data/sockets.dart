import "dart:io";

import "package:burt_network/logging.dart";
import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";

/// Coordinates all the sockets to point to the right [RoverType].
class Sockets extends Model {
  /// A UDP socket for sending and receiving Protobuf data.
  late final data = DashboardSocket(device: Device.SUBSYSTEMS);

  /// A UDP socket for receiving video.
  late final video = DashboardSocket(device: Device.VIDEO);

  /// A UDP socket for controlling autonomy.
  late final autonomy = DashboardSocket(device: Device.AUTONOMY);

  /// A UDP socket for controlling the base station
  late final baseStation = DashboardSocket(device: Device.BASE_STATION);

  /// A list of all the sockets this model manages.
  List<DashboardSocket> get sockets => [data, video, autonomy, baseStation];

  /// The rover-like system currently in use.
  RoverType rover = RoverType.rover;

  /// The [InternetAddress] to use instead of the address on the rover.
  InternetAddress? get addressOverride => switch (rover) {
    RoverType.rover => null,
    RoverType.tank => models.settings.network.tankSocket.address,
    RoverType.localhost => InternetAddress.loopbackIPv4,
  };

  /// A rundown of the connection strength of each device.
  String get connectionSummary {
    final result = StringBuffer();
    for (final socket in sockets) {
      result.write("${socket.device.humanName}: ${(socket.connectionStrength.value * 100).toStringAsFixed(0)}%\n");
    }
    return result.toString().trim();
  }

  /// Whether any socket in [sockets] is enabled
  bool get isEnabled => sockets.any((socket) => socket.isEnabled);

  /// Returns the corresponding [DashboardSocket] for the [device]
  ///
  /// Returns null if no device is passed or there is no corresponding socket
  DashboardSocket? socketForDevice(Device device) => switch (device) {
    Device.SUBSYSTEMS => data,
    Device.VIDEO => video,
    Device.AUTONOMY => autonomy,
    Device.BASE_STATION => baseStation,
    _ => null,
  };

	@override
	Future<void> init() async {
		for (final socket in sockets) {
			socket.connectionStatus.addListener(() {
        if (socket.connectionStatus.value) {
          socket.sendMessage(models.rover.settings.settings);
          onConnect(socket.device);
        } else {
          onDisconnect(socket.device);
        }
      });
      socket.messages.listen((message) {
        if (!socket.isEnabled) return;
        models.messages.addMessage(message);
      });
      await socket.init();
		}
    data.messages.onMessage(
      name: UpdateSetting().messageName,
      constructor: UpdateSetting.fromBuffer,
      callback: (setting) {
        if (!setting.hasStatus()) return;

        final status = setting.status;
        if (status == RoverStatus.RESTART || status == RoverStatus.POWER_OFF) {
          return;
        }

        models.rover.settings.settings.status = status;
        models.rover.status.value = status;
      },
    );
		final level = Logger.level;
		Logger.level = LogLevel.warning;
		await updateSockets();
		Logger.level = level;
    notifyListeners();
	}

  /// Enables all sockets without restarting them
  void enable() {
    for (final socket in sockets) {
      socket.enable();
    }
    notifyListeners();
  }

  /// Disconnects from all sockets without restarting them
  void disable() {
		for (final socket in sockets) {
			socket.disable();
		}
    notifyListeners();
  }

  @override
  Future<void> dispose() async {
    for (final socket in sockets) {
      await socket.dispose();
    }
    super.dispose();
  }

  /// Notifies the user when a new device has connected.
  void onConnect(Device device) {
    models.home.setMessage(severity: Severity.info, text: "The ${device.humanName} has connected");
    if (device == Device.SUBSYSTEMS) {
      models.rover.status.value = models.rover.settings.status;
      models.rover.controller1.gamepad.pulse();
      models.rover.controller2.gamepad.pulse();
      models.rover.controller3.gamepad.pulse();
    }
    notifyListeners();
  }

  /// Notifies the user when a device has disconnected.
  void onDisconnect(Device device) {
    models.home.setMessage(severity: Severity.critical, text: "The ${device.humanName} has disconnected");
    if (device == Device.SUBSYSTEMS) models.rover.status.value = RoverStatus.DISCONNECTED;
    if (device == Device.VIDEO) models.video.reset();
    notifyListeners();
  }

  /// Set the right IP addresses for the rover or tank.
  Future<void> updateSockets() async {
    final settings = models.settings.network;
    data.destination = settings.subsystemsSocket.copyWith(address: addressOverride);
    video.destination = settings.videoSocket.copyWith(address: addressOverride);
    autonomy.destination = settings.autonomySocket.copyWith(address: addressOverride);
    baseStation.destination = settings.baseSocket.copyWith(address: addressOverride);
  }

  /// Resets all the sockets.
  ///
  /// When working with localhost, even UDP sockets can throw errors when the remote is unreachable.
  /// Resetting the sockets will bypass these errors.
  Future<void> reset() async {
    for (final socket in sockets) {
      await socket.dispose();
      await socket.init();
    }
    // Sockets lose their destination when disposed, so we restore it.
    await updateSockets();
  }

  /// Change which rover is being used.
  Future<void> setRover(RoverType? value) async {
    if (value == null) return;
    rover = value;
    models.home.setMessage(severity: Severity.info, text: "Using: ${rover.name}");
    await reset();
    notifyListeners();
  }
}
