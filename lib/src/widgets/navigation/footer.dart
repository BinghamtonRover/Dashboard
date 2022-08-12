import "package:flutter/material.dart";

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
