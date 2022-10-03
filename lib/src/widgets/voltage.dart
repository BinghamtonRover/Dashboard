import "package:flutter/material.dart";
import "package:rover_dashboard/models.dart";

class VoltageWidget extends StatefulWidget {
	@override
	VoltageState createState() => VoltageState();
}

class VoltageState extends State<VoltageWidget> {
	late Vitals vitals;

	@override
	void initState() {
		super.initState();
		vitals = Vitals();
		vitals.init().then(refresh);
	}

	void refresh(_) { setState(() { }); }

	@override
	Widget build(BuildContext context) => Text("The rover has ${vitals.temperature} volts in the battery");
}
