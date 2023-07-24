import Domain
import Foundation
import ServiceLocator

enum AppAssembly: Assembly {
    
    static func register(serviceLocator: ServiceLocator) {
        serviceLocator.factory(
            ListingViewModel.self,
            factory: { serviceLocator in
                .init(
                    getCategoriesUseCase: serviceLocator.get(),
                    getItemUseCase: serviceLocator.get(),
                    getSortedItemsUseCase: serviceLocator.get()
                )
            }
        )
        
        serviceLocator.factory(
            ListingViewController.self,
            factory: { serviceLocator in
                .init(
                    viewModel: serviceLocator.get()
                )
            }
        )
    }
}
