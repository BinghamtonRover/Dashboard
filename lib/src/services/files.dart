import "dart:io";

import "package:rover_dashboard/data.dart";

import "package:yaml/yaml.dart";
import "package:yaml_writer/yaml_writer.dart";

import "service.dart";

/// A service to read and write to the file system. 
/// 
/// The dashboard reads and writes to files in [outputDir].
class FilesService extends Service {
  /// The directory where the dashboard keeps its files. 
  /// 
  /// This includes settings, data, images, and anything else the user or dashboard
  /// may want to keep between sessions. Categories of output, like screenshots, 
  /// should get their own subdirectory.
  static final outputDir = Directory("${Directory.current.path}/output");

  /// The file containing the user's [Settings], in YAML form.
  /// 
  /// This file should contain the result of [Settings.toYaml], and loading settings
  /// from the file should be done with [Settings.fromYaml].
  static File get settingsFile => File("${outputDir.path}/settings.yaml");

  /// Ensure that files and directories that are expected to be present actually
  /// exist on the system. If not, create them. 
  @override
  Future<void> init() async {
    await outputDir.create();
    if (!settingsFile.existsSync()) await settingsFile.create();
  }

  @override
  Future<void> dispose() async { }

  /// Saves the [settings] object to the [settingsFile], as YAML.
  Future<void> writeSettings(Settings settings) async {
    final yamlString = YAMLWriter().write(settings.toYaml());
    await settingsFile.writeAsString(yamlString);
  }

  /// Reads the user's settings from the [settingsFile].
  Future<Settings> readSettings() async {
    final String yamlString = await settingsFile.readAsString();
    // An empty file means [loadYaml] returns null
    final Map yaml = loadYaml(yamlString) ?? {};
    try { return Settings.fromYaml(yaml); }
    catch (error) {
      print("Error while parsing settings: $error");  // ignore: avoid_print
      final settings = Settings();
      await writeSettings(settings);  // for next time
      return settings;
    }
  }

  /// Saves the current frame in the feed to the camera's output directory.
  Future<void> writeImage(List<int> image, String cameraName) async {
    final dir = Directory("${outputDir.path}/$cameraName");
    if (!(await dir.exists())) await dir.create();    
    final timestamp = DateTime.now().toString();
    await File("${dir.path}/$timestamp.jpg").writeAsBytes(image); 
  }
}
