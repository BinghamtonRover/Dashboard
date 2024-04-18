import "package:flutter/material.dart";
import "dart:collection"; 
import "dart:async";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// The view model for the electrical analysis page.
class ElectricalModel with ChangeNotifier {
  static const maxReadings = 300;
  
	/// The [Metrics] model for electrical data.
	DriveMetrics get metrics => models.rover.metrics.drive;

  /// The timestamp of the first or earliest reading. All other timestamps are based on this.
  DateTime? firstTimestamp;
  
  /// Voltage readings over time.
  final DoubleLinkedQueue<SensorReading> voltageReadings = DoubleLinkedQueue<SensorReading>();

  /// Current readings over time.
  final DoubleLinkedQueue<SensorReading> currentReadings = DoubleLinkedQueue<SensorReading>();

  /// Left speed readings over time.
  final DoubleLinkedQueue<SensorReading> leftSpeeds = DoubleLinkedQueue<SensorReading>();

  /// Right speed readings over time.
  final DoubleLinkedQueue<SensorReading> rightSpeeds = DoubleLinkedQueue<SensorReading>();

	/// Whether to listen for new data from the rover. This is false after loading a file.
	bool isListening = true;

  /// Orientation for the graphs on page. true is column, false is stacked
  bool axis = true;

  Timer? timer;

	/// Listens to all the [ScienceTestBuilder]s in the UI.
	ElectricalModel() {
    metrics.addListener(_setFlag);
    timer = Timer.periodic(const Duration(milliseconds: 10), _updateData);
	}

  bool _dataReceived = false;
  void _setFlag() => _dataReceived = true;

	@override
	void dispose() {
		metrics.removeListener(_setFlag);
    timer?.cancel();
		super.dispose();
	}

	void _updateData([_]) {
		if (!isListening) return;
    if (!_dataReceived) return;
    final data = metrics.data;
    final timestamp = DateTime.now();
    firstTimestamp ??= timestamp;
    final offsetTime = timestamp.difference(firstTimestamp!).inMilliseconds.toDouble();
    leftSpeeds.pushWithLimit(SensorReading(time: offsetTime, value: data.throttle * data.left), maxReadings); 
    rightSpeeds.pushWithLimit(SensorReading(time: offsetTime, value: data.throttle * data.right), maxReadings); 
    currentReadings.pushWithLimit(SensorReading(time: offsetTime, value: data.batteryCurrent), maxReadings);
    voltageReadings.pushWithLimit(SensorReading(time: offsetTime, value: data.batteryVoltage), maxReadings);
    notifyListeners();
    _dataReceived = false;
    print("Cleared flag");
  }

	/// Clears all the readings from all the samples.
	void clear() {
		isListening = true;
    voltageReadings.clear();
    currentReadings.clear();
    leftSpeeds.clear();
    rightSpeeds.clear();
    firstTimestamp = null;
    notifyListeners();
	}

  /// Changes the axis that the UI displays the graphs
  void changeDirection(){
    axis = !axis;
    notifyListeners();
  }
}
