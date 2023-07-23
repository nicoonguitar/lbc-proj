import Foundation
import Domain
import ServiceLocator

/*
 Runtime support for parameterized protocol types is only available in iOS 16.0.0 or newer
 */

public final class DataAssembly: Assembly {
    
    public static func register(serviceLocator: ServiceLocator) {
        // TODO: register APIClient
        
        serviceLocator.single(
            (any CategoryRepository).self,
            instance: CategoryRepositoryImpl(
                apiClient: serviceLocator.get(),
                inMemoryCache: CategoryInMemoryCache.shared
            )
        )
        
        serviceLocator.single(
            (any ItemRepository).self,
            instance: ItemRepositoryImpl(
                apiClient: serviceLocator.get(),
                inMemoryCache: ItemsInMemoryCache.shared
            )
        )
    }
}
