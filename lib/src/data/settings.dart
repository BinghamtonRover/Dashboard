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

/// Settings relating to video.
class VideoSettings {
  /// How many frames to render per second.
  /// 
  /// This does not affect how many frames are sent by the rover per second.
  final int fps;

  /// A const constructor.
  const VideoSettings({required this.fps});

  /// Parses a [VideoSettings] from JSON.
  VideoSettings.fromJson(Json? json) : 
    fps = (json?["fps"] ?? 60) as int;

  /// Serializes these settings in JSON format.
  Json toJson() => {
    "fps": fps,
  };
}

/// Settings relating to science.
class ScienceSettings {
  /// How many frames to render per second.
  /// 
  /// This does not affect how many frames are sent by the rover per second.
  final bool scrollableGraphs;

  /// The number of samples collected by the science subsystem.
  final int numSamples;

  /// A const constructor.
  const ScienceSettings({required this.scrollableGraphs, required this.numSamples});

  /// Parses a [ScienceSettings] from JSON.
  ScienceSettings.fromJson(Json? json) : 
    numSamples = json?["numSamples"] ?? 3,
    scrollableGraphs = json?["scrollableGraphs"] ?? false;

  /// Serializes these settings in JSON format.
  Json toJson() => {
    "scrollableGraphs": scrollableGraphs,
  };
}

/// Settings relating to the arm.
class ArmSettings {
  /// How many radians to move the shoulder joint each frame.
  final double shoulder;

  /// How many radians to move the elbow joint each frame.
  final double elbow;

  /// How many radians to move the swivel joint each frame.
  final double swivel;

  /// How many radians to pinch each frame.
  final double pinch;

  /// How many radians to lift the gripper each frame.
  final double lift;

  /// How many radians to rotate the gripper each frame.
  final double rotate;

  /// How many mm to move every 10 ms in IK mode.
  final double ikIncrement;

  /// Whether the arm is in manual or IK mode.
  final bool useIK;

  /// A const constructor.
  const ArmSettings({
    required this.shoulder,
    required this.elbow,
    required this.swivel,
    required this.pinch,
    required this.lift,
    required this.rotate,
    required this.ikIncrement,
    required this.useIK,
 });

  /// Parses arm settings from a JSON map.
  ArmSettings.fromJson(Json? json) : 
    shoulder = json?["shoulder"] ?? 0.005,
    elbow = json?["elbow"] ?? 0.005,
    swivel = json?["swivel"] ?? 0.2,
    pinch = json?["pinch"] ?? 0.002,
    lift = json?["lift"] ?? 0.01,
    rotate = json?["rotate"] ?? 0.01,
    useIK = json?["useIK"] ?? false,
    ikIncrement = json?["ikIncrement"] ?? 10;

  /// Serializes these settings to a JSON map.
  Json toJson() => {
    "shoulder": shoulder,
    "elbow": elbow,
    "swivel": swivel,
    "pinch": pinch,
    "lift": lift,
    "rotate": rotate,
    "useIK": useIK,
    "ikIncrement": ikIncrement,
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

  /// The address and port of the Rover's GPS
  final SocketConfig marsSocket;

  /// Creates a new network settings object.
  NetworkSettings({
    required this.subsystemsSocket,
    required this.videoSocket,
    required this.autonomySocket,
    required this.tankSocket,
    required this.marsSocket,
    required this.connectionTimeout,
  });

  /// Parses network settings from a JSON map.
  NetworkSettings.fromJson(Json? json) : 
    subsystemsSocket = json?.getSocket("subsystemsSocket") ?? SocketConfig.raw("192.168.1.20", 8001),
    videoSocket = json?.getSocket("videoSocket") ?? SocketConfig.raw("192.168.1.30", 8002),
    autonomySocket = json?.getSocket("autonomySocket") ?? SocketConfig.raw("192.168.1.30", 8003),
    tankSocket = json?.getSocket("tankSocket") ?? SocketConfig.raw("192.168.1.40", 8000),
    marsSocket = json?.getSocket("marsSocket") ?? SocketConfig.raw("192.168.1.50", 8006),
    connectionTimeout = json?["connectionTimeout"] ?? 5;

  /// Serializes these settings to JSON.
  Json toJson() => {
    "subsystemsSocket": subsystemsSocket.toJson(),
    "videoSocket": videoSocket.toJson(),
    "autonomySocket": autonomySocket.toJson(),
    "tankSocket": tankSocket.toJson(),
    "marsSocket": marsSocket.toJson(),
    "connectionTimeout": connectionTimeout,
  };
}

/// Settings relating to autonomy.
class AutonomySettings {
  /// The precision of the GPS grid.
  /// 
  /// Since GPS coordinates are decimal values, we divide by this value to get the index of the cell
  /// each coordinate belongs to. Smaller sizes means more blocks, but we should be careful that the
  /// blocks are big enough to the margin of error of our GPS. This value must be synced with the
  /// value in the autonomy program, or else the UI will not be accurate to the rover's logic.
  final double blockSize;

  /// A const constructor.
  const AutonomySettings({required this.blockSize});

  /// Parses autonomy settings from a JSON map.
  AutonomySettings.fromJson(Json? json) : 
    blockSize = json?["blockSize"] ?? 1.0;

  /// Serializes these settings to JSON.
  Json toJson() => {
    "blockSize": blockSize,
  };
}

/// Settings relating to easter eggs.
/// 
/// TODO: Implement these.
class EasterEggsSettings {
  /// A const constructor.
  const EasterEggsSettings();

  /// Parses easter eggs settings from JSON.
  EasterEggsSettings.fromJson(Json? json);  // ignore: avoid_unused_constructor_parameters

  /// Serializes these settings to JSON.
  Json toJson() => { };
}

/// Contains the settings for running the dashboard and the rover. 
class Settings {
  /// Settings for the network, like IP addresses and ports.
  final NetworkSettings network;

  /// Settings for video display.
  final VideoSettings video;

  /// Settings for easter eggs.
  /// 
  /// Please, please, please -- do not remove these (Levi Lesches, '25).
  final EasterEggsSettings easterEggs;

  /// Settings for the arm.
  final ArmSettings arm;

  /// Settings for the science analysis.
  final ScienceSettings science;

  /// Settings for the autonomy display.
  final AutonomySettings autonomy;

  /// A const constructor.
  const Settings({
    required this.network,
    required this.video,
    required this.easterEggs,
    required this.science,
    required this.arm,
    required this.autonomy,
  });

  /// Initialize settings from Json.
  Settings.fromJson(Json json) : 
    autonomy = AutonomySettings.fromJson(json["autonomy"]),
    network = NetworkSettings.fromJson(json["network"]),
    video = VideoSettings.fromJson(json["video"]),
    easterEggs = EasterEggsSettings.fromJson(json["easterEggs"]),
    science = ScienceSettings.fromJson(json["science"]),
    arm = ArmSettings.fromJson(json["arm"]);

  /// Converts the data from the settings instance to Json.
  Json toJson() => { 
    "autonomy": autonomy.toJson(),
    "network": network.toJson(),
    "video": video.toJson(),
    "easterEggs": easterEggs.toJson(),
    "science": science.toJson(),
    "arm": arm.toJson(),
  };
}
