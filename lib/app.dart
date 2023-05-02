/// Defines any global app configuration. 
/// 
/// Usually this page is reserved for theming, navigation, and startup logic.
/// 
/// This library is the final touch that ties the app together, so it may depend on any other 
/// library (except for main.dart).  
library app;

import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/pages.dart";

/// The classic Binghamton green.
const binghamtonGreen = Color(0xff005943);

/// The main class for the app. 
class RoverControlDashboard extends StatelessWidget {
	@override
	Widget build(BuildContext context) => MultiProvider(
		providers: [
			ChangeNotifierProvider.value(value: models),
			ChangeNotifierProvider.value(value: models.video),
			ChangeNotifierProvider.value(value: models.home),
			ChangeNotifierProvider.value(value: models.rover),
			ChangeNotifierProvider.value(value: models.serial),
			ChangeNotifierProvider.value(value: models.settings),
		],
		child: Consumer<Models>(
			builder: (context, models, _) => MaterialApp(
				title: "Binghamton University Rover Team",
				home: SplashPage(),
				debugShowCheckedModeBanner: false,
				theme: ThemeData(
					colorScheme: const ColorScheme.light(
						primary: binghamtonGreen,
						secondary: binghamtonGreen,
					)
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
				}
			)
		)
	);
}
