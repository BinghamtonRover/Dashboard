import "package:rover_dashboard/data.dart";

import "mode.dart";

/// A view model for drive mode. 
class DriveModel extends OperatingModeModel {	
	@override
	OperatingMode get mode => OperatingMode.drive;
}
