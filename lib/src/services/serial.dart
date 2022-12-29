import "dart:convert";
import "dart:typed_data";

import "package:libserialport/libserialport.dart";
import "service.dart";

/// Json Structure
typedef Json = Map<String, dynamic>;

/// Service to interact with Serial Port(s) from dashboard
class Serial extends Service {
  /// Port to interact with
  SerialPort? port;
  SerialPortReader? reader;

  /// Initialize the port and open for read/write
  @override
  Future<void> init() async {
    if (SerialPort.availablePorts.isEmpty) {
      return; // raise error
    }
    final name = SerialPort.availablePorts.first;
    port = SerialPort(name);
    reader = SerialPortReader(port!);
  }

  /// Close the port
  @override
  Future<void> dispose() async {
    port?.dispose();
  }

  /// Write some data
  void sendBytes(String data) {
    final List<int> codeUnits = data.codeUnits;
    final Uint8List byteList = Uint8List.fromList(codeUnits);
    port?.write(Uint8List.fromList(byteList), timeout: 500);
  }

  /// Read in bytes from the serial port as a stream
  Stream<String> incomingData() => reader!.stream.map((Uint8List command) {
      if (command.first != ":".codeUnitAt(0) || command.last != 10) throw FormatException("Invalid command");
      return String.fromCharCodes(command);
    });
}


/*
  [97, 98, 99, 10] => "abc\n"
  [...] => ":precise-swivel "
*/
//void main(){
//  Serial.port
//}
