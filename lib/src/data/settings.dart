/// Contains the settings for running the dashboard and the rover. 
class Settings {
  /// The amount of time, in seconds, the dashboard should wait before determining it's
  /// lost connection to the rover. For reference, the rover should be sending messages 
  /// at least once per second. 
  int connectionTimeout;

  /// Initialize settings from YAML.
  Settings.fromYaml(Map yaml) : 
    connectionTimeout = yaml["connectionTimeout"] ?? 5;

  /// Converts the data from the settings instance to YAML.
  Map toYaml() => { 
    "connectionTimeout": connectionTimeout,
  };
}
