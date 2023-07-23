import Foundation
import ServiceLocator

public final class DomainAssembly: Assembly {
    
    public static func register(serviceLocator: ServiceLocator) {
        serviceLocator.factory(
            GetItemsUseCase.self,
            factory: { serviceLocator in
                GetItemsUseCase(
                    itemRepository: serviceLocator.get()
                )
            }
        )
        
        serviceLocator.factory(
            GetItemsUseCase.self,
            factory: { serviceLocator in
                GetItemsUseCase(
                    itemRepository: serviceLocator.get()
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
