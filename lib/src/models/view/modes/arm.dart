import "package:rover_dashboard/data.dart";

import "mode.dart";

/// A view model for arm mode.
class ArmModel extends OperatingModeModel {	
	@override
	OperatingMode get mode => OperatingMode.arm;
}
