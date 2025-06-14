/// Contains the high-level UI code that defines each page.
///
/// This library is organized by having a separate file for each page (or complex popup) in
/// the entire app.
///
/// This library may depend on the data, services, models, and widgets libraries.
library pages;

export "src/pages/arm.dart";
export "src/pages/drive.dart";
export "src/pages/map.dart";
export "src/pages/home.dart";
export "src/pages/science.dart";
export "src/pages/logs.dart";
export "src/pages/rocks.dart";
export "src/pages/settings.dart";
export "src/pages/splash.dart";
export "src/pages/electrical.dart";
export "src/pages/view.dart";
export "src/pages/lidar.dart";
export "src/pages/subsystems.dart";

/// The names of all the pages available in the app.
///
/// These names are used to jump from page to page. They are equivalent to a URL.
class Routes {
	/// The name of the settings page.
	static const String settings = "settings";

	/// The name of the home page.
	static const String home = "home";

  /// The name of the screensaver page
  static const String screenSaver = "screen saver";

  /// The name of the lidar page.
  static const String lidar = "Lidar";

	/// The name of the science analysis page.
	static const String science = "Science Analysis";

  /// The name of the electrical data page
  static const String electrical = "Electrical";

  /// The name of the drive/position data page
  static const String drive = "Drive";

  /// The name of the arm IK page.
  static const String arm = "Arm";

	/// The name of the autonomy page.
	static const String autonomy = "Map";

  /// The name of the subsystems page
  static const String subsystems = "Subsystems";

  /// The name of the logs page.
  static const String logs = "Logs";

  /// The name of the controllers page
  static const String controllers = "Controllers";

  /// The name of the rocks page.
  static const String rocks = "Rocks";

  /// The name of the base station page
  static const String baseStation = "Base Station";

	/// The name of the blank page.
	static const String blank = "Remove View";
}
