import "dart:io";
import "dart:math";
import "dart:convert";

import "package:rover_dashboard/data.dart";

/// Change these paths as needed
const oldPath = r"C:\Users\llesche1\Documents\Dashboard\logs\2023-5-5-1-7\ScienceData3.log";
const newPath = r"C:\Users\llesche1\Documents\Dashboard\logs\2023-5-5-1-7\ScienceData4.log";



WrappedMessage? updateData(WrappedMessage wrapper) {
	// Return a new message based on this one.
	// You can return the original data, unchanged, or a new ScienceData.
	// You can also return null to erase this data from the logs.
	final ScienceData data = ScienceData.fromBuffer(wrapper.data);
	final Timestamp timestamp = wrapper.timestamp;

	// Make modifications to the data here.
	// If you want to delete the data, return null instead.
	// 
	// For example, to delete messages with a pH over 14: 
	// if (data.pH > 14) return null;
	// else return data;
	if (data.methane < 10) return null;
	else return wrapper;


	if (data.co2 >= 2000) return null;
	if (data.pH > 14) return null;
	if (data.methane > 500) return null;
	if (data.humidity > 50) return null;

	else return wrapper;
	// return WrappedMessage(
	// 	timestamp: timestamp, 
	// 	data: data.writeToBuffer(),
	// 	name: "ScienceData",
	// );
}

List<WrappedMessage> addNewData() => [
	// for (int t = 0; t < 100; t++) WrappedMessage(
	// 	name: "ScienceData",
	// 	timestamp: Timestamp.fromDateTime(DateTime.now().add(Duration(seconds: t))), 
	// 	data: ScienceData(methane: 1).writeToBuffer()
	// ),

	// for (int t = 100; t < 200; t++) WrappedMessage(
	// 	name: "ScienceData",
	// 	timestamp: Timestamp.fromDateTime(DateTime.now().add(Duration(seconds: t))), 
	// 	data: ScienceData(methane: t + random.nextInt(20).toDouble()).writeToBuffer()
	// ),

	// for (int s = 0; s < 3; s++) 
	// 	for (int i = 0; i < 20; i++) WrappedMessage(
	// 		name: "ScienceData",
	// 		timestamp: Timestamp.fromDateTime(DateTime.now().add(Duration(seconds: i + 1))), 
	// 		data: ScienceData(
	// 			// sample: s, 
	// 			temperature: i + s + (random.nextInt(10).toDouble()),
	// 			methane: i + s + (random.nextInt(7).toDouble()),
	// 			co2: i + s + (random.nextInt(5).toDouble()),
	// 			humidity: i + s + (random.nextInt(13).toDouble()),
	// 			pH: i + s + (random.nextInt(15).toDouble()),
	// 		).writeToBuffer(),
	// 	),
];










// ======= Do not edit =======

final random = Random();

extension on Timestamp {
	/// Use this to add a [Duration] to a [Timestamp] object.
	/// 
	/// Example: timestamp.add(Duration(seconds: 2))
	Timestamp addDuration(Duration duration) => Timestamp.fromDateTime(toDateTime().add(duration));
}

/// Outputs log data to the correct file based on message
Future<void> logData(Message message) async{
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
	if (File(newPath).existsSync()) await File(newPath).delete();
	final List<WrappedMessage> oldData = await readLogs(File(oldPath));
	final List<WrappedMessage?> newData = [
		for (final data in oldData) updateData(data),
		...addNewData(),
	];
	int counter = 0;
	for (final data in newData) {
		if (data == null) counter++;
		if (data == null) continue;
		await logData(data);
	}
	print("Pruned $counter logs");
}

// ======= Do not edit =======
