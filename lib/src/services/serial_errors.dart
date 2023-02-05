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
  final String packet;
  
  /// The reason this packet is malformed.
  final String reason;

  /// Creates an error about a malformed packet.
  const MalformedSerialPacket({required this.packet, required this.reason});

  @override
  String toString() => "Malformed serial packet: $packet ($reason).";
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
