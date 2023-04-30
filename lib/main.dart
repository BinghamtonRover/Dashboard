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

import "app.dart";
import "data.dart";
import "models.dart";

void main() async {
	runZonedGuarded(
		() => runApp(RoverControlDashboard()),
		(error, stack) async {
			if (error is SocketException && error.osError!.errorCode == 1234) {
				models.home.setMessage(severity: Severity.critical, text: "Network error, please restart sockets in the settings");
			} else {
				Error.throwWithStackTrace(error, stack);
			}
		}
	);
}
