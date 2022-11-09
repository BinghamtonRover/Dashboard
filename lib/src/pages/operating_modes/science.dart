import "package:flutter/material.dart";
import "package:rover_dashboard/pages.dart";

import "package:rover_dashboard/widgets.dart";

/// The page for the science operating mode. 
class ScienceMode extends StatefulWidget {

	/// A constructor for this widget.
  @override
  State<ScienceMode> createState() => _ScienceModeInstance();
  
}

/// The instance of the stateful widget
class _ScienceModeInstance extends State<ScienceMode> {
  @override
  Widget build(BuildContext contest) => ValueListenableBuilder(
    valueListenable: HomePage.feedsListener, 
    builder: (BuildContext context, value, screensWidget) {
      if(HomePage.feedsNotifier.feeds.where((element) => element.showing && element.page == 0).isEmpty) {
        screensWidget = zeroFeed;
      }
      else if(HomePage.feedsNotifier.feeds.where((element) => element.showing && element.page == 0).length == 1) {
        screensWidget = oneFeed;
      }
      else if(HomePage.feedsNotifier.feeds.where((element) => element.showing && element.page == 0).length == 2) {
        screensWidget = twoFeed;
      }
      return screensWidget!;
    },
  );

  Widget zeroFeed = const Text("No Feeds Currently Selected");

  Widget oneFeed = ValueListenableBuilder(
    valueListenable: HomePage.feedsListener, 
    builder: (BuildContext context, value, screensWidget) => Row(children: [
      Expanded(child: Column(children: [
        Expanded(child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.green, 
          child: Text(HomePage.feedsNotifier.feeds.where((element) => element.showing && element.page == 0).first.fullName),
        ))
      ])),
      Container(
        width: 225, 
        color: Colors.yellow, 
        alignment: Alignment.center,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            const MetricsList(),
            const Text("Controls"),
            const SizedBox(height: 16),
            for (final control in controls) Text(control),
          ]
        )
      ),
    ])
  );

  Widget twoFeed = ValueListenableBuilder(
    valueListenable: HomePage.feedsListener, 
    builder: (BuildContext context, value, screensWidget) => Row(children: [
      Expanded(child: Column(children: [
        Expanded(child: Row(
          children: [
            Expanded(child: Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.green, 
              child: Text(HomePage.feedsNotifier.feeds.where((element) => element.pinned && element.showing && element.page == 0).first.fullName),
            )),
            Expanded(child: Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.blueGrey,
              child: Text(HomePage.feedsNotifier.feeds.where((element) => !element.pinned && element.showing && element.page == 0).first.fullName),
            )),
          ]
        ))
      ])),
      Container(
        width: 225, 
        color: Colors.yellow, 
        alignment: Alignment.center,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            const MetricsList(),
            const Text("Controls"),
            const SizedBox(height: 16),
            for (final control in controls) Text(control),
          ]
        )
      ),
    ]),
  );

  /*
  Widget threeFeed = ValueListenableBuilder(
    valueListenable: HomePage.pinnedCameraFeed, 
    builder: (BuildContext context, value, screensWidget) => Row(children: [
      Expanded(child: Column(children: [
        Expanded(flex: 2, child: Container(
          width: double.infinity,
          color: Colors.red, 
          child: Text(HomePage.feeds.where((element) => element.pinned && element.showing).first.fullName),
        )),
        Expanded(child: Row(
          children: [
            Expanded(child: Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.green, 
              child: Text(HomePage.feeds.where((element) => !element.pinned && element.showing).first.fullName),
            )),
            Expanded(child: Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.blueGrey,
              child: Text(HomePage.feeds.where((element) => !element.pinned && element.showing).elementAt(1).fullName),
            )),
          ]
        ))
      ])),
      Container(
        width: 225, 
        color: Colors.yellow, 
        alignment: Alignment.center,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            const MetricsList(),
            Text("Controls"),
            const SizedBox(height: 16),
            for (final control in controls) Text(control),
          ]
        )
      ),
    ]),
  );

  Widget fourFeed = ValueListenableBuilder(
    valueListenable: HomePage.pinnedCameraFeed, 
    builder: (BuildContext context, value, screensWidget) => Row(children: [
      /// make it so that it displays for each rover feed first
      Expanded(child: Column(children: [
        Expanded(child: Row (
          children: [
            Expanded(child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.red, 
              child: Text(HomePage.feeds.where((element) => element.pinned && element.showing).first.fullName),
            )),
            Expanded(child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white, 
              child: Text(HomePage.feeds.where((element) => !element.pinned && element.showing).first.fullName),
            )),
          ]
        )),
        Expanded(child: Row(
          children: [
            Expanded(child: Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.green, 
              child: Text(HomePage.feeds.where((element) => !element.pinned && element.showing).elementAt(1).fullName),
            )),
            Expanded(child: Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.blueGrey,
              child: Text(HomePage.feeds.where((element) => !element.pinned && element.showing).elementAt(2).fullName),
            )),
          ]
        ))
      ])),
      Container(
        width: 225, 
        color: Colors.yellow, 
        alignment: Alignment.center,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            const MetricsList(),
            Text("Controls"),
            const SizedBox(height: 16),
            for (final control in controls) Text(control),
          ]
        )
      ),
    ]),
  );
  */
}

/// The controls for the current operating mode, until there is a backend in place.
final controls = [
	"Start dig sequence: START",
	"Change operation mode: BACK",
	"Move Auger: D-pad Up/Down",
	"...",
];
