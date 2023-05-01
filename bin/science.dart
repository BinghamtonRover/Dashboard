import "dart:io";
import "dart:math";

import "package:rover_dashboard/data.dart";

/// Change these paths as needed
const oldPath = r"C:\Users\levi\Documents\Dashboard\logs\2023-4-28-18-53\ScienceData.log";
const newPath = r"C:\Users\levi\Documents\Dashboard\logs\2023-4-28-18-53\ScienceData2.log";

final random = Random();

extension on Timestamp {
	/// Use this to add a [Duration] to a [Timestamp] object.
	/// 
	/// Example: timestamp.add(Duration(seconds: 2))
	Timestamp addDuration(Duration duration) => Timestamp.fromDateTime(toDateTime().add(duration));
}

WrappedMessage? updateData(WrappedMessage wrapper) {
	// Return a new message based on this one.
	// You can return the original data, unchanged, or a new ScienceData.
	// You can also return null to erase this data from the logs.
	final ScienceData data = ScienceData.fromBuffer(wrapper.data);
	final Timestamp timestamp = wrapper.timestamp;

	// Make modifications to the data here.
	// If you want to delete the data, return null instead.
	return null;

	return WrappedMessage(
		timestamp: timestamp.addDuration(const Duration(seconds: 1)), 
		data: data.writeToBuffer(),
	);
}

List<WrappedMessage> addNewData() => [
	for (int s = 0; s < 3; s++) 
		for (int i = 0; i < 20; i++) WrappedMessage(
			timestamp: Timestamp.fromDateTime(DateTime.now().add(Duration(seconds: i + 1))), 
			data: ScienceData(
				sample: s, 
				temperature: i + s + (random.nextInt(10).toDouble()),
				methane: i + s + (random.nextInt(7).toDouble()),
				co2: i + s + (random.nextInt(5).toDouble()),
				humidity: i + s + (random.nextInt(13).toDouble()),
				pH: i + s + (random.nextInt(15).toDouble()),
			).writeToBuffer(),
		)
];










// ======= Do not edit =======

/// Outputs log data to the correct file based on message
Future<void> logData(WrappedMessage message) async {
  final List<int> bytes = message.writeToBuffer();
  final String line = bytes.join(", ");
  final file = File(newPath);
  await file.writeAsString("$line\n", mode: FileMode.writeOnlyAppend, flush: true);
}

/// Reads logs from the given file.
Future<List<WrappedMessage>> readLogs(File file) async => [
  for (final line in (await file.readAsString()).trim().split("\n"))
    WrappedMessage.fromBuffer([
      for (final byte in line.split(", ")) int.parse(byte)
    ])
];

void main() async {
	await File(newPath).delete();
	final List<WrappedMessage> oldData = await readLogs(File(oldPath));
	final List<WrappedMessage?> newData = [
		for (final data in oldData) updateData(data),
		...addNewData(),
	];
	for (final data in newData) {
		if (data == null) continue;
		await logData(data);
	}
}

// ======= Do not edit =======
