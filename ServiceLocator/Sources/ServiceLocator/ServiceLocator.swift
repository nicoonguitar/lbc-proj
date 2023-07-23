import Foundation

public final class ServiceLocator {
    
    public static let shared = ServiceLocator()
    
    public typealias Provider<T> = (ServiceLocator) -> T
    
    private lazy var services: [String: Any] = [:]

    public func factory<T>(
        _ serviceType: T.Type,
        factory: @escaping Provider<T>
    ) {
        let identifier = String(describing: T.self)
        services[identifier] = factory(self)
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
}
