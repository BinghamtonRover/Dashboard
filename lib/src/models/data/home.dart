import "dart:async";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";

/// The view model for the main page. 
class HomeModel extends Model {
	/// The current operating mode.
	OperatingMode mode = OperatingMode.science;

	/// The message currently displaying on the taskbar.
	TaskbarMessage? message;

	/// The timer responsible for clearing the [message].
	Timer? _messageTimer;

	@override
	Future<void> init() async { }

	/// Sets a new message that will disappear in 5 seconds.
	void setMessage({required Severity severity, required String text}) {
		_messageTimer?.cancel();  // the new message might be cleared if the old one were about to
		message = TaskbarMessage(severity: severity, text: text);
		notifyListeners();
		_messageTimer = Timer(const Duration(seconds: 5), () { message = null; notifyListeners(); });
	} 

	/// Changes the mode based on an index.  
	void changeMode(int index) {
		mode = OperatingMode.values[index];
		models.rover.updateMode(mode);
		services.gamepad.vibrate();
		notifyListeners();
	}

	/// Switches to the next mode.
	void nextMode() {
		int index = mode.index + 1;
		if (index == OperatingMode.values.length) index = 0;
		changeMode(index);
	}
}
