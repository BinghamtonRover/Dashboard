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
      : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(model.timer!.name,
              style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1), fontSize: 18),
            ),
            SizedBox(width: model.timer!.underMin ? 8 : 0),
            Container(
              padding: const EdgeInsets.all(8),
              color: model.timer!.underMin ? const Color.fromRGBO(0, 0, 0, 1) : const Color.fromRGBO(0, 0, 0, 0),
              child: Text("${model.timer?.timeLeftFormatted}",
                style: model.timer!.underMin ? const TextStyle( 
                  color:  Color.fromRGBO(179, 0, 0, 1), 
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ) 
                : const TextStyle( 
                  color: Color.fromRGBO(250, 255, 255, 1), 
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(width: model.timer!.underMin ? 8 : 0),
            ElevatedButton(
              onPressed: () => model.timer!.paused ? model.resumeTimer() : model.pauseTimer(),
              child: model.timer!.paused ? const Text("Resume") : const Text("Pause"), 
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => model.stopTimer(),
              child: const Text("Delete"), 
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
