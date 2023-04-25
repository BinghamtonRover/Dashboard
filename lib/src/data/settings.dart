import "socket.dart";

/// A collection of functions for parsing [Settings]. 
extension SettingsParser on Json {
  /// Parses a [SocketConfig] that may not be present.
  SocketConfig? getSocket(String key) {
    final Json? socket = this[key];
    if (socket == null) return null;
    return SocketConfig.fromJson(socket);
  }
}

/// Settings relating to the arm.
class ArmSettings {
  /// How many radians to move every 10ms. 
  final double radianIncrement;

  /// How many steps to move every 10ms.
  final int stepIncrement;

  /// How many radians to move every 10ms in precision mode.
  final double preciseIncrement;

  /// How many mm to move every 10ms in IK mode.
  final double ikIncrement;

  /// How many mm to move every 10ms in precise IK mode.
  final double ikPreciseIncrement;

  /// Whether the arm is in manual or IK mode.
  final bool useIK;

  /// Whether to use steps or radians.
  final bool useSteps;

  /// A const constructor.
  const ArmSettings({
    required this.radianIncrement,
    required this.stepIncrement,
    required this.preciseIncrement,
    required this.ikIncrement,
    required this.ikPreciseIncrement,
    required this.useIK,
    required this.useSteps,
 });

  /// Parses arm settings from a JSON map.
  ArmSettings.fromJson(Json? json) : 
    radianIncrement = json?["radianIncrement"] ?? 0.2,
    stepIncrement = json?["stepIncrement"] ?? 10000,
    preciseIncrement = json?["preciseIncrement"] ?? 0.1,
    ikIncrement = json?["ikIncrement"] ?? 100,
    ikPreciseIncrement = json?["ikPreciseIncrement"] ?? 10,
    useIK = json?["useIK"] ?? false,
    useSteps = json?["useSteps"] ?? false;

  /// Serializes these settings to a JSON map.
  Json toJson() => {
    "radianIncrement": radianIncrement,
    "stepIncrement": stepIncrement,
    "preciseIncrement": preciseIncrement,
    "ikIncrement": ikIncrement,
    "ikPreciseIncrement": ikPreciseIncrement,
    "useIK": useIK,
    "useSteps": useSteps,
  };
}

/// Settings related to network configuration.
class NetworkSettings {
  /// The amount of time, in seconds, the dashboard should wait before determining it's
  /// lost connection to the rover. For reference, the rover should be sending messages 
  /// at least once per second. 
  final int connectionTimeout;

  /// The address and port of the subsystems program.
  final SocketConfig subsystemsSocket;

  /// The address and port of the video program.
  final SocketConfig videoSocket;

  /// The address and port of the autonomy program.
  final SocketConfig autonomySocket;

  /// The address of the tank. The port is ignored.
  /// 
  /// The Tank is a model rover that has all the same programs as the rover. This field does not
  /// include port numbers because ports are specific to the program, and the tank will have many
  /// programs running. Instead, the IP address of all the other programs should be swapped with
  /// the tank when it's being used.
  final SocketConfig tankSocket;

  /// Creates a new network settings object.
  NetworkSettings({
    required this.subsystemsSocket,
    required this.videoSocket,
    required this.autonomySocket,
    required this.tankSocket,
    required this.connectionTimeout,
  });

  /// Parses network settings from a JSON map.
  NetworkSettings.fromJson(Json? json) : 
    subsystemsSocket = json?.getSocket("subsystemsSocket") ?? SocketConfig.raw("192.168.1.20", 8001),
    videoSocket = json?.getSocket("videoSocket") ?? SocketConfig.raw("192.168.1.30", 8002),
    autonomySocket = json?.getSocket("autonomySocket") ?? SocketConfig.raw("192.168.1.30", 8003),
    tankSocket = json?.getSocket("tankSocket") ?? SocketConfig.raw("192.168.1.40", 8000),
    connectionTimeout = json?["connectionTimeout"] ?? 5;

  /// Serializes these settings to JSON.
  Json toJson() => {
    "subsystemsSocket": subsystemsSocket.toJson(),
    "videoSocket": videoSocket.toJson(),
    "autonomySocket": autonomySocket.toJson(),
    "tankSocket": tankSocket.toJson(),
    "connectionTimeout": connectionTimeout,
  };
}

/// Contains the settings for running the dashboard and the rover. 
class Settings {
  /// Settings for the network, like IP addresses and ports.
  final NetworkSettings network;

  /// Settings for the arm.
  final ArmSettings arm;

  /// A const constructor.
  const Settings({
    required this.network,
    required this.arm,
  });

  /// Initialize settings from Json.
  Settings.fromJson(Json json) : 
    network = NetworkSettings.fromJson(json["network"]),
    arm = ArmSettings.fromJson(json["arm"]);

  /// Converts the data from the settings instance to Json.
  Map toJson() => { 
    "network": network.toJson(),
    "arm": arm.toJson(),
  };
}
