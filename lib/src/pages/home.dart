import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/pages.dart";
import "package:rover_dashboard/widgets.dart";

/// A widget to switch between tank and rover modes.
class SocketSwitcher extends ReusableReactiveWidget<Sockets> {
  /// A constructor for this widget.
  SocketSwitcher() : super(models.sockets);

	@override
	Widget build(BuildContext context, Sockets model) => DropdownButton<RoverType>(
    value: model.rover,
    onChanged: model.setRover,
    focusNode: FocusNode(),
    dropdownColor: context.colorScheme.secondary,
    style: const TextStyle(color: Colors.white),
    items: [
      for (final type in RoverType.values) DropdownMenuItem(
        value: type,
        child: Text(type.humanName),
      ),
    ],
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
      flexibleSpace: Center(child: TimerWidget()),
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
		bottomNavigationBar: const Footer(),
		body: Stack(children: [
      Row(
        children: [
          Expanded(child: ViewsWidget()),
          // An AnimatedSize widget automatically shrinks the widget away
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            child: showSidebar ? const Sidebar() : Container(),
          ),
        ],
      ),
      if (defaultTargetPlatform == TargetPlatform.android)
        MobileControls(),
    ],),
	);
}
