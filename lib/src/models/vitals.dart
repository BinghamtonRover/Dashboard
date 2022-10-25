import "model.dart";

/// Handles incoming data about the vitals of the rover, like voltage, power and temperature.
class Vitals extends Model {
	/// The temperature of the rover, in degrees F.
	int temperature = 0;

	@override
	Future<void> init() async {
		// Subscribe to ElectricalMessages using the MessageReceiver service. 
		// When a new message arrives, update the relevant fields and call [notifyListeners].
	}

	@override 
	Future<void> dispose() async {
		// Cancel the subscription.
		super.dispose();
	}
}
