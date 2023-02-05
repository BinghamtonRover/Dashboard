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

/// The main class for the app. 
class RoverControlDashboard extends StatelessWidget {
	@override
	Widget build(BuildContext context) => MultiProvider(
		providers: [
			ChangeNotifierProvider.value(value: models),
			ChangeNotifierProvider.value(value: models.control),
			ChangeNotifierProvider.value(value: models.metrics),
			ChangeNotifierProvider.value(value: models.video),
			ChangeNotifierProvider.value(value: models.home),

		],
		child: Consumer<Models>(
			builder: (context, models, _) => MaterialApp(
				title: "Binghamton University Rover Team",
				home: models.isReady ? HomePage() : const Scaffold(body: Center(child: CircularProgressIndicator())),
				debugShowCheckedModeBanner: false,
				theme: ThemeData(
					colorScheme: ColorScheme.fromSeed(
						seedColor: const Color(0xff005A43),  // Binghamton Green
					)
				),
				routes: {
					Routes.settings: (_) => SettingsPage(),
				}
			)
		)
	);
}
