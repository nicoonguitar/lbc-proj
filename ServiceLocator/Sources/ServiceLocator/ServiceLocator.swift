import Foundation

public final class ServiceLocator {
    
    public static let shared = ServiceLocator()
    
    public typealias Provider<T> = (ServiceLocator) -> T
    
    public typealias ProviderWithArg<T, Arg> = (ServiceLocator, Arg) -> T

    private lazy var services: [String: Any] = [:]

    public func factory<T>(
        _ serviceType: T.Type,
        factory: @escaping Provider<T>
    ) {
        let identifier = String(describing: T.self)
        services[identifier] = factory
    }
    
    public func factory<T, Arg>(
        _ serviceType: T.Type,
        factory: @escaping ProviderWithArg<T, Arg>
    ) {
        let identifier = String(describing: T.self) + String(describing: Arg.self)
        services[identifier] = factory
    }
    
    public func single<T>(
        _ serviceType: T.Type,
        instance: T
    ) {
        let identifier = String(describing: T.self)
        services[identifier] = instance
    }
    
    public func get<T>() -> T {
        let identifier = String(describing: T.self)
        if let service = services[identifier] as? T {
            return service
        } else if let factory = services[identifier] as? Provider<T> {
            return factory(self)
        }
        fatalError("No registered instance found for type:\(identifier)")
    }
    
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
