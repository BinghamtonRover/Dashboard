/// The base class for all exceptions thrown by the dashboard. 
/// 
/// When handling errors, you can either `catch` a specific class of errors or all errors at once.
/// If you know which error or exception to expect, that works, but catching *all* errors could 
/// hide important ones that are meant to be fixed. This class defines the parent class of all 
/// exceptions the dashboard would throw on its own, which means higher-level functions can use
/// this class to catch them and indicate an operation failed. 
/// 
/// Exceptions are different than errors. An error indicates faulty code, while an exception means
/// the underlying cause can be addressed even if it requires human intervention. All error cases
/// that need to be caught and handled -- even if that means simply alerting the user -- should
/// therefore be exceptions. For more information, see [Exception] vs [Error].
/// 
/// When creating your own exception, be sure to override [toString] with a helpful message.
class DashboardException implements Exception { 
	/// Provides a const constructor.
	const DashboardException();
}
