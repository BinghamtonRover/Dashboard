import "package:burt_network/burt_network.dart";
export "package:burt_network/burt_network.dart" show Json, SocketInfo;

/// Which rover-like system to communicate with.
/// 
/// The ports on each [SocketInfo] will remain the same, but the IP addresses may vary.
enum RoverType { 
  /// The rover itself.
  /// 
  /// The rover has multiple computers with multiple IP addresses.
  rover, 

  /// The user's own computer.
  /// 
  /// Useful when debugging and running the rover programs locally.
  localhost,

  /// The smaller rover used for autonomy.
  /// 
  /// The tank only has one computer with one static IP address.
  tank;

  /// The human-friendly name for this [RoverType].
  String get humanName {
    switch(this) {
      case rover: return "Rover";
      case tank: return "Tank";
      case localhost: return "Local";
    }
  }
}
