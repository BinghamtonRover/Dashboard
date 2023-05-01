import "dart:io";
import "package:flutter/material.dart";
import "package:file_picker/file_picker.dart";
import "package:fl_chart/fl_chart.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/services.dart";
import "package:rover_dashboard/models.dart";

/// Gets titles for a graph.
GetTitleWidgetFunction getTitles(List<String> titles) => 
	(double value, TitleMeta meta) => SideTitleWidget(
		axisSide: AxisSide.bottom,
		space: 2,
		child: Text(titles[value.toInt()])
	);

class ScienceTestBuilder with ChangeNotifier {
	final min = NumberBuilder<double>(0);
	final average = NumberBuilder<double>(0);
	final max = NumberBuilder<double>(0);

	ScienceTestBuilder() {
		min.addListener(notifyListeners);
		average.addListener(notifyListeners);
		max.addListener(notifyListeners);
	}

	@override
	void dispose() {
		min..removeListener(notifyListeners)..dispose();
		average..removeListener(notifyListeners)..dispose();
		max..removeListener(notifyListeners)..dispose();
		super.dispose();
	}

	void update(SampleData data) {
		min.value = data.min ?? 0;
		min.controller.text = min.value.toString();
		average.value = data.average ?? 0;
		average.controller.text = average.value.toString();
		max.value = data.max ?? 0;
		max.controller.text = max.value.toString();
		notifyListeners();
	}
}

class SampleAnalysis {
	final ScienceSensor sensor;

	SampleAnalysis(this.sensor);

	/// The view models for the test values.
	final testBuilder = ScienceTestBuilder();

	final SampleData data = SampleData();

	// Overrides the min/average/max values.
	ScienceResult get testResult => data.readings.isEmpty 
		? ScienceResult.loading : sensor.test(SampleData()
			..min = testBuilder.min.value
			..average = testBuilder.average.value
			..max = testBuilder.max.value
		);

	void clear() { 
		data.clear();
		testBuilder.update(data);
	}

	void addReading(Timestamp timestamp, double value) {
		data.addReading(timestamp, value);
		testBuilder.update(data);
	}
}

/// The view model for the science analysis page.
class ScienceModel with ChangeNotifier {
	int get numSamples => models.settings.science.numSamples;

	Map<ScienceSensor, List<SampleAnalysis>> allSamples = {
		for (final sensor in sensors) sensor: [
			for (int i = 0; i < models.settings.science.numSamples; i++) 
				SampleAnalysis(sensor)
		]
	};

	List<SampleAnalysis> get analysesForSample => [
		for (final sensor in sensors) allSamples[sensor]![sample]
	];

	/// The sample whose stats are being displayed.
	int sample = 0;

	@override
	void dispose() {
		for (final sample in analysesForSample) {
			sample.testBuilder.dispose();
		}
		super.dispose();
	}

	void updateSample(int? input) {
		if (input == null) return;
		for (final sample in analysesForSample) {
			sample.testBuilder.removeListener(notifyListeners);
		}
		sample = input;
		for (final sample in analysesForSample) {
			sample.testBuilder.addListener(notifyListeners);
		}
		notifyListeners();
	}

	/// Whether the page is currently loading.
	bool isLoading = false;

	/// The error, if any, that occurred while loading the data.
	String? errorText;

	void addMessage(WrappedMessage wrapper) {
		final data = wrapper.decode(ScienceData.fromBuffer);
		final sample = data.sample;
		if (sample >= numSamples) throw RangeError("Got data for sample #${sample + 1}, but there are only $numSamples samples.\nChange the number of samples in the settings and reload.");
		if (data.methane != 0) allSamples[methane]![sample].addReading(wrapper.timestamp, data.methane); 
		if (data.co2 != 0) allSamples[co2]![sample].addReading(wrapper.timestamp, data.co2); 
		if (data.humidity != 0) allSamples[humidity]![sample].addReading(wrapper.timestamp, data.humidity); 
		if (data.temperature != 0) allSamples[temperature]![sample].addReading(wrapper.timestamp, data.temperature); 
		if (data.pH != 0) allSamples[pH]![sample].addReading(wrapper.timestamp, data.pH); 
	}

	void clear() {
		for (final sensor in sensors) {
			for (final analysis in allSamples[sensor]!) {
				analysis.clear();
			}
		}
	}

	/// Calls [addMessage] for each message in the picked file.
	Future<void> loadFile() async {
		// Pick a file
		final result = await FilePicker.platform.pickFiles(
			dialogTitle: "Choose science logs",
			initialDirectory: services.files.loggingDir.path,
			type: FileType.custom,
			allowedExtensions: ["log"],
		);
		if (result == null || result.count == 0) return;
		final file = File(result.paths.first!);

		// Read the file
		isLoading = true;
		notifyListeners();
		try {
			clear();
			final messages = await services.files.readLogs(file);
			messages.forEach(addMessage);
			updateSample(0);
			errorText = null;
			isLoading = false;
			notifyListeners();
		} catch (error) {
			errorText = error.toString();
			isLoading = false;
			notifyListeners();
			rethrow;
		}
	}
}
