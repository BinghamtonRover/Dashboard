import "dart:typed_data";

import "package:flutter_libserialport/flutter_libserialport.dart";
import "package:protobuf/protobuf.dart";

import "package:rover_dashboard/data.dart";

import "serial_errors.dart";

export "serial_errors.dart";

/// A service to connect to a single serial device.
/// 
/// Create a new [SerialDevice] instance for every device you wish to connect to. You must call
/// [connect] before you can use the device, and you must call [dispose] when you are done.
/// 
/// To send a message, use [sendMessage]. To handle messages, pass an [onMessage] callback.
class SerialDevice {
	/// Sending this code resets the Teensy to its "unconnected" state.
	static const resetCode = [0, 0, 0, 0];
	/// A list of all available ports to connect to.
	static List<String> get availablePorts => SerialPort.availablePorts;

	/// The port to connect to.
	final String port;
	/// A callback to run whenever a message is received by this device.
	final WrappedMessageHandler onMessage;
	/// Manages a connection to a Serial device.
	SerialDevice({required this.port, required this.onMessage});

	/// The device we're connected to. 
	/// 
	/// Initially, the device is just a generic "firmware", but after calling [Connect], the Teensy
	/// will identify itself more specifically.
	Device device = Device.FIRMWARE;

	/// Writes data to the serial port.
	late final SerialPort _writer;
	/// Reads data from the serial port.
	late final SerialPortReader _reader;

	/// Opens the Serial port and identifies the device on the other end.
	Future<void> connect() async {
		await Future(_setupConnection);
		await _identifyDevice();
		_reader.stream.listen(_onData);
	}

	/// Closes the connection and resets the device.
	void dispose() {
		_writer..close()..dispose();
		_reader.close();
	}

	/// Sends a message to the device, if the device accepts it.
	/// 
	/// The firmware on the rover cannot handle [WrappedMessage]s and instead assume that all commands
	/// they receive are the type they expect. This function checks [getCommandName] to ensure that
	/// the [message] is of the correct type before sending it.
	void sendMessage(Message message) {
		final thisDeviceAccepts = getCommandName(device);
		if (message.messageName != thisDeviceAccepts) return;
		_sendRaw(message.writeToBuffer());
	}

	/// Sends raw data over the serial port.
	void _sendRaw(List<int> data) => _writer.write(Uint8List.fromList(data), timeout: 500);

	/// Sets up the connection and throws an error if the port fails to open.
	void _setupConnection() {
		_writer = SerialPort(port);
		_reader = SerialPortReader(_writer);
		final didOpen = _writer.openReadWrite();
		if (!didOpen) {
			dispose();
			throw SerialCannotOpen(port);
		}
		_sendRaw(resetCode);
	}

	/// Sends a handshake to the Teensy and decodes the response to identify the device.
	Future<void> _identifyDevice() async {
		final handshake = Connect(sender: Device.DASHBOARD, receiver: Device.FIRMWARE);
		_sendRaw(handshake.writeToBuffer());
		await Future<void>.delayed(const Duration(milliseconds: 2000));
		final received = _writer.read(4); // nice way to read X bytes at a time
		if (received.isEmpty) throw MalformedSerialPacket(packet: received);
		try {
			final message = Connect.fromBuffer(received);
			final isValid = message.receiver == Device.DASHBOARD;
			if (!isValid) {
				dispose();
				throw SerialHandshakeFailed();
			}
			device = message.sender;
		} on InvalidProtocolBufferException {
			dispose();
			throw MalformedSerialPacket(packet: received);
		}
	}

	/// Wraps the data in a [WrappedMessage] using [getDataName] as [WrappedMessage.name].
	void _onData(Uint8List data) => onMessage(
		WrappedMessage(name: getDataName(device), data: data),
	);
}
