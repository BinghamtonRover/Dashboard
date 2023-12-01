extension MapRecords<K, V> on Map<K, V> {
  Iterable<(K, V)> get records sync* {
    for (final entry in entries) {
      yield (entry.key, entry.value);
    }
  }
}

extension DateTimeTimestamp on DateTime{
  String get timeStamp => "$year-$month-$day-$hour-$minute"; 
}
