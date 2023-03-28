import "socket.dart";

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

  /// A constructor for this class.
  Settings({
    required this.subsystemsSocket,
    required this.videoSocket,    
    required this.autonomySocket,    
    required this.connectionTimeout,
  });

  /// Initialize settings from YAML.
  Settings.fromYaml(Map yaml) : 
    subsystemsSocket = yaml.getSocket("subsystemsSocket") ?? defaultSettings.subsystemsSocket,
    videoSocket = yaml.getSocket("videoSocket") ?? defaultSettings.videoSocket,
    autonomySocket = yaml.getSocket("autonomySocket") ?? defaultSettings.autonomySocket,
    connectionTimeout = yaml["connectionTimeout"] ?? defaultSettings.connectionTimeout;

  /// Converts the data from the settings instance to YAML.
  Map toYaml() => { 
    "subsystemsSocket": subsystemsSocket,
    "videoSocket": videoSocket,
    "autonomySocket": autonomySocket,
    "connectionTimeout": connectionTimeout,
  };
}

/// The defualt settings with default values.
/// 
/// Use this when the settings in the YAML file are invalid.
final defaultSettings = Settings(
  subsystemsSocket: SocketConfig.raw("192.168.1.20", 8000),
  videoSocket: SocketConfig.raw("192.168.1.30", 8000),
  autonomySocket: SocketConfig.raw("192.168.1.30", 8000),
  connectionTimeout: 5,
);
