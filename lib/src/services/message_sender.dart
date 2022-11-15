import "package:rover_dashboard/data.dart";

import "udp_client.dart";

/// A service to send [Message] objects to the rover. 
/// 
/// Be sure to call [init] and [dispose] as usual, and use [sendMessage] to 
/// send a Protobuf message to the rover's subsystems computer.
/// 
/// There are two Raspberry Pi devices on the rover. The "Subsystems Computer"
/// is responsible for sending metrics to the dashboard and receiving commands. 
/// It's IP address and port are recorded in [roverAddress] and [roverPort].
class MessageSender extends UdpClient {
	/// The IP address of the rover's Subsystems Computer.
	static final roverAddress = InternetAddress("192.168.1.20");

	/// The port that the rover's Subsystems Computer will be listening on.
	static const int roverPort = 8002;

	/// The port that the dashboard uses to send messages to the Subsystems Computer.
	static const int dashboardSendPort = 8007;

	/// Opens a [UdpClient] on port 8007.
	/// 
	/// Note that this port is different from the one being used to receive the
	/// messages on the rover's end. That is fine, since they are on two separate
	/// devices and therefore have two different IP addresses.
	MessageSender({super.listenPort = dashboardSendPort});

	/// Wraps the [message] in a [WrappedMessage] container and sends it to the rover. 
	/// 
	/// You may pass in any IP address, but the default is [roverAddress].
	void sendMessage(Message message, {InternetAddress? address, int port = roverPort}) {
		address ??= roverAddress;  // can't be default because [InternetAddress] is not const.
		final wrapper = WrappedMessage(name: message.info_.messageName, data: message.writeToBuffer());
		super.sendBytes(address: address, port: port, bytes: wrapper.writeToBuffer());
	}
}
