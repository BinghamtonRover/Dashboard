import "package:flutter/material.dart";
import 'package:rover_dashboard/src/services/service.dart';
import 'package:rover_dashboard/widgets.dart';

/// Camera Feed Class
class CameraFeed {
  /// complete name of the camera feed ex "Science Video Feed"
  final String fullName;
  /// shortened name of the camera feed ex "Science"
  final String shortName;
  /// boolean value of whether or not this particular camera feed is pinned
  bool pinned;
  /// boolean value of whether or not this particular camera feed is showing
  bool showing;

  /// CameraFeed constructor
  CameraFeed(this.fullName, this.shortName, {this.pinned = false, this.showing = true});
  
}