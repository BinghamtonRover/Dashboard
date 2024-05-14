import "package:flutter/material.dart";
import "dart:collection"; 
import "dart:async";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// The view model for the electrical analysis page.
class ElectricalModel with ChangeNotifier {
  /// The maximum amount of readings on-screen before the data starts scrolling.
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

  /// Orientation for the graphs on page. true is row, false is column
  bool axis = false;

  /// The timer that grabs new data for these graphs.
  Timer? timer;

	/// Listens to all the [DriveMetrics] and updates the UI.
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
  }

	/// Clears all the readings from all the samples.
	void clear() {
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
