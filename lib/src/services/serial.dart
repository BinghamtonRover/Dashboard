import "dart:typed_data";

import "package:libserialport/libserialport.dart";
import "service.dart";

/// Service to interact with Serial Port(s) from dashboard
class Serial extends Service {
  /// object to send data with
  SerialPort? writer;
  /// object to read data from
  SerialPortReader? reader;

  /// Initialize the port and open for read/write
  @override
  Future<void> init() async {
    if (SerialPort.availablePorts.isEmpty) {
      return; // raise error
    }
    final name = SerialPort.availablePorts.first;
    writer = SerialPort(name);
    reader = SerialPortReader(writer!);
  }

  /// Close the port
  @override
  Future<void> dispose() async {
    writer?.dispose();
  }

  /// Write some data
  void sendBytes(String data) {
    final List<int> codeUnits = data.codeUnits;
    final Uint8List byteList = Uint8List.fromList(codeUnits);
    writer?.write(Uint8List.fromList(byteList), timeout: 500);
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
  Stream<String> incomingData() => reader!.stream.map(parseCommand);

}


