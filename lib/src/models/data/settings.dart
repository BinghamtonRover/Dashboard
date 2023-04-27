import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";

/// Manages the user's settings.
class SettingsModel extends Model {
	/// The current settings.
	late Settings all;

	/// The user's network settings.
	NetworkSettings get network => all.network;

	/// The user's arm settings.
	ArmSettings get arm => all.arm;

	@override
	Future<void> init() async {
		all = await services.files.readSettings();
	}

	/// Replaces the current settings with the provided ones.
	Future<void> update(Settings value) async {
		try {
			await services.files.writeSettings(value);
			all = value;
			notifyListeners();
		} catch (error) {
			models.home.setMessage(severity: Severity.critical, text: "Could not save settings: $error");
		}
	}
}