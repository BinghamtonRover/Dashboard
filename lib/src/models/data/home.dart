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

  /// Mission timer displayed on homepage
  final mission = MissionTimer();

	@override
	Future<void> init() async { 
		final info = await PackageInfo.fromPlatform();
		version = "${info.version}+${info.buildNumber}";
    models.messages.registerHandler<BurtLog>(name: BurtLog().messageName, decoder: BurtLog.fromBuffer, handler: handleLog);
		if (services.error != null) setMessage(severity: Severity.critical, text: services.error!);
	}

	/// Sets a new message that will disappear in 3 seconds.
	void setMessage({required Severity severity, required String text}) {
		_messageTimer?.cancel();  // the new message might be cleared if the old one were about to
		message = TaskbarMessage(severity: severity, text: text);
		notifyListeners();
		_messageTimer = Timer(const Duration(seconds: 3), () { message = null; notifyListeners(); });
	} 

  /// Sends a log message to be shown in the footer.
  void handleLog(BurtLog log) {
    switch (log.level) {
      case BurtLogLevel.critical: setMessage(severity: Severity.critical, text: log.title);
      case BurtLogLevel.warning: setMessage(severity: Severity.warning, text: log.title);
      case BurtLogLevel.error: setMessage(severity: Severity.error, text: log.title);
      case BurtLogLevel.info: 
      case BurtLogLevel.debug: 
      case BurtLogLevel.trace: 
      case BurtLogLevel.BURT_LOG_LEVEL_UNDEFINED: 
    }
  }
}
