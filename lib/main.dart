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
import "package:rover_dashboard/services.dart";

/// Network errors that can be fixed by a simple reset.
const networkErrors = {1234, 1231};

void main() async {
	runZonedGuarded(
		() => runApp(RoverControlDashboard()),
		(error, stack) async {
			if (error is SocketException && networkErrors.contains(error.osError!.errorCode)) {
				models.home.setMessage(severity: Severity.critical, text: "Network error, restart by clicking the network icon");
			} else {
        models.home.setMessage(severity: Severity.critical, text: "Dashboard error. See the logs");
        await services.files.logError(error, stack);
				Error.throwWithStackTrace(error, stack);
			}
		}
	);
}
