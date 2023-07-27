import Foundation

/// The Assembly protocol is designed to define the common interface for assembly classes that register services with a ServiceLocator.
/// This protocol enables modularization and separation of concerns by allowing different components of the application to
/// register their respective services with the ServiceLocator.
public protocol Assembly {
    
    /// The register method is a static method defined by the Assembly protocol. Conforming classes must implement this method to register their services with the provided ServiceLocator.
    /// - Parameter serviceLocator: The ServiceLocator instance to which the assembly will register its services.
    static func register(serviceLocator: ServiceLocator)
}
