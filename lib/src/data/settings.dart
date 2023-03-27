import "dart:io";

/// YAML data stored as a Map.
typedef Yaml = Map;

/// A collection of functions for parsing [Settings]. 
extension SettingsParser on Yaml {
  /// Parses a [SocketConfig] that may not be present.
  SocketConfig? getSocket(String key) {
    final Yaml? socket = this[key];
    if (socket == null) return null;
    return SocketConfig.fromYaml(socket);
  }
}

/// Describes a UDP socket comprised of an IP address and a port.
class SocketConfig {
  /// The IP address of the socket.
  String host;

  /// The port of the socket.
  int port;

  /// A const constructor.
  SocketConfig(this.host, this.port);

  /// Parses the socket data from a YAML map.
  SocketConfig.fromYaml(Yaml yaml) : 
    host = yaml["host"],
    port = yaml["port"];

  /// The address of the host.
  InternetAddress get address => InternetAddress(host);
}

/// Contains the settings for running the dashboard and the rover. 
class Settings {
  /// The amount of time, in seconds, the dashboard should wait before determining it's
  /// lost connection to the rover. For reference, the rover should be sending messages 
  /// at least once per second. 
  int connectionTimeout;

  /// The address and port of the subsystems program.
  SocketConfig subsystemsSocket;

  /// The address and port of the video program.
  SocketConfig videoSocket;

  /// The address and port of the autonomy program.
  SocketConfig autonomySocket;

  /// The address and port of the tank program.
  SocketConfig tankSocket;

  /// A constructor for this class.
  Settings({
    required this.subsystemsSocket,
    required this.videoSocket,    
    required this.autonomySocket,    
    required this.tankSocket,
    required this.connectionTimeout,
  });

  /// Initialize settings from YAML.
  Settings.fromYaml(Map yaml) : 
    subsystemsSocket = yaml.getSocket("subsystemsSocket") ?? defaultSettings.subsystemsSocket,
    videoSocket = yaml.getSocket("videoSocket") ?? defaultSettings.videoSocket,
    autonomySocket = yaml.getSocket("autonomySocket") ?? defaultSettings.autonomySocket,
    tankSocket = yaml.getSocket("tankSocket") ?? defaultSettings.tankSocket,
    connectionTimeout = yaml["connectionTimeout"] ?? defaultSettings.connectionTimeout;

  /// Converts the data from the settings instance to YAML.
  Map toYaml() => { 
    "connectionTimeout": connectionTimeout,
  };
}

/// The defualt settings with default values.
/// 
/// Use this when the settings in the YAML file are invalid.
final defaultSettings = Settings(
  subsystemsSocket: SocketConfig("192.168.1.20", 8000),
  videoSocket: SocketConfig("192.168.1.30", 8000),
  autonomySocket: SocketConfig("192.168.1.30", 8000),
  tankSocket: SocketConfig("192.168.1.40", 8000),
  connectionTimeout: 5,
);
