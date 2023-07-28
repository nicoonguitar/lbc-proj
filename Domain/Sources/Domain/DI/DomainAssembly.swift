import Foundation
import ServiceLocator

public enum DomainAssembly: Assembly {
    
    public static func register(serviceLocator: ServiceLocator) {
        serviceLocator.factory(
            GetClassifiedAdUseCase.self,
            factory: { serviceLocator in
                GetClassifiedAdUseCase(
                    categoryRepository: serviceLocator.get(),
                    classifiedAdRepository: serviceLocator.get()
                )
            }
        )
        
        serviceLocator.factory(
            GetSortedClassifiedAdsUseCase.self,
            factory: { serviceLocator in
                GetSortedClassifiedAdsUseCase(
                    categoryRepository: serviceLocator.get(),
                    classifiedAdRepository: serviceLocator.get()
                )
            }
        )
        
        serviceLocator.factory(
            GetCategoriesUseCase.self,
            factory: { serviceLocator in
                GetCategoriesUseCase(
                    categoryRepository: serviceLocator.get()
                )
            }
        )
    }
}
