import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:just_audio/just_audio.dart";

import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/pages.dart";
import "package:rover_dashboard/services.dart";
import "package:rover_dashboard/widgets.dart";

/// Initializes the dashboard and handles errors.
class SplashPage extends StatefulWidget {
	@override
	SplashPageState createState() => SplashPageState();
}

/// The state of the SEGA animation.
enum SegaState {
	/// The rover is off-screen to the left, facing the right, and the text is transparent.
	partOne,
	/// The rover is off-screen to the right, facing the right, and the text is 30% opaque.
	partTwo,
	/// The rover is off-screen to the left, facing the left, and the text is 100% opaque.
	partThree,
}

/// Initializes the dashboard and handles errors.
class SplashPageState extends State<SplashPage>{
	/// The error message produced during initialization, if any.
	String? errorText;

	/// The current task, if any.
	String? current;

	/// The state of the SEGA animation.
	SegaState state = SegaState.partOne;

  /// The Audio player.
  final audioPlayer = AudioPlayer();

	@override
	void initState() {
		super.initState();
		init();
	}

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

	/// Starts the SEGA animation.
	Future<void> initAnimation() async {
    if (models.settings.easterEggs.segaSound) {
      await audioPlayer.setAsset("assets/binghamton2.wav");
      await audioPlayer.setVolume(0.5);
      audioPlayer.play().ignore();
    }
		setState(() => state = SegaState.partTwo);
		await Future<void>.delayed(const Duration(milliseconds: 750));
		setState(() => state = SegaState.partThree);
		await Future<void>.delayed(const Duration(milliseconds: 750));
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
			if (models.settings.easterEggs.segaIntro) await initAnimation();
			if (mounted) {
				await Navigator.of(context).pushReplacementNamed(Routes.home);
			}			
		} catch (error, stackTrace) {
			setState(() => errorText = "$error\n$stackTrace");
			rethrow;
		}
	}

	@override
	Widget build(BuildContext context) => Scaffold(
		body: errorText == null
			? Stack(  // SEGA intro
				alignment: Alignment.center,					
				children: [
					AnimatedOpacity(
						duration: const Duration(milliseconds: 1000),
						opacity: switch (state) {
							SegaState.partOne => 0,
							SegaState.partTwo => 0.2,
							SegaState.partThree => 1,
						},
						child: Text("Binghamton University\nRover Team", textAlign: TextAlign.center, style: context.textTheme.displayMedium),
					),
					AnimatedAlign(
						duration: const Duration(milliseconds: 500),
						alignment: switch (state) {
							SegaState.partOne => const Alignment(-1.5, 0),
							SegaState.partTwo => const Alignment(1.5, 0),
							SegaState.partThree => const Alignment(-1.5, 0),
						},
						child: Transform.flip(
							flipX: switch (state) {
								SegaState.partOne => true, 
								SegaState.partTwo => true, 
								SegaState.partThree => false, 
							},
							child: SizedBox(
								width: 150, 
								height: 150, 
								child: Image.asset("assets/rover.png"),
							),
						),
					),
				],
			)
			: Center(child: Column(  // Error
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
			),),
	);
}
