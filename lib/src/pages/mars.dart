import "package:flutter/material.dart";

import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/pages.dart";
import "package:rover_dashboard/widgets.dart";

/// The MARS page. 
/// 
/// Visualizes the orientation of the antenna relative to the rover and allows the user to manually
/// override the MARS's memory of the base station and rover's position.
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
					child: CustomPaint(
						painter: LinePainter(position: model.roverOffset, color: context.colorScheme.secondary),
					),
				),
				SizedBox.expand(
					child: CustomPaint(
						painter: LinePainter(position: model.actualOffset, color: Colors.yellow),
					),
				),
				const Center(child: Icon(Icons.home, size: 36)),  // The base station
				AnimatedAlign(  // The rover
					duration: const Duration(milliseconds: 200),
					alignment: Alignment(model.roverOffset.dx, model.roverOffset.dy),
					child: const Icon(Icons.location_on, size: 36),
				),
				],),
			),
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

/// Paints a line from the origin to the given [position] on-screen.
class LinePainter extends CustomPainter {
	/// The position to draw to, from -1 to +1.
	final Offset position;
	/// The color line to draw.
	final Color color;
	/// Draws a line to the given position.
	const LinePainter({required this.position, required this.color});

	Paint get _paint => Paint()
    ..color = color
    ..strokeCap = StrokeCap.butt
    ..strokeWidth = 8.0;

  @override
  void paint(Canvas canvas, Size size) {
  	final newPosition = (position + const Offset(1, 1)) / 2;
  	final endpoint = Offset(size.width * newPosition.dx, size.height * newPosition.dy);
  	final origin = Offset(size.width / 2, size.height / 2);
    canvas.drawLine(origin, endpoint, _paint); 
  }

  @override
  bool shouldRepaint(LinePainter oldDelegate) {
    return oldDelegate.position != position;
  }
}
