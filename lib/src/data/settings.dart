import "package:flutter/material.dart";
import "package:rover_dashboard/data.dart";

/// A collection of functions for parsing [Settings].
extension SettingsParser on Json {
  /// Parses a [SocketInfo] that may not be present.
  SocketInfo? getSocket(String key) {
    final Json? socket = this[key];
    if (socket == null) return null;
    return SocketInfo.fromJson(socket);
  }
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
    "numSamples": numSamples,
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
    shoulder = json?["shoulder"] ?? 0.008,
    elbow = json?["elbow"] ?? 0.008,
    swivel = json?["swivel"] ?? 0.02,
    pinch = json?["pinch"] ?? 0.006,
    lift = json?["lift"] ?? 0.02,
    rotate = json?["rotate"] ?? 0.1,
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

/// Settings related to the base station
class BaseStationSettings {
  /// The latitude of the base station
  final double latitude;

  /// The longitude of the base station
  final double longitude;

  /// The altitude of the base station in meters
  final double altitude;

  /// The angle tolerance in degrees
  final double angleTolerance;

  /// Const constructor for base station settings
  const BaseStationSettings({
    required this.latitude,
    required this.longitude,
    required this.altitude,
    required this.angleTolerance,
  });

  /// Parses base station settings from json
  BaseStationSettings.fromJson(Json? json) :
    latitude = json?["latitude"] ?? 0,
    longitude = json?["longitude"] ?? 0,
    altitude = json?["altitude"] ?? 0,
    angleTolerance = json?["angleTolerance"] ?? 5;

  /// Serializes the base station settings to a json map
  Json toJson() => {
    "latitude": latitude,
    "longitude": longitude,
    "altitude": altitude,
    "angleTolerance": angleTolerance,
  };

  /// The GPS coordinates of the base station
  GpsCoordinates get gpsCoordinates => GpsCoordinates(
    latitude: latitude,
    longitude: longitude,
    altitude: altitude,
  );
}

/// Settings related to network configuration.
class NetworkSettings {
  /// The amount of time, in seconds, the dashboard should wait before determining it's
  /// lost connection to the rover. For reference, the rover should be sending messages
  /// at least once per second.
  final double connectionTimeout;

  /// The address and port of the subsystems program.
  final SocketInfo subsystemsSocket;

  /// The address and port of the video program.
  final SocketInfo videoSocket;

  /// The address and port of the autonomy program.
  final SocketInfo autonomySocket;

  /// The address of the tank. The port is ignored.
  ///
  /// The Tank is a model rover that has all the same programs as the rover. This field does not
  /// include port numbers because ports are specific to the program, and the tank will have many
  /// programs running. Instead, the IP address of all the other programs should be swapped with
  /// the tank when it's being used.
  final SocketInfo tankSocket;

  /// The address and port of the base station program.
  final SocketInfo baseSocket;

  /// Creates a new network settings object.
  NetworkSettings({
    required this.subsystemsSocket,
    required this.videoSocket,
    required this.autonomySocket,
    required this.tankSocket,
    required this.baseSocket,
    required this.connectionTimeout,
  });

  /// Parses network settings from a JSON map.
  NetworkSettings.fromJson(Json? json) :
    subsystemsSocket = json?.getSocket("subsystemsSocket") ?? SocketInfo.raw("192.168.1.20", 8001),
    videoSocket = json?.getSocket("videoSocket") ?? SocketInfo.raw("192.168.1.30", 8002),
    autonomySocket = json?.getSocket("autonomySocket") ?? SocketInfo.raw("192.168.1.30", 8003),
    tankSocket = json?.getSocket("tankSocket") ?? SocketInfo.raw("192.168.1.40", 8000),
    baseSocket = json?.getSocket("baseSocket") ?? SocketInfo.raw("192.168.1.50", 8005),
    connectionTimeout = json?["connectionTimeout"] ?? 5;

  /// Serializes these settings to JSON.
  Json toJson() => {
    "subsystemsSocket": subsystemsSocket.toJson(),
    "videoSocket": videoSocket.toJson(),
    "autonomySocket": autonomySocket.toJson(),
    "tankSocket": tankSocket.toJson(),
    "baseSocket": baseSocket.toJson(),
    "connectionTimeout": connectionTimeout,
  };
}

/// Settings relating to easter eggs.
///
/// Implement these! Ask Levi for details.
class EasterEggsSettings {
  /// Whether to do a SEGA-like intro during boot.
  final bool segaIntro;

  /// Whether to say "Binghamton" in the SEGA style.
  final bool segaSound;

  /// Whether clippy should appear by log messages.
  final bool enableClippy;

  /// Whether to render Bad Apple in the Map page.
  final bool badApple;

  /// Whether to display the bouncing DVD logo animation in the mini-dashboard screensaver
  final bool dvdLogoAnimation;

  /// A const constructor.
  const EasterEggsSettings({
    required this.segaIntro,
    required this.segaSound,
    required this.enableClippy,
    required this.badApple,
    required this.dvdLogoAnimation,
  });

  /// Parses easter eggs settings from JSON.
  EasterEggsSettings.fromJson(Json? json) :
    segaIntro = json?["segaIntro"] ?? true,
    segaSound = json?["segaSound"] ?? true,
    enableClippy = json?["enableClippy"] ?? true,
    badApple = json?["badApple"] ?? true,
    dvdLogoAnimation = json?["dvdLogoAnimation"] ?? true;

