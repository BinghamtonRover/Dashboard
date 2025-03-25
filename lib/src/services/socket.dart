import "dart:async";

import "package:burt_network/burt_network.dart";
import "package:flutter/foundation.dart"; // <-- Used for ValueNotifier

import "package:rover_dashboard/models.dart";

/// A service to send and receive Protobuf messages over a UDP socket, using [BurtSocket].
///
/// This class monitors its connection to the given [device] by sending heartbeats periodically and
/// logging the response (or lack thereof). To be notified of connection events, add a listener to [connectionStatus].
/// To be notified of incoming messages, listen to the [messages] stream that streams incoming [WrappedMessage].
///
/// To use this class:
/// - Call [init] to open the socket.
/// - Check [connectionStrength] or [isConnected] for the connection to the given [device].
/// - To send a message, call [sendMessage].
/// - Call [dispose] to close the socket.
class DashboardSocket extends BurtSocket with RoverTimesync {
  /// Notifier for when the socket connects or disconnects
  final ValueNotifier<bool> connectionStatus = ValueNotifier(false);

  /// Number of times to check heart beat per seconds based on `models.settings.network.connectionTimeout`.
  double get frequency => models.settings.network.connectionTimeout;

  late final bool _sendTimesync;

  @override
  bool get shouldSendTimesync => _sendTimesync;

  /// Listens for incoming messages on a UDP socket and sends heartbeats to the [device].
  DashboardSocket({
    required super.device,
    bool sendTimesync = false,
    super.timesyncAddress,
  }) : _sendTimesync = sendTimesync,
       super(port: null, quiet: true, keepDestination: true);

  @override
  Duration get heartbeatInterval => Duration(milliseconds: 1000 ~/ frequency);

  /// The connection strength, as a percentage to this [device].
  final connectionStrength = ValueNotifier<double>(0);

  /// The number of heartbeats received since the last heartbeat was sent.
  int _heartbeats = 0;

  /// Whether [checkHeartbeats] is still running.
  bool _isChecking = false;

  /// Whether the socket should be sending data over UDP
  bool isEnabled = true;

  /// Whether this socket has a stable connection to the [device].
  @override
  bool get isConnected => connectionStrength.value > 0;

  @override
  void onHeartbeat(Connect heartbeat, SocketInfo source) => _heartbeats++;

  @override
  Future<void> onSettings(NetworkSettings settings) async {}

  @override
  Future<void> checkHeartbeats() async {
    if (_isChecking || !isEnabled) return;
    // 1. Clear state and send a heartbeat
    _isChecking = true;
    _heartbeats = 0;
    final wasConnected = isConnected;
    sendMessage(Connect(sender: Device.DASHBOARD, receiver: device));
    // 2. Wait a bit and count the number of responses
    await Future<void>.delayed(heartbeatWaitDelay);
    if (_heartbeats > 0) {
      connectionStrength.value += connectionIncrement * _heartbeats;
    } else {
      connectionStrength.value -= connectionIncrement;
    }
    // 3. Assess the current state
    connectionStrength.value = connectionStrength.value.clamp(0, 1);
    if (isConnected && !wasConnected) connectionStatus.value = true;
    if (wasConnected && !isConnected) connectionStatus.value = false;
    _isChecking = false;
  }

  @override
  void sendMessage(Message message, {SocketInfo? destination}) => sendWrapper(
    message.wrap(models.sockets.timestamp),
    destination: destination,
  );

  @override
  void send(List<int> data, {SocketInfo? destination}) {
    if (!isEnabled) return;
    super.send(data, destination: destination);
  }

  /// Enables the socket, which will allow messages to be sent over UDP
  void enable() {
    isEnabled = true;
  }

  /// Disables the socket, which will block any data from being sent
  /// over the network, regardless of the destination
  void disable() {
    isEnabled = false;
    _heartbeats = 0;
    connectionStrength.value = 0;
    connectionStatus.value = false;
  }

  /// How much each successful/missed handshake is worth, as a percent.
  double get connectionIncrement => 1 / frequency;

  /// How long to wait for incoming heartbeats after sending them out.
  Duration get heartbeatWaitDelay => Duration(milliseconds: 1000 ~/ frequency);
}
