import Foundation
import Domain
import ServiceLocator

public enum DataAssembly: Assembly {
    
    public static func register(serviceLocator: ServiceLocator) {
        serviceLocator.single(
            APIClient.self,
            instance: APIClientImpl()
        )
        
        serviceLocator.single(
            (any CategoryRepository).self,
            instance: CategoryRepositoryImpl(
                apiClient: serviceLocator.get(),
                inMemoryCache: CategoryInMemoryCache.shared
            )
        )
        
        serviceLocator.single(
            (any ClassifiedAdRepository).self,
            instance: ClassifiedAdRepositoryImpl(
                apiClient: serviceLocator.get(),
                inMemoryCache: ClassifiedAdsInMemoryCache.shared
            )
        )
    }
}
