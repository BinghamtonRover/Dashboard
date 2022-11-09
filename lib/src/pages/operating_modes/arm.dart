import "package:flutter/material.dart";

import "../../../pages.dart";
import "../../../widgets.dart";

/// The page for the arm operating mode. 
class ArmMode extends StatefulWidget {

	/// A constructor for this widget.
  @override
  State<ArmMode> createState() => _ArmModeInstance();
  
}

/// The instance of the stateful widget page
class _ArmModeInstance extends State<ArmMode> {

	@override
  Widget build(BuildContext contest) => ValueListenableBuilder(
    valueListenable: HomePage.feedsListener, 
    builder: (BuildContext context, value, screensWidget) {
      if(HomePage.feedsNotifier.feeds.where((element) => element.showing && element.page == 1).isEmpty) {
        screensWidget = zeroFeed;
      }
      else if(HomePage.feedsNotifier.feeds.where((element) => element.showing && element.page == 1).length == 1) {
        screensWidget = oneFeed;
      }
      else if(HomePage.feedsNotifier.feeds.where((element) => element.showing && element.page == 1).length == 2) {
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
          color: Colors.red, 
          child: Text(HomePage.feedsNotifier.feeds.where((element) => element.showing && element.page == 1).first.fullName),
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
              color: Colors.red, 
              child: Text(HomePage.feedsNotifier.feeds.where((element) => element.pinned && element.showing && element.page == 1).first.fullName),
            )),
            Expanded(child: Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.orange,
              child: Text(HomePage.feedsNotifier.feeds.where((element) => !element.pinned && element.showing && element.page == 1).first.fullName),
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
}