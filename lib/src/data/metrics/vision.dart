import "package:collection/collection.dart";
import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/services.dart";

/// Metrics about the vision of the rover's cameras
/// 
/// This includes data such as aruco tags, and object detections
class VisionMetrics extends Metrics<VisionResult> {
  /// A cache of detection results from different cameras
  /// 
  /// This allows several packets of data to come in from different cameras
  /// and not have them be overwriting each other
  final List<VisionResult> cameraDetections = [];
  /// Const constructor for vision metrics
  VisionMetrics() : super(VisionResult());
  
  @override
  List<MetricLine> get allMetrics => [
    if (cameraDetections.isEmpty)
      MetricLine("No Aruco Visible"),
    for (final detection in cameraDetections) ...[
      ...detection.objects
          .sorted((a, b) => b.relativeSize.compareTo(a.relativeSize))
          .expandIndexed((index, target) sync* {
        if (index != 0) {
          yield MetricLine("--");
        }
        yield MetricLine("Aruco #${target.arucoTagId}:");
        yield MetricLine("  Camera: ${detection.name.humanName}");
        yield MetricLine("  Center: (${target.centerX}, ${target.centerY})");
        yield MetricLine("  Yaw: ${target.yaw.toStringAsFixed(2)}°");
        yield MetricLine("  Pitch: ${target.pitch.toStringAsFixed(2)}°");
        yield MetricLine("  Area: ${(target.relativeSize * 100).toStringAsFixed(2)}%");
        if (target.hasBestPnpResult()) {
          yield MetricLine("  3D Pose Estimation:");
          final bestPose = target.bestPnpResult.cameraToTarget;
          yield MetricLine("    Best Camera to Target:");
          yield MetricLine("      x: ${bestPose.translation.x.toStringAsFixed(3)}m");
          yield MetricLine("      y: ${bestPose.translation.y.toStringAsFixed(3)}m");
          yield MetricLine("      z: ${bestPose.translation.z.toStringAsFixed(3)}m");
          yield MetricLine("      roll: ${bestPose.rotation.x.toStringAsFixed(2)}°");
          yield MetricLine("      pitch: ${bestPose.rotation.y.toStringAsFixed(2)}°");
          yield MetricLine("      yaw: ${bestPose.rotation.z.toStringAsFixed(2)}°");
          yield MetricLine("    Best Reprojection Error: ${target.bestPnpResult.reprojectionError.toStringAsFixed(3)}");
        }
      }),
    ],
  ];
  
  @override
  String get name => "Vision";

  // This has to be overriden since otherwise it will keep appending targets to the list
  @override
  void update(VisionResult value) {
    if (!checkVersion(value)) return;    
    cameraDetections.removeWhere((result) => result.name == value.name);
    if (value.objects.isNotEmpty) {
      cameraDetections.add(value.deepCopy());
      cameraDetections.sort();
    }
		services.files.logData(value);
		notifyListeners();
  }
  
  @override
  Version parseVersion(VisionResult message) => message.version;

  @override
  Version get supportedVersion => Version(major: 1, minor: 0);
  
  @override
  Message get versionCommand => VisionResult(version: Version(major: 1, minor: 0));
}
