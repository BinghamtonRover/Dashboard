// ignore_for_file: directives_ordering
import "dart:convert";
import "dart:io";

import "package:path_provider/path_provider.dart";

import "package:rover_dashboard/data.dart";

import "service.dart";

extension on DateTime{
  String get timeStamp => "$year-$month-$day-$hour-$minute"; 
}

/// A service to read and write to the file system. 
/// 
/// The dashboard reads and writes to files in [outputDir].
class FilesService extends Service {
  /// The directory where the dashboard keeps its files. 
  /// 
  /// This includes settings, data, images, and anything else the user or dashboard
  /// may want to keep between sessions. Categories of output, like screenshots, 
  /// should get their own subdirectory.
  late final Directory outputDir;

  /// The directory where all logging data is outputted
  /// 
  /// This includes all the different operating modes with specified folders inside
  late final Directory loggingDir;

  /// The file containing the user's [Settings], in JSON form.
  /// 
  /// This file should contain the result of [Settings.toJson], and loading settings
  /// from the file should be done with [Settings.fromJson].
  File get settingsFile => File("${outputDir.path}/settings.json");

  /// Ensure that files and directories that are expected to be present actually
  /// exist on the system. If not, create them. 
  @override
  Future<void> init() async {
    final appDir = await getApplicationDocumentsDirectory();
    outputDir = await Directory("${appDir.path}/Dashboard").create();
    if (!settingsFile.existsSync()) await settingsFile.writeAsString(jsonEncode({}));
    loggingDir = await Directory("${outputDir.path}/logs/${DateTime.now().timeStamp}").create(recursive: true);
  }

  @override
  Future<void> dispose() async { }

  /// Saves the [settings] object to the [settingsFile], as YAML.
  Future<void> writeSettings(Settings settings) async {
    final json = jsonEncode(settings.toJson());
    await settingsFile.writeAsString(json);
  }

  /// Reads the user's settings from the [settingsFile].
  Future<Settings> readSettings() async {
    final json = jsonDecode(await settingsFile.readAsString());
    final settings = Settings.fromJson(json);
    await writeSettings(settings);  // re-save any default values
    return settings;
  }

  /// Saves the current frame in the feed to the camera's output directory.
  Future<void> writeImage(List<int> image, String cameraName) async {
    final dir = Directory("${outputDir.path}/$cameraName");
    if (!(await dir.exists())) await dir.create();    
    final files = dir.listSync();
    final number = files.isEmpty ? 1 : (int.parse(files.last.filename) + 1);
    await File("${dir.path}/$number.jpg").writeAsBytes(image); 
  }

  /// Outputs log data to the correct file based on message
  Future<void> logData(Message message) async{
    final List<int> bytes = message.wrapped.writeToBuffer();
    final String line = bytes.join(", ");
    final file = File("${loggingDir.path}/${message.messageName}.log");
    await file.writeAsString("$line\n", mode: FileMode.writeOnlyAppend, flush: true);
  }

  /// Reads log file based on a messageName string
  Future<List<Message>> readData(String messageName) async{
    final List<Message> messages = [];
    final file = File("${loggingDir.path}/$messageName.log");
    final String fileContent =  await file.readAsString();
    final List<String> rows = fileContent.split("\n"); 
    for(final String row in rows){
      final List<int> bytes = row.split(",").map(int.parse).toList();
      final Message newMessage = WrappedMessage.fromBuffer(bytes);
      messages.add(newMessage);
    }
    return messages;
  }

}


extension on FileSystemEntity {
  String get filename => uri.pathSegments.last.split(".")[0];
}
