import "package:rover_dashboard/data.dart";

import "mode.dart";

/// A view model for autonomy mode.
class AutonomyModel extends OperatingModeModel {	
	@override
	OperatingMode get mode => OperatingMode.autonomy;
}
