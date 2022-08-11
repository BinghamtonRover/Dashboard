import "package:flutter/material.dart";

import "package:rover_dashboard/widgets.dart";

class ArmMode extends StatelessWidget {
	const ArmMode();

	@override
	Widget build(BuildContext context) => Column(children: [
		Container(height: 100, color: Colors.green),
		const Spacer(),
		Container(height: 10, color: Colors.red),
	]);
}
