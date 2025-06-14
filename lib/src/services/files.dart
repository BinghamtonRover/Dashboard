// ignore_for_file: directives_ordering
import "dart:convert";
import "dart:io";
import "dart:async";

import "package:collection/collection.dart";
import "package:flutter/foundation.dart";
import "package:path_provider/path_provider.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/services.dart";

import "service.dart";

extension on FileSystemEntity {
  String get filename => uri.pathSegments.last.split(".").first;
}

extension on Directory {
  File operator / (String filename) => File("$path/$filename");
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
  late Directory outputDir;

  /// The directory where all logging data is outputted
  ///
  /// This includes all the different operating modes with specified folders inside
  late Directory loggingDir;

  /// The directory where screenshots are stored.
  ///
  /// These are only screenshots of video feeds, not of the dashboard itself.
  Directory get screenshotsDir => Directory("${outputDir.path}/screenshots");

  /// The file containing the user's [Settings], in JSON form.
  ///
  /// This file should contain the result of [Settings.toJson], and loading settings
  /// from the file should be done with [Settings.fromJson].
  File get settingsFile => outputDir / "settings.json";

  /// The encoder to convert a Map<> to a json string with a nice indent
  final JsonEncoder jsonEncoder = const JsonEncoder.withIndent("  ");

  bool _isInit = false;

  /// Ensure that files and directories that are expected to be present actually
  /// exist on the system. If not, create them.
  @override
  Future<void> init() async {
    final appDir = await getApplicationDocumentsDirectory();
    outputDir = await Directory("${appDir.path}/Dashboard").create();
    loggingDir = await Directory("${outputDir.path}/logs/${DateTime.now().timeStamp}").create(recursive: true);
    if (!settingsFile.existsSync()) await writeSettings(null);
    dataLogger = Timer.periodic(const Duration(seconds: 5), logAllData);
    _isInit = true;
  }

  @override
  Future<void> dispose() async {
    dataLogger.cancel();
  }

  /// Saves the [Settings] object to the [settingsFile], as JSON.
  Future<void> writeSettings(Settings? value) async {
    final json = jsonEncoder.convert(value?.toJson() ?? {});
    await settingsFile.writeAsString(json);
  }

  /// Reads the user's settings from the [settingsFile].
  Future<Settings> readSettings({bool retry = true}) async {
    final Json json = jsonDecode(await settingsFile.readAsString());
    try {
      final settings = Settings.fromJson(json);
      await writeSettings(settings);  // re-save any default values
      return settings;
    } catch (error) {
      if (kDebugMode) {
        print("Here are the contents of the settings file: \n$json");
        rethrow;
      }
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
    final number = files.where((file) => file.filename.startsWith("screenshot_")).length;
    await File("${dir.path}/screenshot_$number.jpg").writeAsBytes(image);
  }

  /// Saves all the data in [batchedLogs] to a file by calling [logAllData].
  late Timer dataLogger;

  /// Holds data to be logged by [logData] when [dataLogger] fires.
  ///
  /// This is used by [logData] instead of writing the data immediately because data can come in at
  /// an unpredictable and burdensome rate, which would make the dashboard write a lot of data at
  /// once to the same file(s) and overload the user's device.
  Map<String, List<WrappedMessage>> batchedLogs = {};

  /// A cache of the last log message written for each message type written to a file
  /// 
  /// This is used by [logData] to avoid rewriting logs with duplicate data,
  /// which reduces file size and improves performance
  Map<String, WrappedMessage> lastWritten = {};

  /// Logs all the data saved in [batchedLogs] and resets it.
  Future<void> logAllData(Timer timer) async {
    final writeFutures = <Future<void>>[];
    for (final name in batchedLogs.keys) {
      final data = batchedLogs[name]!;
      if (data.isEmpty) {
        continue;
      }
      final file = loggingDir / "$name.log";
      final copy = List<WrappedMessage>.from(data);
      data.clear();

      lastWritten[name] = copy.last;

      writeFutures.add(
        Future(() async {
          for (final wrapper in copy) {
            final encoded = base64.encode(wrapper.writeToBuffer());
            await file.writeAsString(
              "$encoded\n",
              mode: FileMode.writeOnlyAppend,
            );
          }
        }),
      );
    }
    await Future.wait(writeFutures);
  }

  /// Outputs log data to the correct file based on message
  ///
  /// If [includeDuplicate] is set to false (default), then it will only write
  /// the log to a file if it doesn't match the previously written log of the
  /// message type
  Future<void> logData(Message message, {bool includeDuplicate = false}) async {
    final batch = batchedLogs[message.messageName] ??= [];
    final lastLog = lastWritten[message.messageName];

    final wrapped = message.wrap();

    if (includeDuplicate) {
      batch.add(wrapped);
      return;
    }

    // If the last queued log is the same data
    if (batch.isNotEmpty && batch.last.data.equals(wrapped.data)) {
      return;
    } else if (batch.lastOrNull == null &&
        lastLog != null &&
        lastLog.data.equals(wrapped.data)) {
      // If the last written log has the same data
      return;
    }
    batch.add(wrapped);
  }

  /// Reads logs from the given file.
  Future<List<WrappedMessage>> readLogs(File file) async => [
    for (final line in (await file.readAsString()).trim().split("\n"))
      WrappedMessage.fromBuffer(base64.decode(line)),
  ];

  /// Outputs a log to its device's respective log file.
  Future<void> logMessage(BurtLog log) async {
    if (!_isInit) return;
    final file = loggingDir / "${log.device.humanName}.log";
    await file.writeAsString("${log.format()}\n", mode: FileMode.writeOnlyAppend);
  }
}
