/// Defines any global app configuration. 
/// 
/// Usually this page is reserved for theming, navigation, and startup logic.
/// 
/// This library is the final touch that ties the app together, so it may depend on any other 
/// library (except for main.dart).  
library app;

import "package:flutter/material.dart";

import "package:rover_dashboard/pages.dart";

/// The main class for the app. 
class RoverControlDashboard extends StatefulWidget {
	@override
	RoverControlDashboardState createState() => RoverControlDashboardState();
}

/// The state object for [RoverControlDashboard].
class RoverControlDashboardState extends State<RoverControlDashboard> {
	@override
	Widget build(BuildContext context) => MaterialApp(home: DashboardPage());
}
