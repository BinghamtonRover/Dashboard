import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/pages.dart";

/// Preset for the dashboard.
class ViewPreset {
  /// Preset name.
  final String name;

  /// The split mode of this preset.
  final SplitMode splitMode;

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
    required this.splitMode,
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
    name = json?["name"] ?? "No Name",
    splitMode = SplitMode.values.byName(json?["splitMode"] ?? "vertical"),
    views = [
      for (final viewJson in json?["views"] ?? [])
        DashboardView.fromJson(viewJson) ?? DashboardView.blank,
    ],
    horizontal1 = List<double>.from(json?["horizontal1"] ?? []),
    horizontal2 = List<double>.from(json?["horizontal2"] ?? []),
    horizontal3 = List<double>.from(json?["horizontal3"] ?? []),
    horizontal4 = List<double>.from(json?["horizontal4"] ?? []),
    vertical1 = List<double>.from(json?["vertical1"] ?? []),
    vertical2 = List<double>.from(json?["vertical2"] ?? []);

  /// Serializes a view preset to JSON.
  Json toJson() => {
    "name": name,
    "splitMode": splitMode.name,
    "views" : views,
    "horizontal1" : horizontal1,
    "horizontal2" : horizontal2,
    "horizontal3" : horizontal3,
    "horizontal4" : horizontal4,
    "vertical1" : vertical1,
    "vertical2" : vertical2,
  };
}
