import "package:flutter/material.dart";

import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// The view model for the electrical analysis page.
class PositionModel with ChangeNotifier {
  /// The [Metrics] model for position data.
	PositionMetrics get position => models.rover.metrics.position;

  /// The [Metrics] model for drive data.
  DriveMetrics get drive => models.rover.metrics.drive;

  /// Value for the three left wheels -- throttle * left
  double throttle = 0;
  
  /// Value for the three left wheels -- throttle * left
  double leftWheels = 0;

  /// Value for the three right wheels -- throttle * right
  double rightWheels = 0;

  /// RPM of the left wheels
  /// Left Front, Left Middle, Left Back, Right Front, Right Middle, Right Back
  final wheelsRPM = <double>[0, 0, 0, 0, 0, 0];

  /// [Color] the wheels should be displayed
  /// Used to dispay when one wheel is spinning erratically
  final wheelColors = <Color>[Colors.black, Colors.black, Colors.black, Colors.black, Colors.black, Colors.black];

  /// Listens to all the [ScienceTestBuilder]s in the UI.
	PositionModel() {
    position.addListener(_updatePositionData);
    drive.addListener(_updateDriveData);
	}

  /// Updates the UI with the latest data from [position].
	void _updatePositionData() {
		notifyListeners();
	}

  /// Updates the UI with the latest data from [drive].
	void _updateDriveData() {
    final data = drive.data;
    if(data.hasThrottle()) throttle = data.throttle;
    if(data.hasRight()) rightWheels = throttle * data.right;
    if(data.hasLeft()) leftWheels = throttle * data.left;
    if(data.hasFrontLeft()) wheelsRPM[0] = data.frontLeft;
    if(data.hasMiddleLeft()) wheelsRPM[1] = data.middleLeft;
    if(data.hasBackLeft()) wheelsRPM[2] = data.backLeft;
    if(data.hasFrontRight()) wheelsRPM[3] = data.frontRight;
    if(data.hasMiddleRight()) wheelsRPM[4] = data.middleRight;
    if(data.hasBackRight()) wheelsRPM[5] = data.backRight;
    _updateWheelColors();
		notifyListeners();
	}

  void _updateWheelColors(){
    for(var i = 0; i < 6; i++){
      wheelColors[i] = Colors.black;
    }
    final leftAvg = (wheelsRPM[0] + wheelsRPM[1] + wheelsRPM[2]) / 3;
    var maxDistance = 0.0; 
    var index = 0;
    for(var i = 0; i < 3; i++){
      if((wheelsRPM[i] - leftAvg).abs() > 100){ // Threshold is 100 difference from mean
        if((wheelsRPM[i] - leftAvg).abs() > maxDistance){
          index = i;
          maxDistance = (wheelsRPM[i] - leftAvg).abs();
        }
      }
    }
    wheelColors[index] = Colors.yellow;
    maxDistance = 0.0;
    final rightAvg = (wheelsRPM[3] + wheelsRPM[4] + wheelsRPM[5]) / 3;
    for(var i = 3; i < 6; i++){
      if((wheelsRPM[i] - rightAvg).abs() > 100){
        if((wheelsRPM[i] - rightAvg).abs() > maxDistance){
          index = i;
          maxDistance = (wheelsRPM[i] - rightAvg).abs();
        }
      } 
    }
    wheelColors[index] = Colors.yellow;
  }

  @override
	void dispose() {
		position.removeListener(_updatePositionData);
    drive.removeListener(_updateDriveData);
		super.dispose();
	}
}
