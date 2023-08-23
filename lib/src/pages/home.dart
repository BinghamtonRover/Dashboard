import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/pages.dart";
import "package:rover_dashboard/widgets.dart";

/// A widget to view timer 
/// Can also stop and start timer
class Timer extends StatelessWidget {
	@override
	Widget build(BuildContext context) => ProviderConsumer<MissionTimer>.value(
		value: models.home.mission,
		builder: (model) => (model.title == null)
      ? Container()
      : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("${model.title}: ",
              style: context.textTheme.headlineSmall!.copyWith(color: context.colorScheme.onPrimary),
            ),
            const SizedBox(width: 4),
            AnimatedScale(
              scale: (model.underMin) && (model.timeLeft.inSeconds.isEven) ? 1.2 : 1, 
              duration: const Duration(milliseconds: 750),
              child: Text(model.timeLeft.toString().split(".").first.padLeft(8, "0"),
                style: model.underMin
                  ? context.textTheme.headlineSmall!.copyWith(
                    color: context.colorScheme.error,
                    fontWeight: FontWeight.bold,
                  )
                  : context.textTheme.headlineSmall!.copyWith(color: context.colorScheme.onPrimary),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: model.isPaused ? model.resume : model.pause,
              child: model.isPaused ? const Text("Resume") : const Text("Pause"), 
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: model.cancel,
              child: const Text("Cancel"), 
            ),
          ],
        ),
      );
}

/// A widget to switch between tank and rover modes.
class SocketSwitcher extends StatelessWidget {
	@override
	Widget build(BuildContext context) => ProviderConsumer<Sockets>.value(
		value: models.sockets,
		builder: (model) => DropdownButton<RoverType>(
			value: model.rover,
			onChanged: model.setRover,
			focusNode: FocusNode(),
			items: [
				for (final type in RoverType.values) DropdownMenuItem(
					value: type,
					child: Text(type.humanName),
				),
			],
		),
	);
}

/// The main dashboard page.
/// 
/// Each page the user could navigate to is embedded here, as a [View]. 
class HomePage extends StatefulWidget {
	@override
	HomePageState createState() => HomePageState();
}

/// The state for the homepage. Handles showing and hiding the sidebar.
class HomePageState extends State<HomePage>{
	/// Whether to show the sidebar.
	bool showSidebar = false;

	@override
	Widget build(BuildContext context) => Scaffold(
		appBar: AppBar(
      automaticallyImplyLeading: false,
			title: Text("Dashboard v${models.home.version ?? ''}"),
      flexibleSpace: Center(child: Timer()),
			actions: [
				SocketSwitcher(),
				IconButton(
					icon: const Icon(Icons.settings),
					onPressed: () => Navigator.of(context).pushNamed(Routes.settings),
				),
				Builder(builder: (context) => IconButton(
					icon: const Icon(Icons.menu),
					onPressed: () => setState(() => showSidebar = !showSidebar),
				),),
        
			],
      
		),
		bottomNavigationBar: Footer(),
		body: Row(
			children: [
				const Expanded(child: ViewsWidget()),
				// An AnimatedSize widget automatically shrinks the widget away
				AnimatedSize(
					duration: const Duration(milliseconds: 250),
					child: showSidebar ? const Sidebar() : Container(),
				),
			],
		),
	);
}
