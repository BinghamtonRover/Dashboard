// To be generated by protobuf.
import "package:protobuf/protobuf.dart" as proto;

/// A cleaner name for any message generated by Protobuf.
typedef Message = proto.GeneratedMessage;

/// A function that decodes a Protobuf messages serialized form.
/// 
/// The `.fromBuffer` constructor is a type of [MessageDecoder]. 
typedef MessageDecoder<T extends Message> = T Function(List<int> data); 

/// A placeholder for the auto-generated wrapper message type. 
abstract class WrappedMessage extends Message {
	/// THe name of the wrapped message's type.
	final String name;
	/// The message being wrapped, in serialized form. 
	final List<int> data;

	/// Wraps another message. 
	WrappedMessage(this.name, this.data);

	/// A placeholder for the actual `Message.fromBuffer` constructor.
	external factory WrappedMessage.fromBuffer(List<int> data);

	/// Decodes the wrapped message into a message of type [T]. 
	T decode<T extends Message>(MessageDecoder<T> decoder) => decoder(data);
}
