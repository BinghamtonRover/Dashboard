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
import "src/models/data/logs.dart";
import "src/models/data/home.dart";
import "src/models/data/messages.dart";
import "src/models/data/serial.dart";
import "src/models/data/settings.dart";
import "src/models/data/sockets.dart";
import "src/models/data/video.dart";
import "src/models/data/views.dart";
import "src/models/rover/rover.dart";

export "src/models/model.dart";

// Data models
export "src/models/data/home.dart";
export "src/models/data/logs.dart";
export "src/models/data/messages.dart";
export "src/models/data/serial.dart";
export "src/models/data/settings.dart";
export "src/models/data/sockets.dart";
export "src/models/data/video.dart";
export "src/models/data/views.dart";

// Rover models
export "src/models/rover/controller.dart";
export "src/models/rover/controls/controls.dart";
export "src/models/rover/metrics.dart";
export "src/models/rover/rover.dart";

// View models
export "src/models/view/map.dart";
export "src/models/view/logs.dart";
export "src/models/view/mars.dart";
export "src/models/view/science.dart";
export "src/models/view/timer.dart";

// Builder models
export "src/models/view/builders/autonomy_command.dart";
export "src/models/view/builders/gps.dart";
export "src/models/view/builders/science_command.dart";
export "src/models/view/builders/builder.dart";
export "src/models/view/builders/color_builder.dart";
export "src/models/view/builders/settings_builder.dart";
export "src/models/view/builders/throttle.dart";
export "src/models/view/builders/timer_builder.dart";
export "src/models/view/builders/video_builder.dart";

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

	/// The data model responsible for communicating over Protobuf.
	final sockets = Sockets();

	/// Responsible for connecting to and monitoring Serial devices.
	final serial = SerialModel();

	/// Caches the settings and updates them to all listeners.
	final settings = SettingsModel();

	/// The views data model.
	final views = ViewsModel();

	/// The messages model.
	final messages = MessagesModel();
  
  /// The logs model.
  final logs = LogsModel();

	@override
	Future<void> init() async {
		// initialize all models here
		await settings.init();
		await home.init();
    await logs.init();
		await video.init();
		await rover.init();
		await serial.init();
		await sockets.init();
		await views.init();

		isReady = true;
		notifyListeners();
	}

	@override
	void dispose() {
		settings.dispose();
		home.dispose();
		video.dispose();
		rover.dispose();
		serial.dispose();
		sockets.dispose();
		views.dispose();

		super.dispose();
	}
}

/// The data model representing the entire backend of the dashboard.
/// 
/// This constant is here to provide easy access to the backend. But simply using this variable
/// will not cause the UI to update. For that, you must place it in a `ChangeNotifierProvider`
/// and use `Consumer` when needed.
final models = Models();
