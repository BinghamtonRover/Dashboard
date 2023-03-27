import "modes.dart";

/// YAML data stored as a Map.
typedef Yaml = Map;

/// A collection of functions for parsing [Settings]. 
extension SettingsParser on Yaml {
  /// Parses the list of camera IDs for a given operating mode.
  List<int> getFeeds(OperatingMode mode) => 
    List<int>.from(this["feeds"][mode.name]!);
}

/// Contains the settings for running the dashboard and the rover. 
class Settings {
  /// The amount of time, in seconds, the dashboard should wait before determining it's
  /// lost connection to the rover. For reference, the rover should be sending messages 
  /// at least once per second. 
  int connectionTimeout;

  /// The defualt constructor with default values.
  /// 
  /// Use this when the settings in the YAML file are invalid.
  Settings() : 
    connectionTimeout = 5;

  /// Initialize settings from YAML.
  Settings.fromYaml(Map yaml) : 
    connectionTimeout = yaml["connectionTimeout"]!;

  /// Converts the data from the settings instance to YAML.
  Map toYaml() => { 
    "connectionTimeout": connectionTimeout,
  };
}
