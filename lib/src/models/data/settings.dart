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

	/// The user's science settings.
	ScienceSettings get science => all.science;

	/// The user's easter egg settings.
	EasterEggsSettings get easterEggs => all.easterEggs;

  /// The user's dashboard settings.
  DashboardSettings get dashboard => all.dashboard;

	@override
	Future<void> init() async {
		all = await services.files.readSettings();
    notifyListeners();
	}

	/// Replaces the current settings with the provided ones.
	Future<void> update([Settings? value]) async {
		try {
			await services.files.writeSettings(value ?? all);
			if (value != null) all = value;
			notifyListeners();
		} catch (error) {
			models.home.setMessage(severity: Severity.critical, text: "Could not save settings: $error");
		}
	}
}
