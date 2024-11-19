import "dart:async";
import "package:package_info_plus/package_info_plus.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";

/// The view model for the main page.
class HomeModel extends Model {
	/// The message currently displaying on the taskbar.
	TaskbarMessage? message;

  /// Whether the current message is an error.
  bool _hasError = false;

	/// The timer responsible for clearing the [message].
	Timer? _messageTimer;

	/// The dashboard's version from the `pubspec.yaml`.
	String? version;

  /// Mission timer displayed on homepage
  final mission = MissionTimer();

	@override
	Future<void> init() async {
    models.settings.addListener(notifyListeners);
		final info = await PackageInfo.fromPlatform();
		version = "${info.version}+${info.buildNumber}";
		if (services.error != null) setMessage(severity: Severity.critical, text: services.error!);
	}

	/// Sets a new message that will disappear in 3 seconds.
	void setMessage({required Severity severity, required String text, bool permanent = false, bool logMessage = true}) {
    if (_hasError && severity != Severity.critical) return;  // Don't replace critical messages
		_messageTimer?.cancel();  // the new message might be cleared if the old one were about to
		message = TaskbarMessage(severity: severity, text: text);
    if (logMessage) models.logs.handleLog(message!.burtLog);
		notifyListeners();
    _hasError = permanent;
    _messageTimer = Timer(const Duration(seconds: 3), clear);
	}

  /// Clears the current message. Errors won't be cleared unless [clearErrors] is set.
  void clear({bool clearErrors = false}) {
    if (_hasError && !clearErrors) return;
    _hasError = false;
    message = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _messageTimer?.cancel();
    mission.cancel();
    models.settings.removeListener(notifyListeners);
    super.dispose();
  }
}
