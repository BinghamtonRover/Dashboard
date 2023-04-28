// ignore_for_file: directives_ordering
import "dart:convert";
import 'dart:ffi';
import "dart:io";

import "package:csv/csv.dart";

import "package:path_provider/path_provider.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/src/data/generated/autonomy.pb.dart";
import 'package:rover_dashboard/src/widgets/navigation/footer.dart';

import "service.dart";

extension on DateTime{
  String timeStamp() => "$year-$month-$day-$hour-$minute"; 
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

  /// Object to convert list to Csv formatted strings 
  final converter = const ListToCsvConverter();

  /// The file containing the user's [Settings], in JSON form.
  /// 
  /// This file should contain the result of [Settings.toJson], and loading settings
  /// from the file should be done with [Settings.fromJson].
  File get settingsFile => File("${outputDir.path}/settings.json");

  /// Map the command to file the output should into 
  /// 
  /// Used for logging rover metrics
  Map<String, File> modes = { ///name better
    "ArmData": File(""),
    "GripperData": File(""),
    //GpsCoordinates(): File(""),
    "ElectricalData": File(""),
    "AutonomyData": File(""),
    "DriveData": File(""),
    // MarsData()
  };

  /// Ensure that files and directories that are expected to be present actually
  /// exist on the system. If not, create them. 
  @override
  Future<void> init() async {
    final appDir = await getApplicationDocumentsDirectory();
    outputDir = Directory("${appDir.path}/Dashboard");
    await outputDir.create();
    if (!settingsFile.existsSync()) await settingsFile.writeAsString(jsonEncode({}));
    await Directory("${outputDir.path}/logs").create();
    /// DateTime.now().toIso8601String() can be converted back to DateTime object using DateTime.parse()
    loggingDir = await Directory("${outputDir.path}/logs/${DateTime.now().timeStamp()}").create();
    modes.forEach((mode, file) async {
      /// Create CSV file and add the header row from json keys
      
      modes[mode] = await File("${loggingDir.path}/$mode.csv").create();
    });
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
    final Map<String, dynamic> jsonMap = message.writeToJsonMap();
    final List<dynamic> values = jsonMap.values.toList();
    /// Insert time at front of list so that it will be in first column 
    values.insert(0, DateTime.now());
    /// [!] Message will always be in modes map
    /// [!] rowString will also never be null since convertSingleRow never returns null
    await modes[message]!.writeAsString(converter.convertSingleRow(StringBuffer(), values)!, mode: FileMode.writeOnlyAppend);
  }
}



extension on FileSystemEntity {
  String get filename => uri.pathSegments.last.split(".")[0];
}
