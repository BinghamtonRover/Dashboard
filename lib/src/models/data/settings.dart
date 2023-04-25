import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/services.dart";

import "../model.dart";

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
		await save();
		all = value;
	}

	/// Saves the user's settings after a modification.
	Future<void> save() => services.files.writeSettings(all);
}
