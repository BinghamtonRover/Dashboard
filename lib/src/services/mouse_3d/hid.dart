import "dart:async";
import "dart:ffi" as ffi;

import "package:ffi/ffi.dart";
import "package:rover_dashboard/src/services/mouse_3d/mouse_3d.dart";
import "package:rover_dashboard/src/services/mouse_3d/state.dart";
import "package:sdl3/sdl3.dart" as sdl;

/// The vendor ID of the 3D mouse
const int supportedVendorID = 0x256F;

/// The product ID of the 3D mouse
const int supportedProductID = 0xC635;

/// How often to read from the mouse
const Duration mouseReadInterval = Duration(milliseconds: 10);

/// The size of a payload to read from the HID mouse
// 6 bytes of data + 1 byte channel identifier
const int payloadSize = 6 + 1;

/// An implementation of a [Mouse3d] using the native
class HIDMouse3d extends Mouse3d {
  /// Default constructor for [HIDMouse3d]
  HIDMouse3d();

  Mouse3dState _lastReadState = Mouse3dState(
    x: 0,
    y: 0,
    z: 0,
    pitch: 0,
    yaw: 0,
    roll: 0,
  );

  ffi.Pointer<sdl.SdlHidDevice> _sdlDevice = ffi.nullptr;
  Timer? _readTimer;

  @override
  Future<void> init() async {
    sdl.sdlHidInit();
    final sdlDevices = sdl.sdlHidEnumerate(
      supportedVendorID,
      supportedProductID,
    );

    if (sdlDevices == ffi.nullptr) {
      sdl.sdlHidFreeEnumeration(sdlDevices);
      return;
    }

    _sdlDevice = sdl.sdlHidOpen(
      supportedVendorID,
      supportedProductID,
      sdlDevices.ref.serialNumber,
    );

    sdl.sdlHidFreeEnumeration(sdlDevices);

    if (_sdlDevice == ffi.nullptr) {
      return;
    }

    var isReading = false;
    _readTimer = Timer.periodic(mouseReadInterval, (_) async {
      if (isReading) return;
      isReading = true;
      // Update 2 times, one for axis and one for rotation
      await _update();
      await _update();
      isReading = false;

      if (!isConnected) return;
      print(
        'X: ${_lastReadState.x.toStringAsFixed(5)}\tY: ${_lastReadState.y.toStringAsFixed(5)}\tZ: ${_lastReadState.z.toStringAsFixed(5)}\tYaw: ${_lastReadState.yaw.toStringAsFixed(5)}\tPitch: ${_lastReadState.pitch.toStringAsFixed(5)}\t Roll: ${_lastReadState.roll.toStringAsFixed(5)}',
      );
    });
  }

  @override
  Future<void> dispose() async {
    _readTimer?.cancel();
    _readTimer = null;
    if (_sdlDevice != ffi.nullptr) {
      sdl.sdlHidClose(_sdlDevice);
      _sdlDevice = ffi.nullptr;
    }
  }

  @override
  Mouse3dState? getState() => _lastReadState;

  @override
  bool get isConnected => _sdlDevice != ffi.nullptr;

  int _toInt16(int byte1, int byte2) {
    var result = byte1 | (byte2 << 8);
    if (result > 32768) {
      result = -(65536 - result);
    }
    return result;
  }

  Future<void> _update() async {
    if (!isConnected) {
      return;
    }

    final rawPayload = calloc<ffi.Uint8>(payloadSize);
    final result = sdl.sdlHidReadTimeout(
      _sdlDevice,
      rawPayload,
      payloadSize,
      0,
    );
    if (result == -1) {
      calloc.free(rawPayload);
      return;
    }
    final payload = rawPayload.asTypedList(result).toList();
    calloc.free(rawPayload);
    if (payload.length < payloadSize) {
      return;
    }
    final channel = payload[0];
    // print('Channel: $channel');
    switch (channel) {
      case 1: // axis information
        final x = _toInt16(payload[1], payload[2]) / 350.0;
        final y = -1 * _toInt16(payload[3], payload[4]) / 350.0;
        final z = -1 * _toInt16(payload[5], payload[6]) / 350.0;

        // print('X: $x');
        // print('Y: $y');
        // print('Z: $z');
        // print("-------");

        _lastReadState = Mouse3dState(
          x: x,
          y: y,
          z: z,
          pitch: _lastReadState.pitch,
          yaw: _lastReadState.yaw,
          roll: _lastReadState.roll,
        );
      case 2: // rotation information
        final pitch = -1 * _toInt16(payload[1], payload[2]) / 350.0;
        final yaw = -1 * _toInt16(payload[3], payload[4]) / 350.0;
        final roll = _toInt16(payload[5], payload[6]) / 350.0;

        // print('Pitch: $pitch');
        // print('Yaw: $yaw');
        // print('Roll: $roll');

        _lastReadState = Mouse3dState(
          x: _lastReadState.x,
          y: _lastReadState.y,
          z: _lastReadState.z,
          pitch: pitch,
          yaw: yaw,
          roll: roll,
        );
      case 3: // button information
        break;
    }
  }
}
