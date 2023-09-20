/// Contains the high-level UI code that defines each page.
/// 
/// This library is organized by having a separate file for each page (or complex popup) in 
/// the entire app. 
/// 
/// This library may depend on the data, services, models, and widgets libraries. 
library pages;

export "src/pages/autonomy.dart";
export "src/pages/home.dart";
export "src/pages/science.dart";
export "src/pages/settings.dart";
export "src/pages/splash.dart";

/// The names of all the pages available in the app.
/// 
/// These names are used to jump from page to page. They are equivalent to a URL. 
class Routes { 
	/// The name of the settings page.
	static const String settings = "settings"; 

	/// The name of the home page.
	static const String home = "home"; 

	/// The name of the science analysis page.
	static const String science = "Science Analysis"; 

	/// The name of the autonomy page.
	static const String autonomy = "Map"; 

	/// The name of the MARS page.
	static const String mars = "MARS";

	/// The name of the blank page.
	static const String blank = "blank";
}
