import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// The footer, responsible for showing vitals and logs. 
class Footer extends StatelessWidget {
	/// Whether there is a controller currently connected. 
	static const bool isControllerConnected = true;

	@override
	Widget build(BuildContext context) => Container(
		height: 48,
		color: Colors.blue,
		child: Row(
			mainAxisAlignment: MainAxisAlignment.end,
			children: [
        TextButton(
          child: const Text("Select feeds", style: TextStyle(color: Colors.black)), 
          onPressed: () => showDialog(context: context, builder: (_) => SelectedFeedsChooser())
        ),
        const SizedBox(width: 12),
        const Text("Pinned feed: "),
        const SizedBox(width: 8),
        SizedBox(width: 120, child: PinnedFeedChooser()),
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

/// A menu to choose which feed is pinned.
class PinnedFeedChooser extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<VideoModel>(
    builder: (context, model, _) => DropdownButton<CameraFeed?>(
      isExpanded: true,
      onChanged: (feed) => model.pinnedFeed = feed,
      value: model.pinnedFeed,
      items: [
        const DropdownMenuItem(child: Text("None")),
        for (final CameraFeed feed in feeds) 
          if (feed.isActive) DropdownMenuItem(
            value: feed,
            child: Text(feed.name),
          ),
      ],
    )
  );
}

/// A menu to choose which feeds are visible.
class SelectedFeedsChooser extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<VideoModel>(
    builder: (context, model, _) => AlertDialog(
      title: const Text("Select Feeds"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final CameraFeed feed in feeds) CheckboxListTile(
            title: Text(feed.name),
            value: feed.isActive,
            onChanged: (_) => model.toggleFeed(feed),
          )
        ],
      )
    )
  );
}
