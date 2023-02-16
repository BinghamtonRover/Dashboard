import "package:rover_dashboard/data.dart";

import "udp_client.dart";

/// A service to send [Message] objects to the rover. 
/// 
/// Be sure to call [init] and [dispose] as usual, and use [sendMessage] to 
/// send a Protobuf message to the rover's subsystems computer.
/// 
/// There are two Raspberry Pi devices on the rover. The "Subsystems Computer"
/// is responsible for sending metrics to the dashboard and receiving commands. 
/// It's IP address and port are recorded in [subsystemsPiAddress] and [subsystemsPort].
class MessageSender extends UdpClient {
	/// Opens a [UdpClient] on port 8007.
	/// 
	/// Note that this port is different from the one being used to receive the
	/// messages on the rover's end. That is fine, since they are on two separate
	/// devices and therefore have two different IP addresses.
	MessageSender({super.listenPort = dashboardSendPort});

	/// Wraps the [message] in a [WrappedMessage] container and sends it to the rover. 
	/// 
	/// You may pass in any IP address and port. The default target is the subsystems Pi.
	void sendMessage(Message message, {InternetAddress? address, int? port}) {
		// Have to use ??= instead of default parameters because addresses aren't const
		address ??= subsystemsPiAddress;
		port ??= subsystemsPort;
		sendBytes(address: address, port: port, bytes: message.wrapped.writeToBuffer());
	}
}
