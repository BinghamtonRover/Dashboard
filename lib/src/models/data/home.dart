import "dart:async";
import "package:package_info_plus/package_info_plus.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";

/// The view model for the main page. 
class HomeModel extends Model {
	/// The message currently displaying on the taskbar.
	TaskbarMessage? message;

	/// The timer responsible for clearing the [message].
	Timer? _messageTimer;

	/// The dashboard's version from the `pubspec.yaml`. 
	String? version;

  /// Timer to display how much time is left 
  MissionTimer? timer;

	@override
	Future<void> init() async { 
		final info = await PackageInfo.fromPlatform();
		version = "${info.version}+${info.buildNumber}";
		if (services.error != null) setMessage(severity: Severity.critical, text: services.error!);
	}

	/// Sets a new message that will disappear in 5 seconds.
	void setMessage({required Severity severity, required String text}) {
		_messageTimer?.cancel();  // the new message might be cleared if the old one were about to
		message = TaskbarMessage(severity: severity, text: text);
		notifyListeners();
		_messageTimer = Timer(const Duration(seconds: 5), () { message = null; notifyListeners(); });
	} 
}
