/// The data library.
/// 
/// This library defines any data types needed by the rest of the app. While the dataclasses may 
/// have methods, the logic within should be simple, and any broad logic that changes state should
/// happen in the models library.
/// 
/// This library should be the bottom of the dependency graph, meaning that no file included in this
///  library should import any other library. 
library data;

export "src/data/generated/drive_control.pb.dart";
export "src/data/generated/sensor_control.pb.dart";
export "src/data/generated/video_control.pb.dart";
export "src/data/generated/wrapper.pb.dart";
export "src/data/metrics.dart";
export "src/data/wrapped_message.dart";
