import "package:rover_dashboard/src/services/mouse_3d/mouse_3d.dart";
import "package:rover_dashboard/src/services/mouse_3d/state.dart";

/// A mock implementation of a [Mouse3d]
class MockMouse3d extends Mouse3d {
  /// Default constructor for [MockMouse3d]
  MockMouse3d();

  @override
  Future<void> init() async {}

  @override
  Future<void> dispose() async {}

  @override
  Mouse3dState? getState() => null;

  @override
  bool get isConnected => false;
}
