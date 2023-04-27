import "package:flutter/material.dart";
import "package:fl_chart/fl_chart.dart";

import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/pages.dart";
import "package:rover_dashboard/widgets.dart";

class GraphsRow extends StatelessWidget {
	final List<Widget> children;
	const GraphsRow({required this.children});

	@override
	Widget build(BuildContext context) => ProviderConsumer<SettingsModel>.value(
		value: models.settings,
		builder: (model) => SizedBox(height: 300, child: model.science.scrollableGraphs
			? ListView(
				scrollDirection: Axis.horizontal, 
				children: [for (final child in children) SizedBox(width: 400, child: child)],
			)
			: Row(
				children: [for (final child in children) Expanded(child: child)]
			)
		)
	);
}

class SciencePage extends StatelessWidget {
	@override
	Widget build(BuildContext context) => ProviderConsumer<ScienceModel>(
		create: ScienceModel.new,
		builder: (model) => ListView(
			padding: const EdgeInsets.all(16),
			children: [
				Row(
					children: [
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
				if (!model.isLoading) ...[
					const SizedBox(height: 24),
					Text("Details", style: context.textTheme.titleLarge),
					const SizedBox(height: 12),
					GraphsRow(children: [
						for (final sensor in model.sensors) 
							LineChart(sensor.details)
					]),

					const SizedBox(height: 24),
					Text("Summary", style: context.textTheme.titleLarge),
					const SizedBox(height: 12),
					GraphsRow(children: [
						for (final sensor in model.sensors) 
							BarChart(sensor.summary)
					]),
					
					const SizedBox(height: 24),
					Text("Results", style: context.textTheme.titleLarge),
					const SizedBox(height: 12),
					GraphsRow(children: [
						for (final sensor in model.sensors) 
							ResultsBox(sensor)
					]),
				]
			]
		)
	);
}

class ResultsBox extends StatelessWidget {
	final ScienceSensor sensor;
	ScienceTest get test => sensor.test;

	const ResultsBox(this.sensor);

	Color get color {
		switch(test.result) {
			case ScienceResult.extinct: return Colors.red;
			case ScienceResult.extant: return Colors.green;
			case ScienceResult.notPresent: return Colors.orange;
			case ScienceResult.inconclusive: return Colors.blueGrey;
			case ScienceResult.loading: return Colors.white;
		}
	}

	String get text {
		switch(test.result) {
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
				name: test.valueName1,
				model: test.value1Builder,
				spacerFlex: 1,
			)),
			if (test.value2 != null) 
				SizedBox(height: 48, child: NumberEditor(
					name: test.valueName2!,
					model: test.value2Builder,
					spacerFlex: 1,
				)),
		]
	);
}
