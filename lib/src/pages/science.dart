import "package:flutter/material.dart";
import "package:flutter/gestures.dart";
import "package:fl_chart/fl_chart.dart";

import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/pages.dart";
import "package:rover_dashboard/widgets.dart";

/// Allows desktop users to scroll with their mouse or other device.
class DesktopScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => { 
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
    PointerDeviceKind.trackpad,
  };
}

/// A row of scrollable or non-scrollable widgets.
class ScrollingRow extends StatelessWidget {
	/// The widgets to display.
	final List<Widget> children;
	/// Renders a row of widgets.
	const ScrollingRow({required this.children});

	@override
	Widget build(BuildContext context) => ProviderConsumer<SettingsModel>.value(
		value: models.settings,
		builder: (model) => SizedBox(height: 300, child: model.science.scrollableGraphs
			? ScrollConfiguration(
			  behavior: DesktopScrollBehavior(),
				child: ListView(
					scrollDirection: Axis.horizontal, 
					children: [for (final child in children) SizedBox(width: 400, child: child)],
				)
			)
			: Row(
				children: [for (final child in children) Expanded(child: child)]
			)
		)
	);
}

/// The science analysis page.
class SciencePage extends StatelessWidget {
	@override
	Widget build(BuildContext context) => ProviderConsumer<ScienceModel>(
		create: ScienceModel.new,
		builder: (model) => Stack(
			children: [
				ListView(
					padding: const EdgeInsets.all(16),
					children: model.isLoading ? [] : [
						const SizedBox(height: 32),
						Text("Details", style: context.textTheme.titleLarge),
						const SizedBox(height: 12),
						ScrollingRow(children: [
							for (final sensor in model.sensors) 
								LineChart(sensor.details)
						]),

						const SizedBox(height: 24),
						Text("Summary", style: context.textTheme.titleLarge),
						const SizedBox(height: 12),
						ScrollingRow(children: [
							for (final sensor in model.sensors) 
								BarChart(sensor.summary)
						]),
						
						const SizedBox(height: 24),
						Text("Results", style: context.textTheme.titleLarge),
						const SizedBox(height: 12),
						ScrollingRow(children: [
							for (final sensor in model.sensors) 
								ResultsBox(sensor)
						]),
					]
				),
				Row(
					children: [
						const SizedBox(width: 8),
						Text("Science Analysis", style: context.textTheme.headlineMedium), 
						const SizedBox(width: 12),
						if (model.isLoading) const SizedBox(height: 20, width: 20, child: CircularProgressIndicator()),
						const Spacer(),
						IconButton(
							icon: const Icon(Icons.upload_file),
							onPressed: model.uploadLogs,
						),
						const ViewsSelector(currentView: Routes.science),
					]
				),
])
	);
}

/// A box to display the final results for each sensor.
class ResultsBox extends StatelessWidget {
	/// The sensor being tested.
	final ScienceSensor sensor;

	/// The sensor's test.
	ScienceTest get test => sensor.test;

	/// Creates a widget to display the results of a science test.
	const ResultsBox(this.sensor);

	/// The color to render this box.
	Color get color {
		switch(test.test(value1: test.value1)) {
			case ScienceResult.extinct: return Colors.red;
			case ScienceResult.extant: return Colors.green;
			case ScienceResult.notPresent: return Colors.orange;
			case ScienceResult.inconclusive: return Colors.blueGrey;
			case ScienceResult.loading: return Colors.white;
		}
	}

	/// The text to display in this box.
	String get text {
		switch(test.test(value1: test.value1)) {
			case ScienceResult.extinct: return "Extinct";
			case ScienceResult.extant: return "Extant";
			case ScienceResult.notPresent: return "Not Present";
			case ScienceResult.inconclusive: return "Inconclusive";
			case ScienceResult.loading: return "Loading...";
		}
	}

	@override
	Widget build(BuildContext context) => Column(
		children: [
			Expanded(child: Container(
				margin: const EdgeInsets.all(16),
				padding: const EdgeInsets.all(8),
				color: color,
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Text(sensor.name, style: context.textTheme.titleLarge),
						const Spacer(),
						Center(child: Text(text, style: context.textTheme.headlineLarge)),
						const Spacer(),
					]
				)
			)),
			SizedBox(height: 48, child: NumberEditor(
				name: test.value1Name,
				model: test.value1Builder,
			)),
			if (test.value2 != null) 
				SizedBox(height: 48, child: NumberEditor(
					name: test.value2Name!,
					model: test.value2Builder,
				)),
		]
	);
}
