import "package:flutter/material.dart";
import "package:rover_dashboard/pages.dart";

import "package:rover_dashboard/widgets.dart";

import "../../models/view/camera_feed.dart";

/// The page for the science operating mode. 
class ScienceMode extends StatefulWidget {

	/// A constructor for this widget.
  @override
  State<ScienceMode> createState() => _ScienceModeInstance();
  
}

class _ScienceModeInstance extends State<ScienceMode> {

  @override
  Widget build(BuildContext contest) => ValueListenableBuilder(
    valueListenable: HomePage.numCameraFeeds, 
    builder: (BuildContext context, value, screensWidget) {
      // what is the max number of camera feeds we will have?
      if(HomePage.numCameraFeeds.value == 0) {
        screensWidget = zeroFeed;
      }
      else if(HomePage.numCameraFeeds.value == 1) {
        screensWidget = oneFeed;
      }
      else if(HomePage.numCameraFeeds.value == 2) {
        screensWidget = twoFeed;
      }
      else if(HomePage.numCameraFeeds.value == 3) {
        screensWidget = threeFeed;
      }
      else if(HomePage.numCameraFeeds.value == 4) {
        screensWidget = fourFeed;
      }
      return screensWidget!;
    },
  );

  Widget zeroFeed = const Text("No Feeds Currently Selected");

  Widget oneFeed = Row(children: [
		Expanded(child: Column(children: [
			Expanded(child: Container(
				height: double.infinity,
				width: double.infinity,
				color: Colors.green, 
				child: Text(HomePage.feeds.where((element) => element.showing).first.fullName),
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
	]);

  Widget twoFeed = ValueListenableBuilder(
    valueListenable: HomePage.pinnedCameraFeed, 
    builder: (BuildContext context, value, screensWidget) => Row(children: [
      Expanded(child: Column(children: [
        Expanded(child: Row(
          children: [
            Expanded(child: Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.green, 
              child: Text(HomePage.feeds.where((element) => element.pinned && element.showing).first.fullName),
            )),
            Expanded(child: Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.blueGrey,
              child: Text(HomePage.feeds.where((element) => !element.pinned && element.showing).first.fullName),
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
}

/// The controls for the current operating mode, until there is a backend in place.
final controls = [
	"Start dig sequence: START",
	"Change operation mode: BACK",
	"Move Auger: D-pad Up/Down",
	"...",
];
