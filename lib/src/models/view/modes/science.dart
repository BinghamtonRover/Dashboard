import "package:rover_dashboard/data.dart";

import "mode.dart";

/// The view model for science mode.
class ScienceModel extends OperatingModeModel {
	@override
	OperatingMode get mode => OperatingMode.science;
}
