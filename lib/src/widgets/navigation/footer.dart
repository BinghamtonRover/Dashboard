import "package:flutter/material.dart";

/// The footer, responsible for showing vitals and logs. 
class Footer extends StatelessWidget {
	/// Whether there is a controller currently connected. 
	static const bool isControllerConnected = true;

  /// list of all the camera feeds
  List<CameraFeed> feedList = <CameraFeed>[CameraFeed("Science Video Feed", "Science", pinned: true),
    CameraFeed("Microscope Video Feed", "Microscope"), CameraFeed("Rover Video Feed", "Rover"),
    CameraFeed("Extra Video Feed", "Extra"), CameraFeed("None", "None")];

  /// the pinned dropdown value
  String selected = "Science";

  /// function call to show the camera feeds
  void showFeedsDialog(BuildContext context) {
    showDialog(context: context, 
      builder: (BuildContext context) => SimpleDialog(
        title: const Text("Camera Feeds Controller"),
        children: [
          const Text("Visible Camera Feeds"),
          CheckboxListTile(
            title: Text(feedList.elementAt(0).shortName), 
            onChanged: null,
            value: true,
          ),
          CheckboxListTile(
            title: Text(feedList.elementAt(1).shortName), 
            onChanged: null,
            value: true,
          ),
          CheckboxListTile(
            title: Text(feedList.elementAt(2).shortName), 
            onChanged: null,
            value: true,
          ),
          CheckboxListTile(
            title: Text(feedList.elementAt(3).shortName), 
            onChanged: null,
            value: true,
          ),
          const Text("Pinned Camera Feed"),
          DropdownButton<String>(
            items: feedList.map<DropdownMenuItem<String>>((CameraFeed feed) => DropdownMenuItem<String>(
                value: feed.shortName,
                child: Text(feed.shortName),
                
              )
            ).toList(), 
            onChanged: (String? val) {
              feedList.where((element) => element.pinned).first.pinned = false;
              feedList.where((element) => element.shortName == val).first.pinned = true;
              selected = val!;
            },
            value: selected,
            icon: const Icon(Icons.arrow_downward),
          )
        ],
      )
      
    );
  }
	@override
	Widget build(BuildContext context) => Container(
		height: 48,
		color: Colors.blue,
		child: Row(
			mainAxisAlignment: MainAxisAlignment.end,
			children: [
        TextButton(
          style: TextButton.styleFrom(
            primary: Colors.yellow, // foreground
          ),
          onPressed: () => {
            showFeedsDialog(context)
          },
          
          child: Text('Camera Views')),
				const Icon(isControllerConnected ? Icons.sports_esports : Icons.sports_esports_outlined),
				const SizedBox(width: 12),
				const Icon(Icons.battery_4_bar),
				const SizedBox(width: 12),
				const Icon(Icons.network_wifi_3_bar),
				const SizedBox(width: 12),
				Container(width: 14, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle)),	
				const SizedBox(width: 12),
			]
		)
	);
}


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