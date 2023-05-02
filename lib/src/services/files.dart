// ignore_for_file: directives_ordering
import "dart:convert";
import "dart:io";

import "package:path_provider/path_provider.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/services.dart";

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

  /// The directory where screenshots are stored.
  /// 
  /// These are only screenshots of video feeds, not of the dashboard itself.
  Directory get screenshotsDir => Directory("${outputDir.path}/screenshots");
  
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
    loggingDir = await Directory("${outputDir.path}/logs/${DateTime.now().timeStamp}").create(recursive: true);
    if (!settingsFile.existsSync()) await writeSettings(null);
  }

  @override
  Future<void> dispose() async { }

  /// Saves the [Settings] object to the [settingsFile], as JSON.
  Future<void> writeSettings(Settings? value) async {
    final json = jsonEncode(value?.toJson() ?? {});
    await settingsFile.writeAsString(json);
  }

  /// Reads the user's settings from the [settingsFile].
  Future<Settings> readSettings({bool retry = true}) async {
    final json = jsonDecode(await settingsFile.readAsString());
    try {
      final settings = Settings.fromJson(json);
      await writeSettings(settings);  // re-save any default values
      return settings;
    } catch (error) {
      services.error = "Settings were corrupted and reset back to defaults";
      await writeSettings(Settings.fromJson({}));  // delete corrupt settings
      if (retry) {
        return readSettings(retry: false);
      } else {
        rethrow;
      }
    }
  }

  /// Saves the current frame in the feed to the camera's output directory.
  Future<void> writeImage(List<int> image, String cameraName) async {
    final dir = await Directory("${screenshotsDir.path}/$cameraName").create(recursive: true); 
    final files = dir.listSync();
    final number = files.isEmpty ? 1 : (int.parse(files.last.filename) + 1);
    await File("${dir.path}/$number.jpg").writeAsBytes(image); 
  }

  /// Outputs log data to the correct file based on message
  Future<void> logData(Message message) async{
    final List<int> bytes = message.wrapped.writeToBuffer();
    final line = bytes.join(", ");
    final file = File("${loggingDir.path}/${message.messageName}.log");
    await file.writeAsString("$line\n", mode: FileMode.writeOnlyAppend, flush: true);
  }

  /// Reads logs from the given file.
  Future<List<WrappedMessage>> readLogs(File file) async => [
    for (final line in (await file.readAsString()).trim().split("\n"))
      WrappedMessage.fromBuffer([
        for (final byte in line.split(", ")) int.parse(byte)
      ])
  ];
}

extension on FileSystemEntity {
  String get filename => uri.pathSegments.last.split(".")[0];
}
