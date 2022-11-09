import "package:flutter/material.dart";
import "camera_feed.dart";

/// the ChangeNotifier object 
class FeedsNotifier extends ChangeNotifier {
  /// list of the camera feeds
  List<CameraFeed> feeds = [];

  /// the number of windows on the dashboard
  int numPages = 0;

  /// the number of camera feeds on the current page
  int currentPage = -1;

  /// constructor with the camera feeds passed in as a list
  FeedsNotifier(this.feeds, this.numPages) {
    currentPage = feeds.where((element) => element.showing && element.page == currentPage).length;
  }

  /// function to be called when the values are changed and the widgets need to be updated
  void onChange() {
    //log("changing");
    notifyListeners();
  }
}