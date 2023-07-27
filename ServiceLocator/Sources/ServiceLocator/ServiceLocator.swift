import Foundation

/// The ServiceLocator class is a Swift implementation of the Service Locator pattern, allowing you to register and retrieve services and instances through a central registry.
/// It provides methods for registering factories and instances for various types and retrieving those registered services later.
public final class ServiceLocator {
    
    public static let shared = ServiceLocator()
    
    /// A type alias representing a closure that takes a ServiceLocator as input and returns an instance of type T.
    /// This is used to define factory functions for service types without arguments.
    public typealias Provider<T> = (ServiceLocator) -> T
    
    /// A type alias representing a closure that takes a ServiceLocator and an additional argument Arg as input and returns an instance of type T.
    /// This is used to define factory functions for service types with arguments.
    public typealias ProviderWithArg<T, Arg> = (ServiceLocator, Arg) -> T

    /// A private dictionary that holds the registered services and factory closures.
    /// The keys are strings representing the type names, and the values can be either factory closures (Provider or ProviderWithArg) or instances of registered services.
    private lazy var services: [String: Any] = [:]
    
    /// Registers a factory closure for a service type T. The closure takes a ServiceLocator as input and returns an instance of type T.
    public func factory<T>(
        _ serviceType: T.Type,
        factory: @escaping Provider<T>
    ) {
        let identifier = String(describing: T.self)
        services[identifier] = factory
    }
    
    /// Registers a factory closure for a service type T that requires an additional argument of type Arg.
    /// The closure takes a ServiceLocator and the argument Arg as input and returns an instance of type T.
    public func factory<T, Arg>(
        _ serviceType: T.Type,
        factory: @escaping ProviderWithArg<T, Arg>
    ) {
        let identifier = String(describing: T.self) + String(describing: Arg.self)
        services[identifier] = factory
    }
    
    /// Registers a singleton instance for a service type T. The instance will be returned each time the get method is called for that service type.
    public func single<T>(
        _ serviceType: T.Type,
        instance: T
    ) {
        let identifier = String(describing: T.self)
        services[identifier] = instance
    }
    
    /// Retrieves the registered instance or creates a new instance using the registered factory closure for a service type T.
    /// If no registered instance or factory is found for the service type, a fatal error is raised.
    public func get<T>() -> T {
        let identifier = String(describing: T.self)
        if let service = services[identifier] as? T {
            return service
        } else if let factory = services[identifier] as? Provider<T> {
            return factory(self)
        }
        fatalError("No registered instance found for type:\(identifier)")
    }
    
    /// Retrieves the registered instance or creates a new instance using the registered factory closure for a service type T that requires an additional argument of type Arg.
    /// If no registered instance or factory is found for the service type and argument, a fatal error is raised.
    public func get<T, Arg>(arg: Arg) -> T {
        let identifier = String(describing: T.self) + String(describing: Arg.self)
        if let service = services[identifier] as? T {
            return service
        } else if let factory = services[identifier] as? Provider<T> {
            return factory(self)
        } else if let factory = services[identifier] as? ProviderWithArg<T, Arg> {
            return factory(self, arg)
        }
        fatalError("No registered instance found for type:\(identifier) + arg:\(arg)")
    }
}
