import "dart:async";

import "../model.dart";
import "core.dart";

class Rover extends Model {
	final core = RoverCore();

	bool get isConnected => core.isConnected;

	@override
	Future<void> init() async { 
		await core.init();
	}

	@override
	void dispose() {
		core.dispose();
		super.dispose();
	}

	Future<void> connect() => core.connect();
}
