import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/services.dart";

import "controls.dart";

/// A [RoverControls] that does nothing.
class AutonomyControls extends RoverControls {
	@override
	OperatingMode get mode => OperatingMode.autonomy;

	@override
	List<Message> parseInputs(GamepadState state) => [];

	@override
	List<Message> get onDispose => [];

	@override
	Map<String, String> get buttonMapping => {};
}
