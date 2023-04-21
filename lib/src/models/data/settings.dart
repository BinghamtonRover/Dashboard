import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/services.dart";

import "../model.dart";

class SettingsModel extends Model {
	late Settings settings;

	ArmSettings get arm => settings.arm;

	@override
	Future<void> init() async {
		settings = await services.files.readSettings();
	}
}
