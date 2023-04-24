import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/services.dart";

import "../model.dart";

/// Manages the user's settings.
class SettingsModel extends Model {
	/// The current settings.
	late Settings settings;

	/// The user's network settings.
	NetworkSettings get network => settings.network;

	/// The user's arm settings.
	ArmSettings get arm => settings.arm;

	@override
	Future<void> init() async {
		settings = await services.files.readSettings();
	}

	/// Replaces the current settings with the provided ones.
	Future<void> update(Settings value) async {
		await save();
		settings = value;
	}

	/// Saves the user's settings after a modification.
	Future<void> save() => services.files.writeSettings(settings);
}
