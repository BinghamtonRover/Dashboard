import "dart:io";

/// Json data stored as a Map.
typedef Json = Map<String, dynamic>;

/// Describes a UDP socket comprised of an IP address and a port.
class SocketConfig {
  /// The IP address of the socket.
  InternetAddress address;

  /// The port of the socket.
  int port;

  /// A constructor for this class.
  SocketConfig(this.address, this.port);

  /// Use this constructor to pass in a raw String for the address.
  SocketConfig.raw(String host, this.port) : address = InternetAddress(host);

  /// Parses the socket data from a YAML map.
  SocketConfig.fromJson(Json yaml) : 
    address = InternetAddress(yaml["host"]),
    port = yaml["port"];

  /// This socket's configuration in JSON format.
  Json toJson() => {
    "host": address.address,
    "port": port,
  };

  /// A copy of this configuration, to avoid modifying the original.
  SocketConfig copy() => SocketConfig(address, port);

  @override
  String toString() => "${address.address}:$port";
}
