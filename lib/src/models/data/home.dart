import "dart:async";

import "package:rover_dashboard/data.dart";

import "../model.dart";

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

	/// The list of controls for this mode.
	List<String> get controls => [  // TODO: replace with actual backend
		"Start dig sequence: START",
		"Change operation mode: BACK",
		"Move Auger: D-pad Up/Down",
		"...",
	];

	/// Changes the mode based on an index.  
	void changeMode(int index) {
		mode = OperatingMode.values[index];
		notifyListeners();
	}
}
