import "package:collection/collection.dart";
import "package:rover_dashboard/data.dart";

/// Metrics about the vision of the rover's cameras
/// 
/// This includes data such as aruco tags, and object detections
class VisionMetrics extends Metrics<DetectionResult> {
  /// A cache of detection results from different cameras
  /// 
  /// This allows several packets of data to come in from different cameras
  /// and not have them be overwriting each other
  final List<DetectionResult> cameraDetections = [];
  /// Const constructor for vision metrics
  VisionMetrics() : super(DetectionResult());
  
  @override
  List<MetricLine> get allMetrics => [
    if (cameraDetections.isEmpty)
      MetricLine("No Aruco Visible"),
    for (final detection in cameraDetections) ...[
      ...detection.arucoDetections
          .sorted((a, b) => b.area.compareTo(a.area))
          .expandIndexed((index, target) sync* {
        if (index != 0) {
          yield MetricLine("--");
        }
        yield MetricLine("Aruco #${target.tagId}:");
        yield MetricLine("  Camera: ${detection.camera.humanName}");
        yield MetricLine("  Center: (${target.centerX}, ${target.centerY})");
        yield MetricLine("  Yaw: ${target.yaw.toStringAsFixed(2)}°");
        yield MetricLine("  Pitch: ${target.pitch.toStringAsFixed(2)}°");
        yield MetricLine("  Area: ${(target.areaPercent * 100).toStringAsFixed(2)}%");
      }),
    ],
  ];
  
  @override
  String get name => "Vision";

  // This has to be overriden since otherwise it will keep appending targets to the list
  @override
  void update(DetectionResult value) {
    if (value.hasHasAruco()) {
      cameraDetections.removeWhere((result) => result.camera == value.camera);
      if (value.hasAruco.toBool()) {
        cameraDetections.add(value.deepCopy());
        cameraDetections.sort();
      }
    }
    super.update(value);
  }
  
  @override
  Version parseVersion(DetectionResult message) => message.version;

  @override
  Version get supportedVersion => Version(major: 1, minor: 0);
  
  @override
  Message get versionCommand => DetectionResult(version: Version(major: 1, minor: 0));
}
