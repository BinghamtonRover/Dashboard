import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/pages.dart";

/// Preset for the dashboard.
class ViewPreset {
  /// Preset name.
  final String? name;

  /// List of views that comes with the views name (and if it is a camera view, its camera name).
  final List<DashboardView> views;

  /// Ratio of the controller for the resizable row on top.
  final  List<double> horizontal1;

  /// Ratio of the controller for resizable row on bottom.
  final List<double> horizontal2;

  /// Ratio of the controller for screen 2's first row.
  final List<double> horizontal3;

  /// Ratio of the controller for screen 2's second row.
  final List<double> horizontal4;

  /// Ratio of the controller for the resizable column.
  final List<double> vertical1;

  /// The vertical controller for screen 2.
  final List<double> vertical2;

  /// A const constructor.
  ViewPreset({
    required this.name,
    required this.views,
    required this.horizontal1,
    required this.horizontal2,
    required this.vertical1,
    required this.vertical2,
    required this.horizontal3,
    required this.horizontal4,
  });

  /// Parses a view preset from JSON.
  ViewPreset.fromJson(Json? json) :
    name = json?["name"] ?? "NoName",
    views = json?["views"] ?? [],
    horizontal1 = json?["horizontal1"],
    horizontal2 = json?["horizontal2"],
    horizontal3 = json?["horizontal3"],
    horizontal4 = json?["horizontal4"],
    vertical1 = json?["vertical1"],
    vertical2 = json?["vertical2"];

  /// Serializes a view preset to JSON.
  Json toJson() => {
    "name": name,
    "views" : views,
    "horizontal1" : horizontal1,
    "horizontal2" : horizontal2,
    "horizontal3" : horizontal3,
    "horizontal4" : horizontal4,
    "vertical1" : vertical1,
    "vertical2" : vertical2,
  };
}
