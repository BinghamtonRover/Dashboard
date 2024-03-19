import "dart:io";
import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";
import "package:rover_dashboard/services.dart";


/// The view model for the electrical analysis page.
class ElectricalModel with ChangeNotifier {
	/// The [Metrics] model for electrical data.
	ElectricalMetrics get metrics => models.rover.metrics.electrical;
  
  /// Voltage Data
  Map<DateTime, double> voltageData = {DateTime.now() : 1.0};

  /// Current Data
  Map<DateTime, double> currentData = {};

	/// Whether to listen for new data from the rover. This is false after loading a file.
	bool isListening = true;

	/// Listens to all the [ScienceTestBuilder]s in the UI.
	ElectricalModel() {
		metrics.addListener(updateData);
	}

	@override
	void dispose() {
		metrics.removeListener(updateData);
		super.dispose();
	}

	/// Updates the graph using [addMessage] with the latest data from [metrics].
	void updateData() {
		if (!isListening) return;
		addMessage(metrics.data.wrap());
		notifyListeners();
	}

	/// Whether the page is currently loading.
	bool isLoading = false;

	/// The error, if any, that occurred while loading the data.
	String? errorText;

	/// Adds a [WrappedMessage] containing a [ElectricalData] to the UI.
	void addMessage(WrappedMessage wrapper) {
		if (wrapper.name != ElectricalData().messageName) throw ArgumentError("Incorrect log type: ${wrapper.name}");
    if (!wrapper.hasTimestamp()) { throw ArgumentError("Data is missing a timestamp"); }
    final data = wrapper.decode(ElectricalData.fromBuffer);
    final time = wrapper.timestamp.toDateTime();
    if(data.batteryVoltage != 0) voltageData[time] = data.batteryVoltage;
    if(data.batteryCurrent != 0) currentData[time] = data.batteryCurrent;
	}

	/// Clears all the readings from all the samples.
	void clear() {
		isListening = true;
    voltageData = {};
    currentData = {};
		models.home.setMessage(severity: Severity.info, text: "Electrical UI will update on new data");
	}
}
