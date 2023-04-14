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

  /// The IP address of the tank.
  /// 
  /// The Tank is a model rover that has all the same programs as the rover. This field does not
  /// include port numbers because ports are specific to the program, and the tank will have many
  /// programs running. Instead, the IP address of all the other programs should be swapped with
  /// the tank when it's being used.
  String tankAddress;

  /// A constructor for this class.
  Settings({
    required this.subsystemsSocket,
    required this.videoSocket,    
    required this.autonomySocket,    
    required this.tankAddress,
    required this.connectionTimeout,
  });

  /// Initialize settings from Json.
  Settings.fromJson(Json json) : 
    subsystemsSocket = json.getSocket("subsystemsSocket") ?? defaultSettings.subsystemsSocket,
    videoSocket = json.getSocket("videoSocket") ?? defaultSettings.videoSocket,
    autonomySocket = json.getSocket("autonomySocket") ?? defaultSettings.autonomySocket,
    tankAddress = json["tankAddress"] ?? defaultSettings.tankAddress,
    connectionTimeout = json["connectionTimeout"] ?? defaultSettings.connectionTimeout;

  /// Converts the data from the settings instance to Json.
  Map toJson() => { 
    "subsystemsSocket": subsystemsSocket.toJson(),
    "videoSocket": videoSocket.toJson(),
    "autonomySocket": autonomySocket.toJson(),
    "tankAddress": tankAddress,
    "connectionTimeout": connectionTimeout,
  };
}

/// The defualt settings with default values.
/// 
/// Use this when the settings in the Json file are invalid.
final defaultSettings = Settings(
  subsystemsSocket: SocketConfig.raw("192.168.1.20", 8001),
  videoSocket: SocketConfig.raw("192.168.1.30", 8002),
  autonomySocket: SocketConfig.raw("192.168.1.30", 8003),
  tankAddress: "192.168.1.40",
  connectionTimeout: 5,
);
