import "dart:convert";
import "dart:io";
import "dart:math";

//import "package:rover_dashboard/data.dart";
import "package:protobuf/protobuf.dart" as proto;
//import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/generated/google/protobuf/timestamp.pb.dart";
import "package:rover_dashboard/generated/science.pb.dart";
import "package:rover_dashboard/generated/wrapper.pb.dart";


//export "package:protobuf/protobuf.dart" show GeneratedMessageGenericExtensions;
//import "../lib/src/data/protobuf.dart";


/// A cleaner name for any message generated by Protobuf.
typedef Message = proto.GeneratedMessage;

extension MessageUtils on Message {
	/// The name of the message as declared in the .proto file. 
	String get messageName => info_.messageName;

	/// Returns a [WrappedMessage] representing this message with a timestamp
	WrappedMessage wrap([DateTime? timestamp]) => WrappedMessage(
		data: writeToBuffer(),
		name: messageName,
		timestamp: Timestamp.fromDateTime(timestamp ?? DateTime.now()),
	);
}

/// Change these paths as needed
const oldPath = "/Users/aidanahram/Downloads/FakeData1.log";
const newPath = "/Users/aidanahram/Downloads/FakeData1New.log";

/// Return true to keep this data in the dataset, or false to remove it.
/// 
/// Not only are the sensors on the rover wonky, but the CAN bus can corrupt data along the way.
/// This function can be used to remove any unwanted bad data.
bool shouldKeepData(ScienceData data) {
	// Filter data based on reasonable thresholds:
	if (data.co2.isOutOfBounds(min: 400, max: 2000)) return false;
	if (data.methane.isOutOfBounds(min: 100, max: 500)) return false;
	if (data.pH.isOutOfBounds(min: 0, max: 14)) return false;
	if (data.humidity.isOutOfBounds(min: 0, max: 50)) return false;
	if (data.temperature.isOutOfBounds(min: 0, max: 100)) return false;

	// Any other conditions should go here: 

	return true;  // if none of the above rules are broken, then keep this data
}

/// Returns new data based on this one. To remove data, use [shouldKeepData] instead. 
/// 
/// You shouldn't need this unless you specifically need to change the *values* of the data. For example,
/// if the CO2 sensor was consistently 100ppm off, you could use this function to add 100ppm to each data.
/// 
/// NOTE: Do not modify fields that are zero, because they are likely sent in another "packet". For 
/// example, if you want to modify CO2 but `data.co2 == 0`, this packet could be, eg, a methane packet
/// and isn't meant to have any CO2 data.
WrappedMessage modifyData(Timestamp timestamp, ScienceData data) {
	// Example 1: Add 100 ppm to all CO2: 
	// if (data.co2 != 0) data.co2 += 100;
	// 
	// Example 2: Add one second to all the timestamps: 
	// timestamp += Duration(seconds: 1)

	// Wrap the data and return it. Do not delete.
	return data.wrap(timestamp.toDateTime());
}

/// Use this to add new data to your dataset.
List<WrappedMessage> newData = [
	// Adds methane=1 for every second from t=1 to t=100 seconds
	for (int t = 0; t < 100; t++) 
		ScienceData(methane: 1).wrap(DateTime.now().add(Duration(seconds: t))),

	// Adds some random methane in an increasing line between t=100 and t=200 seconds
	for (int t = 100; t < 200; t++) 
		ScienceData(methane: t + random.nextDouble() * 20).wrap(DateTime.now().add(Duration(seconds: t))),

	// Adds completely random data for t=0 to t=20 seconds, for all three samples
	for (int s = 0; s < 3; s++) 
		for (int t = 0; t < 20; t++) ScienceData(
			// sample: s, 
			temperature: t + s + (random.nextInt(10).toDouble()),
			methane: t + s + (random.nextInt(7).toDouble()),
			co2: t + s + (random.nextInt(5).toDouble()),
			humidity: t + s + (random.nextInt(13).toDouble()),
			pH: t + s + (random.nextInt(15).toDouble()),
		).wrap(DateTime.now().add(Duration(seconds: t + 1)))
];

// ==================== Do not edit unless you're Aidan or Levi ====================

final random = Random();

extension on num {
	bool isOutOfBounds({required num min, required num max}) => (this > max) || (this != 0 && this < min);
}

/// Outputs log data to the correct file based on message
Future<void> logData(WrappedMessage message) async{
  final List<int> bytes = message.writeToBuffer();
  final line = base64.encode(bytes);
  final file = File(newPath);
  await file.writeAsString("$line\n", mode: FileMode.append, flush: true);
}

/// Reads logs from the given file.
Future<List<WrappedMessage>> readLogs(File file) async => [
  for (final line in (await file.readAsString()).trim().split("\n"))
    WrappedMessage.fromBuffer(base64.decode(line))
];

void main() async {
	int pruned = 0;
	if (File(newPath).existsSync()) await File(newPath).delete();
	final List<WrappedMessage> oldData = await readLogs(File(oldPath));
	for (final wrapper in oldData) {
		final data = ScienceData.fromBuffer(wrapper.data);
		if (!shouldKeepData(data)) { pruned++; continue; }
		else { await logData(modifyData(wrapper.timestamp, data)); }
	}
	print("Pruned $pruned rows of data");  // ignore: avoid_print
}

// ==================== Do not edit unless you're Aidan or Levi ====================
