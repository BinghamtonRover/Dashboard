import "package:flutter/material.dart";

class Footer extends StatefulWidget {
	@override 
	FooterState createState() => FooterState();
}

class FooterState extends State<Footer> {
	bool isControllerConnected = true;

	@override
	Widget build(BuildContext context) => Container(
		height: 48,
		color: Colors.blue,
		child: Row(
			mainAxisAlignment: MainAxisAlignment.end,
			children: [
				IconButton(
					onPressed: () => setState(() => isControllerConnected = !isControllerConnected),
					icon: Icon(isControllerConnected ? Icons.sports_esports : Icons.sports_esports_outlined),
				),
				SizedBox(width: 12),
				const Icon(Icons.battery_4_bar),
				SizedBox(width: 12),
				const Icon(Icons.network_wifi_3_bar),
				SizedBox(width: 12),
			]
		)
	);
}
