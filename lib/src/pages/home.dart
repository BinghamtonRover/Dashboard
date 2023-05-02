import "package:flutter/material.dart";

import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/pages.dart";
import "package:rover_dashboard/widgets.dart";

/// A widget to switch between tank and rover modes.
class SocketSwitcher extends StatelessWidget {
	@override
	Widget build(BuildContext context) => ProviderConsumer<Sockets>.value(
		value: models.rover.sockets,
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
	bool showSidebar = true;

	@override
	Widget build(BuildContext context) => Scaffold(
		appBar: AppBar(
			title: Text("Dashboard v${models.home.version ?? ''}"),
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
