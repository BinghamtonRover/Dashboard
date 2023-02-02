import "dart:typed_data";

import "package:flutter_libserialport/flutter_libserialport.dart";

import "serial_errors.dart";
import "service.dart";

export "serial_errors.dart";

/// A service to interact with Serial Port(s) from dashboard.
/// 
/// Since a device may not be connected right away, or may be disconnected after the dashboard is
/// running, this service needs to explicitly connect to a device using [connect]. The device may
/// be disconnected by calling [disconnect]. In any event, [dispose] will also call [disconnect].
class Serial extends Service {
	/// Writes data to the serial device. 
	/// 
	/// This field is only non-null after calling [connect] successfully.
	SerialPort? _writer;

	/// Reads data from the serial device.
	/// 
	/// This field is only non-null after calling [connect] successfully.
	SerialPortReader? _reader;

	@override
	Future<void> init() async {}

	@override
	Future<void> dispose() async {
		_writer?.dispose();
		_reader?.close();
	}

	/// Connects a device to the dashboard for reading and writing.
	/// 
	/// - If no devices are found, this will throw [NoDeviceFound].
	/// - If multiple devices are found, this will throw [MultipleDevicesFound].
	Future<void> connect() async {
		final List<String> devices = SerialPort.availablePorts;
		if (devices.isEmpty) { throw NoDeviceFound(); }
		else if (devices.length > 1) { throw MultipleDevicesFound(devices); }
		disconnect();  // only when exactly one new device is found
		final name = devices.first;
		_writer = SerialPort(name);
		_reader = SerialPortReader(_writer!);
	}

	/// Disposes of the current [_reader] and [_writer] and marks them as null.
	/// 
	/// Use this to indicate that the previous device is no longer available.
	void disconnect() {
		dispose();
		_writer = null;
		_reader = null;
	}

	/// Write data to the device.
	/// 
	/// - If no device is connected, this will throw a [DeviceNotConnected].
	/// - If there is an IO error, this will throw a [SerialPortError].
	void send(String data) {
		final Uint8List byteList = Uint8List.fromList(data.codeUnits);
		if (_writer == null) throw DeviceNotConnected();
		try {
			_writer!.write(Uint8List.fromList(byteList), timeout: 500);
		} on SerialPortError catch (error) {
			disconnect();
			throw SerialIOError(error);
		}
	}

	/// Verify that the command is the correct format
	/// It must start with ":" and end with "\n" ex: :command arg1 arg2\n
	/// Otherwise throw a format exception
	String _parseCommand(Uint8List packet) {
		final buffer = StringBuffer();
		final String data = String.fromCharCodes(packet);
		for (int i = 0; i < data.length; i++) {
			final String char = data[i];
			if (buffer.isEmpty) {
				if (char != ":") throw MalformedSerialPacket(packet: data, reason: "Command should start with :");
			} else {
				if (char == ":") throw MalformedSerialPacket(packet: data, reason: "Command cannot contain a :");
			}
			buffer.write(char);
			if (char == "\n") {
				if (i != data.length - 1){
					throw MalformedSerialPacket(packet: data, reason: "Command cannot contain a \\n");
				}
					return buffer.toString().substring(1);
				}
		}
		throw MalformedSerialPacket(packet: data, reason: "Command did not end with \n");
	}

	/// Returns a stream of all commands being sent.
	/// 
	/// - If no device is connected, this will throw a [DeviceNotConnected].
	/// - If there is an IO error, this will throw a [SerialPortError].
	Stream<String> incomingData() {
		if (_reader == null) throw DeviceNotConnected();
		try { return _reader!.stream.map(_parseCommand); }
		on SerialPortError catch (error) {
			disconnect();
			throw SerialIOError(error);
		}
	}
}
