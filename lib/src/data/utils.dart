import "dart:collection";
import "dart:math";

/// Helpful extensions on maps.
extension MapRecords<K, V> on Map<K, V> {
  /// A list of key-value records in this map. Allows easier iteration than [entries].
  Iterable<(K, V)> get records sync* {
    for (final entry in entries) {
      yield (entry.key, entry.value);
    }
  }
}

/// Helpful extensions on [DateTime]s.
extension DateTimeTimestamp on DateTime{
  /// Formats this [DateTime] as a simple timestamp.
  String get timeStamp => "$year-$month-$day-$hour-$minute";
}

/// A list that can manage its own length.
extension LimitedList<E> on DoubleLinkedQueue<E> {
  /// Adds [element] to this list and pops an element to keep the total length within [limit].
  void pushWithLimit(E element, int limit) {
    if (length >= limit) removeFirst();
    addLast(element);
  }
}

/// Helpful utils on doubles.
extension NumUtils on double {
  /// Formats this number by rounding to 2 decimal points.
  String format() => toStringAsFixed(2);
  /// Converts this number (as radians) to degrees.
  int toDegrees() => (this * (180 / pi)).truncate();
}
