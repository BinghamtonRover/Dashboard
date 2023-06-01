import "package:rover_dashboard/data.dart";
import "package:rover_dashboard/models.dart";

/// The format to enter a GPS coordinate.
/// 
/// Internally, all the math is done in [decimal], but [GpsBuilder] supports [degrees] as well.
enum GpsType {
	/// Degrees, minutes, seconds format.
	degrees,
	/// Decimal longitude and latitude.
	decimal;

	/// The human-readable name of the GPS type.
	String get humanName => switch (this) {
		GpsType.degrees => "Degrees",
		GpsType.decimal => "Decimal",
	};
}

/// A [ValueBuilder] to modify a [GpsCoordinates] object in either [GpsType].
class GpsBuilder extends ValueBuilder<GpsCoordinates> {
	/// The format to enter a GPS coordinate.
	GpsType type = GpsType.decimal;

	/// Longitude in decimal degrees.
	final longDecimal = NumberBuilder<double>(0);
	/// Latitude in decimal degrees.
	final latDecimal = NumberBuilder<double>(0);

	/// Longitude in degrees.
	final longDegrees = NumberBuilder<int>(0);
	/// Longitude in minutes.
	final longMinutes = NumberBuilder<int>(0);
	/// Longitude in seconds.
	final longSeconds = NumberBuilder<int>(0);

	/// Latitude in degrees.
	final latDegrees = NumberBuilder<int>(0);
	/// Latitude in minutes.
	final latMinutes = NumberBuilder<int>(0);
	/// Latitude in seconds.
	final latSeconds = NumberBuilder<int>(0);

	@override
	List<NumberBuilder<dynamic>> get otherBuilders => [
		longDecimal, latDecimal,
		longDegrees, longMinutes, longSeconds,
		latDegrees, latMinutes, latSeconds,
	];

	@override
	bool get isValid => type == GpsType.decimal
		? (latDecimal.isValid && longDecimal.isValid)
		: (latDegrees.isValid && longDegrees.isValid && latMinutes.isValid && longMinutes.isValid && latSeconds.isValid && longSeconds.isValid);

	@override
	GpsCoordinates get value => switch (type) {
		GpsType.decimal => GpsCoordinates(longitude: longDecimal.value, latitude: latDecimal.value),
		GpsType.degrees => GpsCoordinates(
			longitude: longDegrees.value + (longMinutes.value / 60) + (longSeconds.value / 3600),
			latitude: latDegrees.value + (latMinutes.value / 60) + (latSeconds.value / 3600),
		),
	};

	/// Clears all the data in these text boxes.
	void clear() {
		longDecimal.clear();
		longDegrees.clear();
		longMinutes.clear();
		longSeconds.clear();

		latDecimal.clear();
		latDegrees.clear();
		latMinutes.clear();
		latSeconds.clear();
		notifyListeners();
	}

	/// Updates the [GpsType].
	void updateType(GpsType input) {
		type = input;
		notifyListeners();
	}
}
