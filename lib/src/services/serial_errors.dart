import "dart:typed_data";

import "package:flutter_libserialport/flutter_libserialport.dart";
import "package:rover_dashboard/errors.dart";

/// The base class for all exceptions relating to using Serial devices.
class SerialException extends DashboardException { 
  /// Provides a const constructor.
  const SerialException();
}

/// Indicates that no devices are available to connect to.
class NoDeviceFound extends SerialException {
  @override
  String toString() => "No available serial device found.";
}

/// Indicates that multiple devices are available to connect to.
class MultipleDevicesFound extends SerialException {
  /// The list of available devices.
  final List<String> devices;

  /// Creates an error that contains the list of available devices.
  const MultipleDevicesFound(this.devices);

  @override
  String toString() => "Multiple serial devices were found: ${devices.join(', ')}";
}

/// Indicates that no device has been connected.
class DeviceNotConnected extends SerialException {
  @override
  String toString() => "No device was chosen. Please connect by calling Serial.connect() first.";
}

/// Indicates that a data packet has come malformed. 
/// 
/// Similar to a [FormatException], but this usually indicates a hardware or 
/// physical connection issue to the serial device.
class MalformedSerialPacket extends SerialException {
  /// The malformed packet.
  final Uint8List packet;
  
  /// Creates an error about a malformed packet.
  const MalformedSerialPacket({required this.packet});

  @override
  String toString() => "Malformed serial packet: $packet.";
}

/// Indicates that the Serial device did not reciprocate the handshake.
/// 
/// In particular, the device sent back a "Connect" message, but the fields
/// weren't set properly.
class SerialHandshakeFailed extends SerialException { 
  @override 
  String toString() => "Connection handshake failed";
}

/// Indicates that the port could not be opened.
/// 
/// This usually means another process has an open handle on the port.
class SerialCannotOpen extends SerialException {
  /// The port that failed to open.
  final String port;

  /// Creates an error about a port that won't open.
  const SerialCannotOpen(this.port);

  @override
  String toString() => "Could not open port $port";
}

/// Indicates that the device is unreachable.
/// 
/// This is simply a [SerialPortError] wrapped up as a [SerialException].
class SerialIOError extends SerialException {
  /// The underlying IO error thrown by the `libserialport` library.
  final SerialPortError error;

  /// Creates an [SerialException] to represent a [SerialPortError].
  const SerialIOError(this.error);

  @override
  String toString() => error.toString();
}
