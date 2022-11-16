import "dart:io";
import "package:rover_dashboard/data.dart";
import "package:yaml/yaml.dart";
import "package:yaml_writer/yaml_writer.dart";
import "service.dart";

///Service to read File Contents
class FileReader extends Service {
  /// Initializes the service.
  @override
  Future<void> init() async {}

  /// Cleans up any resources used by the service.
  @override
  Future<void> dispose() async {}

  /// Creates settings.yaml which is stored in the outputs folder
  /// Contains all relevant settings of the robot
  Future<String> saveSettings(Settings settings) async {
    final Directory output = Directory("${Directory.current.path}/output");

    await output.create();
    final yamlWriter = YAMLWriter();
    final yamlString = yamlWriter.write(settings.toYaml());
    await File("${output.path}/settings.yaml").writeAsString(yamlString);
    return "${output.path}/settings.yaml";
  }

  /// Read in a settings file and returns a new Settings object
  Future<Settings> importSettings(String filepath) async {
    final Settings settings = Settings();
    final String yamlString = await File(filepath).readAsString();
    final Map yaml = loadYaml(yamlString);
    settings.fromYaml(yaml);
    return settings;
  }
}
