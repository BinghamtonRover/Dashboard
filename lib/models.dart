// ignore_for_file: directives_ordering

/// A library that manages and controls the state of the app. 
/// 
/// This library is comprised of classes that have methods to allow simple control over the app's
/// state, which can have side effects as well. For example, adjusting the speed of the rover will 
/// change the value of the on-screen speedometer while also commanding the rover to move faster. 
/// 
/// This library may depend on the data and services library. 
library models;

import "src/models/model.dart";
import "src/models/data/home.dart";
import "src/models/data/serial.dart";
import "src/models/data/video.dart";
import "src/models/rover/rover.dart";
export "src/models/model.dart";

// Data models
export "src/models/data/home.dart";
export "src/models/data/serial.dart";
export "src/models/data/video.dart";

// Rover models
export "src/models/rover/heartbeats.dart";
export "src/models/rover/metrics.dart";
export "src/models/rover/rover.dart";

// View models
export "src/models/view/modes/mode.dart";
export "src/models/view/modes/arm.dart";
export "src/models/view/modes/autonomy.dart";
export "src/models/view/modes/drive.dart";
export "src/models/view/modes/science.dart";

/// A wrapper model around all other data models used by the app.
/// 
/// Use this class to ensure a data model will be initialized before the dashboard starts. For a 
/// view model (a model that only needs to be used in one part of the UI), use the model directly
/// with a `ChangeNotifierProvider` from `package:provider`.
///
/// When adding a new model to this class, be sure to: 
/// 1. Add it as a field
/// 2. Initialize it in [init]
/// 3. Add it to the `MultiProvider` in `app.dart`
class Models extends Model {
	/// Whether all models have been initialized.
	bool isReady = false;

	/// The data model to provide video from the rover.
	final video = VideoModel(); 

	/// Contains persistent data about the dashboard's current state.
	final home = HomeModel();

	/// Controls and interacts with the rover.
	final rover = Rover();

	/// Responsible for connecting to and monitoring Serial devices.
	final serial = SerialModel();

	@override
	Future<void> init() async {
		// initialize all models here
		await home.init();
		await video.init();
		await rover.init();
		await serial.init();

		isReady = true;
		notifyListeners();
	}

	@override
	void dispose() {
		home.dispose();
		video.dispose();
		rover.dispose();
		serial.dispose();
		super.dispose();
	}
}

/// The data model representing the entire backend of the dashboard.
/// 
/// This constant is here to provide easy access to the backend. But simply using this variable
/// will not cause the UI to update. For that, you must place it in a `ChangeNotifierProvider`
/// and use `Consumer` when needed.
final models = Models()..init();
