import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/pages.dart";
import "package:rover_dashboard/widgets.dart";

/// A widget to view timer 
/// Can also stop and start timer
class Timer extends StatelessWidget {
	@override
	Widget build(BuildContext context) => ProviderConsumer<HomeModel>.value(
		value: models.home,
		builder: (model) => (model.timer == null || model.timer!.timeLeft < Duration.zero)
      ? Container()
      : SizedBox(
      width: 500,
      child: Align(
        child: Row(children: [
          Text(model.timer!.name),
          const SizedBox(width: 10),
          Text("${model.timer?.timeLeft}"),
          ElevatedButton(
            onPressed: () => model.paused ? model.resumeTimer() : model.pauseTimer(),
            child: model.paused ? const Text("Resume") : const Text("Pause"), 
          ),
          ElevatedButton(
            onPressed: () => model.stopTimer(),
            child: const Text("Delete"), 
          ),
        ],
      ),
    ),
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
			actions: [
        Timer(),
				SocketSwitcher(),
				IconButton(
					icon: const Icon(Icons.settings),
					onPressed: () => Navigator.of(context).pushNamed(Routes.settings),
				),
				Builder(builder: (context) => IconButton(
					icon: const Icon(Icons.menu),
					onPressed: () => setState(() => showSidebar = !showSidebar),
				),)
        
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