  /// Serializes these settings to JSON.
  Json toJson() => {
    "segaIntro": segaIntro,
    "segaSound": segaSound,
    "enableClippy": enableClippy,
    "badApple": badApple,
    "dvdLogoAnimation": dvdLogoAnimation,
  };
}

/// Controls the way the Dashboard views split.
enum SplitMode {
  /// Two views are split horizontally, one atop the other.
  horizontal("Top and bottom"),
  /// Two views are split vertically, side-by-side.
  vertical("Side by side");

  /// The name to show in the UI.
  final String humanName;
  /// A const constructor.
  const SplitMode(this.humanName);
}

/// Helpful methods on [ThemeMode]s.
extension ThemeModeUtils on ThemeMode {
  /// A human-friendly name for this mode.
  String get humanName => switch (this) {
    ThemeMode.system => "Match system",
    ThemeMode.light => "Light theme",
    ThemeMode.dark => "Dark theme",
  };
}

/// Settings related to the dashboard itself, not the rover.
class DashboardSettings {
  /// How the Dashboard should split when only two views are present.
  SplitMode splitMode;

  /// The precision of the GPS grid.
  ///
  /// Since GPS coordinates are decimal values, we divide by this value to get the index of the cell
  /// each coordinate belongs to. Smaller sizes means more blocks, but we should be careful that the
  /// blocks are big enough to the margin of error of our GPS. This value must be synced with the
  /// value in the autonomy program, or else the UI will not be accurate to the rover's logic.
  final double mapBlockSize;

  /// How many frames to render per second.
  ///
  /// This does not affect how many frames are sent by the rover per second.
  final int maxFps;

  /// The theme of the Dashboard.
  final ThemeMode themeMode;

  /// Whether to split cameras into their own controls.
  ///
  /// When this is disabled, some other modes, like arm or drive, may move the cameras.
  /// When this is enabled, only the dedicated camera control mode can move the cameras.
  final bool splitCameras;

  /// Whether to default to tank drive controls.
  ///
  /// Tank controls offer more custom control, but modern drive controls are more intuitive.
  final bool preferTankControls;

  /// The maximum rate of change to apply to the drive joystick inputs
  final double driveRateLimit;

  /// The maximum rate of change to apply to the drive throttle
  final double throttleRateLimit;

  /// Whether to have version checking on protobuf messages.
  final bool versionChecking;

  /// A list of ViewPresets
  final List<ViewPreset> presets;

  /// The default preset to load on startup
  String? defaultPreset;

  /// A const constructor.
  DashboardSettings({
    required this.splitMode,
    required this.mapBlockSize,
    required this.maxFps,
    required this.themeMode,
    required this.splitCameras,
    required this.preferTankControls,
    required this.driveRateLimit,
    required this.throttleRateLimit,
    required this.versionChecking,
    required this.presets,
    required this.defaultPreset,
  });

  /// Parses settings from JSON.
  DashboardSettings.fromJson(Json? json) :
    presets = [
      for (final presetJson in json?["presets"] ?? [])
        ViewPreset.fromJson(presetJson),
    ],
    defaultPreset = json?["defaultPreset"],
    splitMode = SplitMode.values[json?["splitMode"] ?? SplitMode.horizontal.index],
    mapBlockSize = json?["mapBlockSize"] ?? 1.0,
    maxFps = (json?["maxFps"] ?? 60) as int,
    splitCameras = json?["splitCameras"] ?? false,
    preferTankControls = json?["preferTankControls"] ?? false,
    driveRateLimit = json?["driveRateLimit"] ?? 1.50,
    throttleRateLimit = json?["throttleRateLimit"] ?? 0.50,
    versionChecking = json?["versionChecking"] ?? true,
    themeMode = ThemeMode.values.byName(json?["theme"] ?? ThemeMode.system.name);

  /// Serializes these settings to JSON.
  Json toJson() => {
    "splitMode": splitMode.index,
    "mapBlockSize": mapBlockSize,
    "maxFps": maxFps,
    "theme": themeMode.name,
    "splitCameras": splitCameras,
    "preferTankControls": preferTankControls,
    "driveRateLimit": driveRateLimit,
    "throttleRateLimit": throttleRateLimit,
    "versionChecking": versionChecking,
    "presets": presets,
    "defaultPreset": defaultPreset,
  };
}

/// Contains the settings for running the dashboard and the rover.
class Settings {
  /// Settings for the network, like IP addresses and ports.
  final NetworkSettings network;

  /// Settings for easter eggs.
  ///
  /// Please, please, please -- do not remove these (Levi Lesches, '25).
  final EasterEggsSettings easterEggs;

  /// Settings for the arm.
  final ArmSettings arm;

  /// Settings for the science analysis.
  final ScienceSettings science;

  /// Settings for the base station
  final BaseStationSettings baseStation;

  /// Settings related to the dashboard itself.
  final DashboardSettings dashboard;

  /// A const constructor.
  const Settings({
    required this.network,
    required this.baseStation,
    required this.easterEggs,
    required this.science,
    required this.arm,
    required this.dashboard,
  });

  /// Initialize settings from Json.
  Settings.fromJson(Json json) :
    network = NetworkSettings.fromJson(json["network"]),
    baseStation = BaseStationSettings.fromJson(json["baseStation"]),
    easterEggs = EasterEggsSettings.fromJson(json["easterEggs"]),
    science = ScienceSettings.fromJson(json["science"]),
    arm = ArmSettings.fromJson(json["arm"]),
    dashboard = DashboardSettings.fromJson(json["dashboard"]);

  /// Converts the data from the settings instance to Json.
  Json toJson() => {
    "network": network.toJson(),
    "baseStation": baseStation.toJson(),
    "easterEggs": easterEggs.toJson(),
    "science": science.toJson(),
    "arm": arm.toJson(),
    "dashboard": dashboard.toJson(),
  };
}
