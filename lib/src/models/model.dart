import "package:flutter/foundation.dart";

/// A data model that handles data from services.
abstract class Model with ChangeNotifier {
	/// Initializes any data needed by this model.
	Future<void> init();
}
