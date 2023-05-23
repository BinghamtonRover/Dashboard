import "dart:typed_data";

import "package:flutter_libserialport/flutter_libserialport.dart";
import "package:protobuf/protobuf.dart";

import "package:rover_dashboard/data.dart";

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

	/// Device that is currently connected
	///
	/// This field is only non-null after calling [connect] successfully.
	/// This field gets assigned after revceiving response from the handshake
	Device? connectedDevice;

	@override
	Future<void> init() async {}

	@override
	Future<void> dispose() async {
		_writer?.close();
		_writer?.dispose();
		_reader?.close();
	}

	/// All the Serial ports available to connect to.
	///
	/// Not all of these will be for the firmware, so the user needs to choose the right one. To make
	/// the display cleaner, this collection filters out duplicate entries.
	Iterable<String> get availablePorts => SerialPort.availablePorts.toSet();

	/// Connects a device to the dashboard for reading and writing.
	///
	/// Sends a [Connect] message, then expects a [Connect] message in response.
	Future<void> connect(String device) async {
		await disconnect(); // only when exactly one new device is found
		_writer = SerialPort(device);
		_reader = SerialPortReader(_writer!);
		final didOpen = _writer!.openReadWrite();
		if (!didOpen) {
			await disconnect();
			throw SerialCannotOpen(device);
		}

		// Send a handshake, expect one back
		await sendMessage(Connect(sender: Device.DASHBOARD, receiver: Device.FIRMWARE));
		await Future<void>.delayed(const Duration(milliseconds: 2000));
		final received = _writer!.read(4); // nice way to read X bytes at a time
		if (received.isEmpty) throw MalformedSerialPacket(packet: received);
		try {
			final message = Connect.fromBuffer(received);
			final isValid = message.receiver == Device.DASHBOARD;
			if (!isValid) {
				await disconnect();
				throw SerialHandshakeFailed();
			}
			connectedDevice = message.sender;
		} on InvalidProtocolBufferException {
			await disconnect();
			throw MalformedSerialPacket(packet: received);
		}
	}

	/// Disposes of the current [_reader] and [_writer] and marks them as null.
	///
	/// Use this to indicate that the previous device is no longer available.
	Future<void> disconnect() async {
		await dispose();
		_writer = null;
		_reader = null;
		connectedDevice = null;
	}

	/// Sends a [Message] over Serial, without wrapping it.
	Future<void> sendMessage(Message message) => sendRaw(message.writeToBuffer());

	/// Write data to the device.
	///
	/// - If no device is connected, this will throw a [DeviceNotConnected].
	/// - If there is an IO error, this will throw a [SerialPortError].
	Future<void> sendRaw(Uint8List data) async {
		if (_writer == null) throw DeviceNotConnected();
		try {
			_writer!.write(Uint8List.fromList(data), timeout: 500);
		} on SerialPortError catch (error) {
			await disconnect();
			throw SerialIOError(error);
		}
	}

	/// Returns a stream of all commands being sent.
	///
	/// - If no device is connected, this will throw a [DeviceNotConnected].
	/// - If there is an IO error, this will throw a [SerialPortError].
	Stream<Uint8List> get incomingData {
		if (_reader == null) throw DeviceNotConnected();
		try { return _reader!.stream; }
		on SerialPortError catch (error) {
			disconnect();
			throw SerialIOError(error);
		}
	}
}
