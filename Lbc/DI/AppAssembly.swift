import Domain
import Foundation
import ServiceLocator

enum AppAssembly: Assembly {
    
    static func register(serviceLocator: ServiceLocator) {
        /*
         We'll manage a ListingViewModel singleton instance to be accessed via both
         ListingViewController and CategoriesViewController. A more powerful DI framework could
         of course manage the shared instance scoping it to a session or the ViewControllers life cycle.
         */
        serviceLocator.single(
            ListingViewModel.self,
            instance: ListingViewModel(
                getCategoriesUseCase: serviceLocator.get(),
                getSortedClassifiedAdsUseCase: serviceLocator.get()
            )
        )
        
        serviceLocator.factory(
            ClassifiedAdDetailViewModel.self,
            factory: { serviceLocator in
                .init(
                    getClassifiedAdUseCase: serviceLocator.get()
                )
            }
        )
        
        serviceLocator.factory(
            MainCoordinator.self,
            factory: { serviceLocator in
                .init(
                    serviceLocator: serviceLocator
                )
            }
        )
        
        serviceLocator.factory(
            ListingViewController.self,
            factory: { (serviceLocator, coordinator: MainCoordinator) in
                .init(
                    viewModel: serviceLocator.get(),
                    coordinator: coordinator
                )
            }
        )
        
        serviceLocator.factory(
            CategoriesViewController.self,
            factory: { (serviceLocator, coordinator: MainCoordinator) in
                .init(
                    viewModel: serviceLocator.get(),
                    coordinator: coordinator
                )
            }
        )
        
        serviceLocator.factory(
            ClassifiedAdDetailViewController.self,
            factory: { serviceLocator, itemId in
                .init(
                    itemId: itemId,
                    viewModel: serviceLocator.get()
                )
            }
        )
    }
}
