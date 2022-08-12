import "package:flutter/material.dart";

/// The page for controlling the rover's arm.
class ArmMode extends StatelessWidget {
	/// A const constructor for this widget.
	const ArmMode();

	@override
	Widget build(BuildContext context) => Column(children: [
		Container(height: 100, color: Colors.green),
		const Spacer(),
		Container(height: 10, color: Colors.red),
	]);
}
