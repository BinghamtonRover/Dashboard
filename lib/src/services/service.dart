/// A blueprint for all classes that manage a service.
/// 
/// A service is a complex out-of-app resource that is designed to be managed in a generic way but 
/// is given a rover-centric API in this project. By extending this class, services ensure that their
/// lifecycle events can be managed by the app. 
abstract class Service {
	/// Initializes the service. 
	Future<void> init();
}
