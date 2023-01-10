/// A library that manages and controls the state of the app. 
/// 
/// This library is comprised of classes that have methods to allow simple control over the app's
/// state, which can have side effects as well. For example, adjusting the speed of the rover will 
/// change the value of the on-screen speedometer while also commanding the rover to move faster. 
/// 
/// This library may depend on the data and services library. 
library models;

import "src/models/metrics.dart";
import "src/models/model.dart";

export "src/models/metrics.dart";

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

	/// The data model to provide metrics from the rover.
	final MetricsModel metrics = MetricsModel();

	@override
	Future<void> init() async {
		// initialize all models here
		await metrics.init();

		isReady = true;
		notifyListeners();
	}
}

/// The data model representing the entire backend of the dashboard.
/// 
/// This constant is here to provide easy access to the backend. But simply using this variable
/// will not cause the UI to update. For that, you must place it in a `ChangeNotifierProvider`
/// and use `Consumer` when needed.
final models = Models()..init();

