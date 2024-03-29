import "package:flutter/material.dart";
import "dart:collection"; 

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// The view model for the electrical analysis page.
class ElectricalModel with ChangeNotifier {
	/// The [Metrics] model for electrical data.
	ElectricalMetrics get metrics => models.rover.metrics.electrical;
  
  /// The timestamp of the first or earliest reading. All other timestamps are based on this.
  Timestamp? firstTimestamp;
  
  /// Voltage readings over time.
  final DoubleLinkedQueue<SensorReading> voltageReadings = DoubleLinkedQueue<SensorReading>();

  /// Current readings over time.
  final DoubleLinkedQueue<SensorReading> currentReadings = DoubleLinkedQueue<SensorReading>();

	/// Whether to listen for new data from the rover. This is false after loading a file.
	bool isListening = true;

  /// Orientation for the graphs on page. true is column, false is stacked
  bool axis = true;

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
    firstTimestamp ??= wrapper.timestamp;
    final data = wrapper.decode(ElectricalData.fromBuffer);
    final time = wrapper.timestamp - firstTimestamp!;
    if(data.hasBatteryCurrent()) currentReadings.pushWithLimit(SensorReading(time: time, value: data.batteryCurrent), 30);
    if(data.hasBatteryVoltage()) voltageReadings.pushWithLimit(SensorReading(time: time, value: data.batteryVoltage), 30);
	}

	/// Clears all the readings from all the samples.
	void clear() {
		isListening = true;
    voltageReadings.clear();
    currentReadings.clear();
    firstTimestamp = null;
    notifyListeners();
	}

  void changeDirection(){
    axis = !axis;
    notifyListeners();
  }
}
