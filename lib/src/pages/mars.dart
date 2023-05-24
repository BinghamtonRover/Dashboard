import "package:flutter/material.dart";

import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/pages.dart";
import "package:rover_dashboard/widgets.dart";

class MarsPage extends StatelessWidget {
	@override
	Widget build(BuildContext context) => Column(children: [
		Container(  // The header at the top
			color: context.colorScheme.surface, 
			height: 48, 
			child: Row(children: [
				const SizedBox(width: 8),
				Text("MARS", style: context.textTheme.headlineMedium), 
				const Spacer(),
				const ViewsSelector(currentView: Routes.mars),
			],),
		),
		Expanded(child: ProviderConsumer<MarsModel>(
			create: () => MarsModel(),
			builder: (model) => Stack(children: [
				const Center(child: Divider()),
				const Center(child: VerticalDivider()),
				SizedBox.expand(
					child: CustomPaint(painter: LinePainter(model.roverOffset, context.colorScheme.secondary)),
				),
				SizedBox.expand(
					child: CustomPaint(painter: LinePainter(model.actualOffset, Colors.yellow)),
				),
				const Center(child: Icon(Icons.home, size: 36)),  // The base station
				AnimatedAlign(  // The rover
					duration: const Duration(milliseconds: 200),
					// top: getPosition(model.roverX)
					alignment: Alignment(model.roverOffset.dx, model.roverOffset.dy),
					child: const Icon(Icons.location_on, size: 36),
				),
				],),
			)
		),
		const Divider(),
		ProviderConsumer<MarsCommandBuilder>(
			create: () => MarsCommandBuilder(),
			builder: (command) => Column(children: [
				Row(children: [
					Text("Override base station coordinates", style: context.textTheme.titleLarge),
					const Spacer(flex: 2),
					Expanded(child: NumberEditor(name: "Latitude", model: command.baseLatitude)),
					Expanded(child: NumberEditor(name: "Longitude", model: command.baseLongitude)),
					Expanded(child: NumberEditor(name: "Altitude", model: command.baseAltitude)),
					ElevatedButton(onPressed: command.send, child: const Text("Send")),
				],),
				Row(children: [
					Text("Override rover coordinates", style: context.textTheme.titleLarge),
					const Spacer(flex: 2),
					Expanded(child: NumberEditor(name: "Latitude", model: command.roverLatitude)),
					Expanded(child: NumberEditor(name: "Longitude", model: command.roverLongitude)),
					Expanded(child: NumberEditor(name: "Altitude", model: command.roverAltitude)),
					ElevatedButton(onPressed: command.send, child: const Text("Send")),
				],),
			],),
		),
	],);
}

class LinePainter extends CustomPainter {
	final Offset position;
	final Color color;
	LinePainter(this.position, this.color);

	Paint get _paint => Paint()
    ..color = color
    ..strokeCap = StrokeCap.butt
    ..strokeWidth = 8.0;

  @override
  void paint(Canvas canvas, Size size) {
  	final newPosition = (position + const Offset(1, 1)) / 2;
  	final endpoint = Offset(size.width * newPosition.dx, size.height * newPosition.dy);
  	final origin = Offset(size.width / 2, size.height / 2);
  	// print("Size: $size, offset: $newPosition, result: $endpoint. Origin: $origin");
    canvas.drawLine(origin, endpoint, _paint); 
  }

  @override
  bool shouldRepaint(LinePainter oldDelegate) {
    return oldDelegate.position != position;
  }
}
