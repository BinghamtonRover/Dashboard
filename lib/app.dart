/// Defines any global app configuration. 
/// 
/// Usually this page is reserved for theming, navigation, and startup logic.
/// 
/// This library is the final touch that ties the app together, so it may depend on any other 
/// library (except for main.dart).  
library app;

import "package:flutter/material.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/pages.dart";
import "package:rover_dashboard/widgets.dart";

/// The classic Binghamton green.
const binghamtonGreen = Color(0xff005943);

/// The main class for the app. 
class RoverControlDashboard extends ReusableReactiveWidget<SettingsModel> {
  /// Creates the main app.
  RoverControlDashboard() : super(models.settings);

	@override
	Widget build(BuildContext context, SettingsModel model) => MaterialApp(
    title: "Binghamton University Rover Team",
    home: SplashPage(),
    debugShowCheckedModeBanner: false,
    themeMode: models.isReady ? model.dashboard.themeMode : ThemeMode.system,
    theme: ThemeData(
      useMaterial3: false,
      colorScheme: ColorScheme.light(
        primary: binghamtonGreen,
        secondary: binghamtonGreen,
        surfaceVariant: Colors.blueGrey.shade400,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: binghamtonGreen,
        foregroundColor: Colors.white,
      ),
    ),
    darkTheme: ThemeData.from(
      colorScheme: ColorScheme.dark(
        primary: binghamtonGreen,
        secondary: binghamtonGreen,
        surfaceVariant: Colors.blueGrey.shade700,
      ),
    ),
    routes: {
      Routes.home: (_) => HomePage(),
      Routes.settings: (_) => SettingsPage(),
    },
	);
}
