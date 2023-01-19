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

  /// The user's preferred layout for video feeds.
  /// 
  /// Each page has its own layout, and a layout is represented by a list of camera IDs.
  Map<OperatingMode, List<int>> feeds;

  /// The defualt constructor with default values.
  /// 
  /// Use this when the settings in the YAML file are invalid.
  Settings() : 
    connectionTimeout = 5,
    feeds = {      
      for (final mode in OperatingMode.values)
        mode: []
    };

  /// Initialize settings from YAML.
  Settings.fromYaml(Map yaml) : 
    feeds = {
      for (final mode in OperatingMode.values)
        mode: yaml.getFeeds(mode),
    },
    connectionTimeout = yaml["connectionTimeout"]!;

  /// Converts the data from the settings instance to YAML.
  Map toYaml() => { 
    "connectionTimeout": connectionTimeout,
  };
}
