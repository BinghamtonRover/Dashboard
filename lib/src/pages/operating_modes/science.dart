import "package:flutter/material.dart";
import 'package:rover_dashboard/pages.dart';

import "package:rover_dashboard/widgets.dart";

/// Camera Feed Class
class CameraFeed {
  /// complete name of the camera feed ex "Science Video Feed"
  String fullName;
  /// shortened name of the camera feed ex "Science"
  String shortName;
  /// boolean value of whether or not this particular camera feed is pinned
  bool pinned = false;

  /// CameraFeed constructor
  CameraFeed(this.fullName, this.shortName, {this.pinned = false});


  /// get the pinned value of the CameraFeed
  bool get pinnedValue => pinned;
  /// change the pinned value of the CameraFeed
  set pinnedValue(bool value) {
    pinned = value;
  }
}

/// The science camera feeds available for the rover
enum ScienceCameraFeed {
  /// The main science video feed
  science(fullName: "Science Video Feed", shortName: "Science", pinned: true),

  /// The microscope video feed
  microscope(fullName: "Microscrope Video Feed", shortName: "Microscope", pinned: false),

  /// The rover video feed
  rover(fullName: "Rover Video Feed", shortName: "Rover", pinned: false);
  
  /// The full name of the camera feed
  final String fullName;

  /// The shortened name of the camera feed
  final String shortName;

  /// The boolean value of the pinned camera
  final bool pinned;

  /// Describes the UI for a given camera feed.
  const ScienceCameraFeed({required this.fullName, required this.shortName, required this.pinned});
}


/// The page for the science operating mode. 
class ScienceMode extends StatelessWidget {

	/// A const constructor for this widget.
	///const ScienceMode();
  ScienceMode();

  /// list of all the camera feeds
  List<CameraFeed> feedList = <CameraFeed>[CameraFeed("Science Video Feed", "Science", pinned: true),
    CameraFeed("Microscope Video Feed", "Microscope"), CameraFeed("Rover Video Feed", "Rover"),
    CameraFeed("Extra Video Feed", "Extra")];

	@override
	Widget build(BuildContext context) => Row(children: [
    /// make it so that it displays for each rover feed first
		Expanded(child: Column(children: [
			Expanded(child: Row (
        children: [
          Expanded(child: Container(
				    width: double.infinity,
            height: double.infinity,
				    color: Colors.red, 
				    child: Text(feedList.where((element) => element.pinned).first.fullName),
          )),
          Expanded(child: Container(
				    width: double.infinity,
            height: double.infinity,
				    color: Colors.white, 
				    child: Text(feedList.where((element) => !element.pinned).elementAt(2).fullName),
          )),
        ]
			)),
			Expanded(child: Row(
				children: [
					Expanded(child: Container(
						height: double.infinity,
						width: double.infinity,
						color: Colors.green, 
						child: Text(feedList.where((element) => !element.pinned).first.fullName),
					)),
					Expanded(child: Container(
						height: double.infinity,
						width: double.infinity,
						color: Colors.blueGrey,
						child: Text(feedList.where((element) => !element.pinned).elementAt(1).fullName),
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
					Text("Controls", style: Theme.of(context).textTheme.headline3),
					const SizedBox(height: 16),
					for (final control in controls) Text(control),
				]
			)
		),
	]);
  
}

/// The controls for the current operating mode, until there is a backend in place.
final controls = [
	"Start dig sequence: START",
	"Change operation mode: BACK",
	"Move Auger: D-pad Up/Down",
	"...",
];
