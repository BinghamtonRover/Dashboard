import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/pages.dart";
import "package:rover_dashboard/services.dart";

/// Initializes the dashboard and handles errors.
class SplashPage extends StatefulWidget {
	@override
	SplashPageState createState() => SplashPageState();
}

/// Initializes the dashboard and handles errors.
class SplashPageState extends State<SplashPage>{
	/// The error message produced during initialization, if any.
	String? errorText;

	/// The current task, if any.
	String? current;

	@override
	void initState() {
		super.initState();
		init();
	}

	/// Calls [Services.init] and [Models.init] while monitoring for errors. 
	Future<void> init() async {
		try {
			await SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
			current = "Flutter";
			WidgetsFlutterBinding.ensureInitialized();

			current = "services";
			await services.init();

			current = "models";
			await models.init();
		} catch (error) {
			setState(() => errorText = error.toString());
			rethrow;
		}

		if (mounted) {
			await Navigator.of(context).pushReplacementNamed(Routes.home);
		}
	}

	@override
	Widget build(BuildContext context) => Scaffold(
		body: Center(child: errorText == null
			? const CircularProgressIndicator()
			: Column(
				mainAxisAlignment: MainAxisAlignment.center,
				children: [
					const Spacer(flex: 2),
					Text("Something went wrong", style: Theme.of(context).textTheme.displayLarge),
					const Spacer(),
					Text("The error occurred when trying to initialize $current", style: Theme.of(context).textTheme.headlineLarge),
					const SizedBox(height: 24),
					Text("Here is the exact error:", style: Theme.of(context).textTheme.titleLarge),
					const SizedBox(height: 16),
					Text(errorText!),
					const Spacer(flex: 2),
				],
			),
		),
	);
}
