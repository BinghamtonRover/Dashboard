/// Class to contain all the settings for the Mars Rover
class Settings {
  /// The IP the rover is being controlled on
  String roverIP = "127.0.0.1";

  /// The port data is being sent through
  int port = 22;

  /// Converts the data from the settings instance to yaml
  Map toYaml() => {
        "ip": roverIP,
        "port": port,
      };

  /// Update the settings from yaml
  void fromYaml(Map yaml) {
    roverIP = yaml["ip"];
    port = yaml["port"];
  }
}
