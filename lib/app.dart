/// Defines any global app configuration. 
/// 
/// Usually this page is reserved for theming, navigation, and startup logic.
/// 
/// This library is the final touch that ties the app together, so it may depend on any other 
/// library (except for main.dart).  
library app;

import "package:flutter/material.dart";
import "package:rover_dashboard/pages.dart";

/// The classic Binghamton green.
const binghamtonGreen = Color(0xff005943);

/// The main class for the app. 
class RoverControlDashboard extends StatelessWidget {
	@override
	Widget build(BuildContext context) => MaterialApp(
    title: "Binghamton University Rover Team",
    home: SplashPage(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: false,
      colorScheme: const ColorScheme.light(
        primary: binghamtonGreen,
        secondary: binghamtonGreen,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: binghamtonGreen,
        // titleTextStyle: TextStyle(color: Colors.white),
        foregroundColor: Colors.white,
      ),
    ),
    darkTheme: ThemeData.from(
      colorScheme: const ColorScheme.dark(
        primary: binghamtonGreen,
        secondary: binghamtonGreen,
      ),
    ),
    routes: {
      Routes.home: (_) => HomePage(),
      Routes.settings: (_) => SettingsPage(),
    },
	);
}
