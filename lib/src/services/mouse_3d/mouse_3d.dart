import "dart:io";

import "package:rover_dashboard/src/services/mouse_3d/hid.dart";
import "package:rover_dashboard/src/services/mouse_3d/mock.dart";
import "package:rover_dashboard/src/services/mouse_3d/state.dart";

import "../service.dart";

/// Whether or not reading the 3D HID mouse is supported on the current platform.
bool get isHidSupported =>
    Platform.isLinux || Platform.isMacOS || Platform.isWindows;

/// Service to handle input from a 3D mouse
///
/// Use [Mouse3d.forPlatform] to create an instance of this class for the current platform
abstract class Mouse3d extends Service {
  /// Default constructor for [Mouse3d]
  Mouse3d();

  /// Creates a [Mouse3d] with the corresponding implementation based on
  /// platform support
  factory Mouse3d.forPlatform() =>
      isHidSupported ? HIDMouse3d() : MockMouse3d();

  /// The current state of the mouse
  Mouse3dState? getState();

  /// Whether or not the mouse is connected
  bool get isConnected;
}
