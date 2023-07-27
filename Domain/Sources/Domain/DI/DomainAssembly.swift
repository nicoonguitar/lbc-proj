import Foundation
import ServiceLocator

public enum DomainAssembly: Assembly {
    
    public static func register(serviceLocator: ServiceLocator) {
        serviceLocator.factory(
            GetItemUseCase.self,
            factory: { serviceLocator in
                GetItemUseCase(
                    categoryRepository: serviceLocator.get(),
                    itemRepository: serviceLocator.get()
                )
            }
        )
        
        serviceLocator.factory(
            GetSortedItemsUseCase.self,
            factory: { serviceLocator in
                GetSortedItemsUseCase(
                    categoryRepository: serviceLocator.get(),
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
