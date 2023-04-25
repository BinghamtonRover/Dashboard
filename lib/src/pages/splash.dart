import "package:flutter/material.dart";

import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/pages.dart";
import "package:rover_dashboard/services.dart";

class SplashPage extends StatefulWidget {
	@override
	SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage>{
	String? errorText, current;

	@override
	void initState() {
		super.initState();
		init();
	}

	Future<void> init() async {
		try {
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
			await Navigator.of(context).pushNamed(Routes.home);
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
				]
			)
		)
	);
}
