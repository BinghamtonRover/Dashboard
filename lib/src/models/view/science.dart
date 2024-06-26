import "dart:io";
import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";

/// A view model to allow the user to override values supplied to [ScienceTest]s.
class ScienceTestBuilder with ChangeNotifier {
	/// An override for the minimum value.
	final min = NumberBuilder<double>(0);

	/// An override for the average value.
	final average = NumberBuilder<double>(0);

	/// An override for the maximum value.
	final max = NumberBuilder<double>(0);

	/// A constructor.
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

	/// Updates the view models with the latest data.
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

/// Analysis for one sample and sensor.
class ScienceAnalysis {
	/// The sensor being analyzed.
	final ScienceSensor sensor;

	/// A constructor.
	ScienceAnalysis(this.sensor);

	/// The view models for the test values.
	final testBuilder = ScienceTestBuilder();

	/// The data being recorded.
	final SampleData data = SampleData();

	/// Passes the overriden data to the sensor's test to determine signs of life.
	ScienceResult get testResult => data.readings.isEmpty 
		? ScienceResult.loading : sensor.test(SampleData()
			..min = testBuilder.min.value
			..average = testBuilder.average.value
			..max = testBuilder.max.value,
		);

	/// Clears all readings from this analysis.
	void clear() { 
		data.clear();
		testBuilder.update(data);
	}

	/// Adds a reading to this analysis.
	void addReading(Timestamp timestamp, double value) {
		data.addReading(timestamp, value);
		testBuilder.update(data);
	}
}

/// The view model for the science analysis page.
class ScienceModel with ChangeNotifier {
	/// How many samples to analyze. Can be changed in the settings.
	int get numSamples => models.settings.science.numSamples;

	/// A list of all the samples for all the sensors.
	Map<ScienceSensor, List<ScienceAnalysis>> allSamples = {
		for (final sensor in sensors) sensor: [
			for (int i = 0; i < models.settings.science.numSamples; i++) 
				ScienceAnalysis(sensor),
		],
	};

	/// The [Metrics] model for science data.
	ScienceMetrics get metrics => models.rover.metrics.science;

	/// Whether to listen for new data from the rover. This is false after loading a file.
	bool isListening = true;

	/// Listens to all the [ScienceTestBuilder]s in the UI.
	ScienceModel() {
		metrics.addListener(updateData);
		for (final sample in analysesForSample) {
			sample.testBuilder.addListener(notifyListeners);
		}
	}

	/// All the sensors for the current [sample].
	List<ScienceAnalysis> get analysesForSample => [
		for (final sensor in sensors) allSamples[sensor]![sample],
	];

	/// The sample whose stats are being displayed.
	int sample = 0;

	@override
	void dispose() {
		metrics.removeListener(updateData);
		for (final sample in analysesForSample) {
			sample.testBuilder.dispose();
		}
		super.dispose();
	}

	/// Updates the graph using [addMessage] with the latest data from [metrics].
	void updateData() {
		if (!isListening) return;
		addMessage(metrics.data.wrap());
		notifyListeners();
	}

	/// Updates the [sample] variable.
	void updateSample(int? input) {
		if (input == null) return;
		sample = input;
		notifyListeners();
	}

	/// Whether the page is currently loading.
	bool isLoading = false;

	/// The error, if any, that occurred while loading the data.
	String? errorText;

  /// Adds a value to the correct analysis for the sensor and sample.
  void addReading(ScienceSensor sensor, int sample, Timestamp timestamp, double value) => 
    allSamples[sensor]![sample].addReading(timestamp, value);

	/// Adds a [WrappedMessage] containing a [ScienceData] to the UI.
	void addMessage(WrappedMessage wrapper) {
		if (!wrapper.name.contains(ScienceData().messageName)) throw ArgumentError("Incorrect log type: ${wrapper.name}");
		final data = wrapper.decode(ScienceData.fromBuffer);
		final sample = data.sample;
		if (!wrapper.hasTimestamp()) { throw ArgumentError("Data is missing a timestamp"); }
		if (sample >= numSamples) throw RangeError("Got data for sample #${sample + 1}, but there are only $numSamples samples.\nChange the number of samples in the settings and reload.");
		if (data.co2 != 0) addReading(co2, sample, wrapper.timestamp, data.co2); 
		if (data.humidity != 0) addReading(humidity, sample, wrapper.timestamp, data.humidity); 
		if (data.temperature != 0) addReading(temperature, sample, wrapper.timestamp, data.temperature); 
	}

	/// Clears all the readings from all the samples.
	void clear() {
		for (final sensor in sensors) {
			for (final analysis in allSamples[sensor]!) {
				analysis.clear();
			}
		}
		isListening = true;
		models.home.setMessage(severity: Severity.info, text: "Science UI will update on new data");
	}

	/// Calls [addMessage] for each message in the picked file.
	Future<void> loadFile() async {
		// Pick a file
		clear();
		isLoading = true;
		notifyListeners();
		final result = await FilePicker.platform.pickFiles(
			dialogTitle: "Choose science logs",
			initialDirectory: services.files.loggingDir.path,
		);
		if (result == null || result.count == 0) {
			isLoading = false;
			notifyListeners();
			return;
		}

		// Read the file
		final file = File(result.paths.first!);
		try {
			final messages = await services.files.readLogs(file);
			messages.forEach(addMessage);
			errorText = null;
			isLoading = false;
			isListening = false;
			models.home.setMessage(severity: Severity.info, text: "Science logs loaded, new data will be ignored");
			notifyListeners();
		} catch (error) {
			errorText = error.toString();
			isLoading = false;
			notifyListeners();
			rethrow;
		}
	}
}
