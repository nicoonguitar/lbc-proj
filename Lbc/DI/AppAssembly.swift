import Domain
import Foundation
import ServiceLocator

enum AppAssembly: Assembly {
    
    static func register(serviceLocator: ServiceLocator) {
        serviceLocator.single(
            ListingViewModel.self,
            instance: ListingViewModel(
                getCategoriesUseCase: serviceLocator.get(),
                getItemUseCase: serviceLocator.get(),
                getSortedItemsUseCase: serviceLocator.get()
            )
        )
        
        serviceLocator.factory(
            ListingViewController.self,
            factory: { serviceLocator in
                .init(
                    viewModel: serviceLocator.get()
                )
            }
        )
        
        serviceLocator.factory(
            CategoriesViewController.self,
            factory: { serviceLocator in
                .init(
                    viewModel: serviceLocator.get()
                )
            }
        )
    }
}
