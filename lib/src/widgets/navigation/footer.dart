import "package:flutter/material.dart";
import "package:rover_dashboard/pages.dart";
import "../../models/view/camera_feed.dart";

/// The footer, responsible for showing vitals and logs. 
class Footer extends StatelessWidget {
	/// Whether there is a controller currently connected. 
	static const bool isControllerConnected = true;

  /// the pinned dropdown value
  String selected = "";

  /// Constructor passing in the list of camera feeds
  Footer() {
    selected = HomePage.feedsNotifier.feeds.where((element) => element.pinned && element.page == HomePage.feedsNotifier.currentPage).first.shortName;
  }

  /// function call to show the camera feeds
  void showFeedsDialog(BuildContext context) {
    final List<Widget> widgetList = [];
    widgetList.add(const Text("Visible Camera Feeds"));
    for(final CameraFeed feed in HomePage.feedsNotifier.feeds.where((element) => element.page == HomePage.feedsNotifier.currentPage)) {
      widgetList.add(CheckBoxListTileInstance(feed.shortName));
    }
    widgetList.add(const Text("Pinned Camera Feed"));
    widgetList.add(const DropdownButtonInstance());
    showDialog(context: context, 
      builder: (BuildContext context) => SimpleDialog(
        title: const Text("Camera Feeds Controller"),
        children: widgetList,
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
            foregroundColor: Colors.yellow, // foreground
          ),
          onPressed: () => {
            showFeedsDialog(context)
          },
          
          child: const Text("Camera Views")),
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

/// able to change the state of the DropDownButton and have it update in real time
class DropdownButtonInstance extends StatefulWidget {
  /// constructor
  const DropdownButtonInstance({super.key});

  @override
  State<DropdownButtonInstance> createState() => _DropdownButtonInstanceState();
}

/// creating an stated object of the DropDownButtonInstance
class _DropdownButtonInstanceState extends State<DropdownButtonInstance> {
  String dropdownValue = HomePage.feedsNotifier.feeds.where((element) => element.pinned && element.page == HomePage.feedsNotifier.currentPage).first.shortName;

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
    valueListenable: HomePage.feedsListener, 
    builder: (BuildContext context, value, screensWidget) => DropdownButton<String>(
      items: HomePage.feedsNotifier.feeds.where((element) => element.page == HomePage.feedsNotifier.currentPage).map<DropdownMenuItem<String>>((CameraFeed feed) => DropdownMenuItem<String>(
        value: feed.shortName,
        child: Text(feed.shortName),
        )).toList(), 
      onChanged: (String? val) {
        HomePage.feedsNotifier.feeds.where((element) => element.pinned && element.page == HomePage.feedsNotifier.currentPage).first.pinned = false;
        HomePage.feedsNotifier.feeds.where((element) => element.shortName == val!).first.pinned = true;
        setState(() {
          dropdownValue = val!;
          HomePage.feedsNotifier.onChange();
        });
      },
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
    ),
  );
}

/// able to change the state of the CheckBoxList and have it update in real time
class CheckBoxListTileInstance extends StatefulWidget {
  /// the title of the CheckBoxListTile
  String? shortName;

  /// constructor
  CheckBoxListTileInstance(this.shortName, {super.key});

  @override
  State<CheckBoxListTileInstance> createState() => _CheckBoxListTileInstanceState();

}

/// creating a stated object of the CheckBoxListInstance
class _CheckBoxListTileInstanceState extends State<CheckBoxListTileInstance> {
  _CheckBoxListTileInstanceState();

  @override
  Widget build(BuildContext context) => CheckboxListTile(
      title: Text(widget.shortName!), 
      onChanged: (bool? value) {
        setState(() {
          HomePage.feedsNotifier.feeds.where((element) => element.shortName == widget.shortName).first.showing = value!;
          HomePage.feedsNotifier.onChange();
        });
      },
      value: HomePage.feedsNotifier.feeds.where((element) => element.shortName == widget.shortName).first.showing,
    );
  
}

