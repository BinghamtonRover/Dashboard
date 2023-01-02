import "dart:typed_data";

import "package:libserialport/libserialport.dart";
import "service.dart";

/// Exception for Serial class when there are errors connecting to device
class DeviceNotConnected implements Exception {
  /// Reason for exception
  String cause;
  /// Constructor for class which takes in error message
  DeviceNotConnected(this.cause);

  @override
  String toString() => cause;
}




/// Service to interact with Serial Port(s) from dashboard
class Serial extends Service {
  /// object to send data with
  SerialPort? writer;
  /// object to read data from
  SerialPortReader? reader;

  /// Initialize the port and open for read/write
  @override
  Future<void> init() async {}

  /// Close the port 
  @override
  Future<void> dispose() async {
    writer?.dispose();
  }

  /// Initialize the port and open for read/write
  Future<void> connect() async {
    if (SerialPort.availablePorts.isEmpty) {
      throw DeviceNotConnected("No Device available to be connected to"); 
    }
    final name = SerialPort.availablePorts.first;
    writer = SerialPort(name);
    reader = SerialPortReader(writer!);
  }

  /// Write some data
  void sendBytes(String data) {
    final List<int> codeUnits = data.codeUnits;
    final Uint8List byteList = Uint8List.fromList(codeUnits);
    if(writer == null) throw DeviceNotConnected("Serial Port Writer is not connected");
    writer!.write(Uint8List.fromList(byteList), timeout: 500);
  }

  /// Verify that the command is the correct format
  /// It must start with ":" and end with "\n" ex: :command arg1 arg2\n
  /// Otherwise throw a format exception
  String parseCommand(Uint8List packet) {
    final buffer = StringBuffer();
    final String data = String.fromCharCodes(packet);
    for (int i = 0; i < data.length; i++) {
      final String char = data[i];
      if (buffer.isEmpty) {
        if (char != ":") throw const FormatException("Command should start with :");
      } else {
        if (char == ":") throw const FormatException("Command cannot contain a :");
      }
      buffer.write(char);
      if (char == "\n") {
        if (i != data.length - 1){
          throw const FormatException("Command cannot contain a \\n");
        }
          return buffer.toString().substring(1);
        }
    }
    throw const FormatException("Command did not end with \n");
  }

  /// Returns a stream of all commands being sent
  Stream<String> incomingData() {
    if(reader == null) throw DeviceNotConnected("Serial Port Reader is not connected");
    return reader!.stream.map(parseCommand);
  }
}
