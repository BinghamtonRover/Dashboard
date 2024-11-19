/// The entrypoint of the app.
///
/// These `library` declarations are not needed, the default name for a Dart library is simply the
/// name of the file. However, DartDoc comments placed above a library declaration will show up on
/// the libraries page in the generated documentation.
///
/// This library's main purpose is to execute the app defined in the app library and is designed to
/// be as simple as possible.
library main;

import "dart:async";
import "dart:io";
import "package:flutter/material.dart";

import "package:rover_dashboard/app.dart";
import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// Network errors that can be fixed by a simple reset.
const networkErrors = {1234, 1231};

/// Converts an error and optional stack trace into a [BurtLog] and calls [LogsModel.handleLog].
void logError(Object error, StackTrace? stackTrace) => models.logs.handleLog(
  BurtLog(
    level: BurtLogLevel.critical,
    title: "Dashboard Error. Click for details",
    body: "$error\n$stackTrace",
    device: Device.DASHBOARD,
  ),
);

void main() async {
  // Logs sync errors to the logs page
  FlutterError.onError = (FlutterErrorDetails details) {
    logError(details.exception, details.stack);
    FlutterError.presentError(details);  // do the regular error behavior
  };
  // Logs async errors to the logs page
  runZonedGuarded(
    () => runApp(RoverControlDashboard()),
    (error, stackTrace) async {
      if (error is SocketException && networkErrors.contains(error.osError!.errorCode)) {
        models.home.setMessage(severity: Severity.critical, text: "Network error, restart by clicking the network icon");
      } else {
        logError(error, stackTrace);
        Error.throwWithStackTrace(error, stackTrace);  // do the regular error behavior
      }
    }
  );
}
