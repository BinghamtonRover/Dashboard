/// Defines handler classes for out-of-app resources.
///
/// These resources include plugins that are designed to be general, not specific to the rover project.
/// By providing rover-centric APIs for these services, the app's logic becomes simpler and easier
/// to follow without having to study the specific service. Each service declared is to extend
/// the abstract [Service] class.
///
/// The [Services] class acts as a bundle service for all services defined in this library. Its
/// responsibilities include initializing and disposing of the services, and it also acts as a
/// sort of dependency injection service by ensuring simple access. Use the [services] singleton.
///
/// This library sits right above the data library, and may import it, but not any other library
/// in this project, only 3rd party plugins. That way, all other code can import any service.
library services;

import "src/services/files.dart";
import "src/services/gamepad/service.dart";
import "src/services/service.dart";

export "src/services/socket.dart";
export "src/services/files.dart";
export "src/services/gamepad/gamepad.dart";
export "src/services/gamepad/service.dart";
export "src/services/gamepad/state.dart";

/// A dependency injection service that manages the lifecycle of other services.
///
/// All services must only be used by accessing them from this class, and this class will take care
/// of calling lifecycle methods like [init] while handling possibly asynchrony.
///
/// When adding a new service, declare it as a field in this class **and** add it to the [init]
/// and [dispose] methods. Otherwise, the service will fail to initialize and dispose properly.
///
/// To get an instance of this class, use [services].
class Services extends Service {
	/// A service that handles controller inputs.
	final gamepad = GamepadService();

	/// A service that reads and writes to device files.
	final files = FilesService();

	/// The first error that occurred during startup.
	String? error;

	@override
	Future<void> init() async {
		await gamepad.init();
		await files.init();
	}

	@override
	Future<void> dispose() async {
		await gamepad.dispose();
		await files.dispose();
	}
}

/// The singleton instance of the [Services] class.
///
/// This is the only instance of this class the app can guarantee is properly initialized.
final services = Services();
